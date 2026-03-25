import 'package:drift/drift.dart';

import 'app_tables.dart';
import 'connection/connection.dart' as impl;

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Isins,
  Tickers,
  Positions,
  MarketDataCaches,
  FeedNews,
  ChatMessages
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.createTable(feedNews);
        }
        if (from < 3) {
          await m.addColumn(feedNews, feedNews.relevanceScore);
        }
        if (from < 4) {
          await m.createTable(chatMessages);
        }
      },
    );
  }
}
