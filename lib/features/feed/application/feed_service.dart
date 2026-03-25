import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/database/drift_service.dart';
import '../../../../core/database/drift/app_database.dart';
import '../../../../core/services/ai/ai_service.dart';
import '../data/repositories/feed_repository.dart';

part 'feed_service.g.dart';

class FeedService {
  final FeedRepository _repository;
  final DriftService _driftService;
  final AiService _aiService;

  FeedService(this._repository, this._driftService, this._aiService);

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
        debugPrint('No ISINs saved, skipping feed round.');
        return;
      }

      int subround = 1;

      for (final isin in isins) {
        // Fetch news for this ISIN
        final newsList = await _repository.fetchNewsForIsin(
          isinId: isin.id,
          isinName: isin.name,
          round: newRound,
          subround: subround,
        );

        if (newsList.isNotEmpty) {
          // Get existing links to avoid duplicates
          final existingLinksQuery = db.selectOnly(db.feedNews)..addColumns([db.feedNews.link]);
          final existingLinksResult = await existingLinksQuery.get();
          final existingLinks = existingLinksResult.map((row) => row.read(db.feedNews.link)).toSet();

          // Filter out existing links
          final newNewsList = newsList.where((news) => !existingLinks.contains(news.link)).toList();

          if (newNewsList.isNotEmpty) {
            // Insert into database
            await db.batch((batch) {
              for (final news in newNewsList) {
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
                    ));
              }
            });
          }
        }

        // Increment subround so the next ISIN gets a higher subround within the same round
        subround++;
      }

      // Cleanup old rounds (keep last 10)
      final minRoundToKeep =
          newRound - 9; // e.g. if newRound=15, keep 6 to 15 (10 rounds)
      await (db.delete(db.feedNews)
            ..where((tbl) => tbl.round.isSmallerThanValue(minRoundToKeep)))
          .go();
    } catch (e, st) {
      debugPrint('Error during feed round: $e\n$st');
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
        debugPrint('No unrated news found.');
        return;
      }

      for (final news in unratedNews) {
        final score = await _aiService.rateNewsRelevance(news.title);

        if (score != null && score >= 1 && score <= 10) {
          await (db.update(db.feedNews)..where((tbl) => tbl.id.equals(news.id))).write(
            FeedNewsCompanion(relevanceScore: drift.Value(score)),
          );
        }
      }
    } catch (e, st) {
      debugPrint('Error analyzing ratings: $e\n$st');
    }
  }
}

@riverpod
FeedService feedService(FeedServiceRef ref) {
  final repository = ref.watch(feedRepositoryProvider);
  final driftServiceInstance = ref.watch(driftServiceProvider);
  final aiService = ref.watch(aiServiceProvider);
  return FeedService(repository, driftServiceInstance, aiService);
}
