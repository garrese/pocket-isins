import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/database/drift_service.dart';
import '../../../../core/database/drift/app_database.dart';
import '../../../../core/services/ai/ai_service.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../core/services/log/talker_provider.dart';
import '../data/repositories/feed_repository.dart';

part 'feed_service.g.dart';

class FeedService {
  final FeedRepository _repository;
  final DriftService _driftService;
  final AiService _aiService;
  final Talker _log;

  FeedService(this._repository, this._driftService, this._aiService, this._log);

  // Starts a new round, fetches news for each ISIN, inserts into DB sequentially
  Future<void> startNewRound() async {
    try {
      final db = _driftService.db;

      // Get the highest round currently in DB
      final roundQuery = db.selectOnly(db.feedNews)
        ..addColumns([db.feedNews.round.max()]);
      final maxRoundResult = await roundQuery.getSingle();
      final currentMaxRound = maxRoundResult.read(db.feedNews.round.max()) ?? 0;
      final newRound = currentMaxRound + 1;

      // Get all saved ISINs
      final isins = await db.select(db.isins).get();

      if (isins.isEmpty) {
        _log.info('No ISINs saved, skipping feed round.');
        return;
      }
      _log.info('Starting feed round $newRound for ${isins.length} ISINs');

      // Pre-load all existing links and titles globally to prevent duplicate news
      final existingNewsQuery = db.selectOnly(db.feedNews)
        ..addColumns([db.feedNews.link, db.feedNews.title]);
      final existingNewsResult = await existingNewsQuery.get();

      final Set<String> globalExistingLinks = {};
      final Set<String> globalExistingTitles = {};

      for (final row in existingNewsResult) {
        final link = row.read(db.feedNews.link);
        final title = row.read(db.feedNews.title);

        if (link != null) globalExistingLinks.add(link);
        if (title != null) globalExistingTitles.add(title.toLowerCase().trim());
      }

      int subround = 1;

      for (final isin in isins) {
        // Fetch news for this ISIN, passing the global sets to filter duplicates efficiently
        final newsList = await _repository.fetchNewsForIsin(
          isinId: isin.id,
          isinName:
              (isin.shortName != null && isin.shortName!.trim().isNotEmpty)
              ? isin.shortName!
              : (isin.registeredNames.isNotEmpty)
              ? isin.registeredNames.first
              : (isin.altName != null && isin.altName!.trim().isNotEmpty)
              ? isin.altName!
              : (isin.isinCode != null && isin.isinCode!.trim().isNotEmpty)
              ? isin.isinCode!
              : 'Unknown ISIN',
          round: newRound,
          subround: subround,
          existingLinks: globalExistingLinks,
          existingTitles: globalExistingTitles,
        );

        if (newsList.isNotEmpty) {
          // Insert new news into database
          await db.batch((batch) {
            for (final news in newsList) {
              batch.insert(
                db.feedNews,
                FeedNewsCompanion.insert(
                  isinId: news.isinId,
                  title: news.title,
                  link: news.link,
                  sourceUrl: news.sourceUrl,
                  sourceName: news.sourceName,
                  pubDate: news.pubDate,
                  round: news.round,
                  subround: news.subround,
                ),
              );
            }
          });
        }

        // Increment subround so the next ISIN gets a higher subround within the same round
        subround++;
      }

      // Cleanup old rounds (keep last 10)
      final minRoundToKeep =
          newRound - 9; // e.g. if newRound=15, keep 6 to 15 (10 rounds)
      await (db.delete(
        db.feedNews,
      )..where((tbl) => tbl.round.isSmallerThanValue(minRoundToKeep))).go();
    } catch (e, st) {
      _log.handle(e, st, 'Error during feed round');
    }
  }

  // Analyzes relevance ratings for news that don't have one
  Future<void> analyzeRatings() async {
    try {
      final db = _driftService.db;

      // Get all news where relevanceScore is null
      final unratedNewsQuery = db.select(db.feedNews)
        ..where((tbl) => tbl.relevanceScore.isNull());
      final unratedNews = await unratedNewsQuery.get();

      if (unratedNews.isEmpty) {
        _log.info('No unrated news found for AI analysis.');
        return;
      }

      _log.info(
        'Starting AI rating analysis for ${unratedNews.length} news items',
      );

      // Process in batches of 10
      const batchSize = 10;
      for (var i = 0; i < unratedNews.length; i += batchSize) {
        final end = (i + batchSize < unratedNews.length)
            ? i + batchSize
            : unratedNews.length;
        final batch = unratedNews.sublist(i, end);

        final newsBatchPayload = batch
            .map((news) => {'id': news.id, 'title': news.title})
            .toList();

        _log.debug(
          'AI Feed Analysis Prompt (Batch ${i ~/ batchSize + 1}):\n${newsBatchPayload.toString()}',
        );

        final results = await _aiService.rateNewsRelevanceBatch(
          newsBatchPayload,
        );

        _log.debug(
          'AI Feed Analysis Response (Batch ${i ~/ batchSize + 1}):\n${results.toString()}',
        );

        if (results.isNotEmpty) {
          await db.batch((batchWriter) {
            for (final entry in results.entries) {
              final newsId = entry.key;
              final score = entry.value;

              if (score >= 1 && score <= 10) {
                batchWriter.update(
                  db.feedNews,
                  FeedNewsCompanion(relevanceScore: drift.Value(score)),
                  where: (tbl) => tbl.id.equals(newsId),
                );
              }
            }
          });
        }
      }
    } catch (e, st) {
      _log.handle(e, st, 'Error analyzing ratings');
    }
  }

  // Deletes all feed news
  Future<void> clearFeed() async {
    try {
      final db = _driftService.db;
      await db.delete(db.feedNews).go();
    } catch (e, st) {
      debugPrint('Error clearing feed: $e\n$st');
    }
  }
}

@riverpod
FeedService feedService(FeedServiceRef ref) {
  final repository = ref.watch(feedRepositoryProvider);
  final driftServiceInstance = ref.watch(driftServiceProvider);
  final aiService = ref.watch(aiServiceProvider);
  final log = ref.watch(talkerProvider);
  return FeedService(repository, driftServiceInstance, aiService, log);
}
