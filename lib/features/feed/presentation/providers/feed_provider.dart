import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';

import '../../../../core/database/drift_service.dart';
import '../../domain/models/feed_news_model.dart';

part 'feed_provider.g.dart';

enum FeedSortOrder { natural, date, relevance }

// Provider for controlling the sort order
@riverpod
class FeedSortOrderState extends _$FeedSortOrderState {
  @override
  FeedSortOrder build() => FeedSortOrder.natural;

  void setOrder(FeedSortOrder order) {
    state = order;
  }
}

// Provider for stream of Feed News from DB
@riverpod
Stream<List<FeedNewsModel>> feedNewsStream(FeedNewsStreamRef ref) {
  final db = ref.watch(driftServiceProvider).db;
  final sortOrder = ref.watch(feedSortOrderStateProvider);

  // We want to join FeedNews with Isins to get the Isin name
  final query = db.select(db.feedNews).join([
    innerJoin(db.isins, db.isins.id.equalsExp(db.feedNews.isinId)),
  ]);

  if (sortOrder == FeedSortOrder.natural) {
    // Natural order: Newest round first, newest subround first
    // Note: since higher subround = newer inside the round, we order by round DESC, subround DESC
    query.orderBy([
      OrderingTerm(expression: db.feedNews.round, mode: OrderingMode.desc),
      OrderingTerm(expression: db.feedNews.subround, mode: OrderingMode.desc),
    ]);
  } else if (sortOrder == FeedSortOrder.relevance) {
    // Relevance order: Highest rating first. Nulls will be handled natively by sqlite (usually they go first or last depending on db, sqlite puts nulls first in ascending, so we use desc to put highest first)
    query.orderBy([
      OrderingTerm(
        expression: db.feedNews.relevanceScore,
        mode: OrderingMode.desc,
      ),
      OrderingTerm(
        expression: db.feedNews.round,
        mode: OrderingMode.desc,
      ), // secondary sort
      OrderingTerm(
        expression: db.feedNews.subround,
        mode: OrderingMode.desc,
      ), // secondary sort
    ]);
  } else {
    // Date order: Newest date first
    query.orderBy([
      OrderingTerm(expression: db.feedNews.pubDate, mode: OrderingMode.desc),
    ]);
  }

  return query.watch().map((rows) {
    return rows.map((row) {
      final newsData = row.readTable(db.feedNews);
      final isinData = row.readTable(db.isins);

      return FeedNewsModel(
        id: newsData.id,
        isinId: newsData.isinId,
        title: newsData.title,
        link: newsData.link,
        sourceUrl: newsData.sourceUrl,
        sourceName: newsData.sourceName,
        pubDate: newsData.pubDate,
        round: newsData.round,
        subround: newsData.subround,
        relevanceScore: newsData.relevanceScore,
        isinName: (isinData.shortName != null &&
                isinData.shortName!.trim().isNotEmpty)
            ? isinData.shortName!
            : (isinData.registeredNames.isNotEmpty)
                ? isinData.registeredNames.first
                : (isinData.altName != null &&
                        isinData.altName!.trim().isNotEmpty)
                    ? isinData.altName!
                    : (isinData.isinCode != null &&
                            isinData.isinCode!.trim().isNotEmpty)
                        ? isinData.isinCode!
                        : 'Unknown ISIN',
      );
    }).toList();
  });
}

@riverpod
class FeedLoadingState extends _$FeedLoadingState {
  @override
  bool build() => false;

  void setLoading(bool loading) {
    state = loading;
  }
}
