import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/database/drift_service.dart';
import '../../../../core/database/drift/app_database.dart';
import '../data/repositories/feed_repository.dart';

part 'feed_service.g.dart';

class FeedService {
  final FeedRepository _repository;
  final DriftService _driftService;

  FeedService(this._repository, this._driftService);

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
          // Insert into database
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
                  ));
            }
          });
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
}

@riverpod
FeedService feedService(FeedServiceRef ref) {
  final repository = ref.watch(feedRepositoryProvider);
  final driftServiceInstance = ref.watch(driftServiceProvider);
  return FeedService(repository, driftServiceInstance);
}
