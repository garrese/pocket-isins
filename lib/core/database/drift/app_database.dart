import 'package:drift/drift.dart';

import 'app_tables.dart';
import 'connection/connection.dart' as impl;

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Isins, Tickers, MarketDataCaches, FeedNews, ChatMessages],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 6;

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
        if (from < 5) {
          // Note: Drift uses TableMigration for complex migrations like dropping tables or columns
          // but we can also just use standard m methods

          // Drop Positions table completely
          // The proper way in Drift to drop a table is executing a DROP statement if we don't have it in schema
          await m.issueCustomQuery('DROP TABLE IF EXISTS positions;');

          // Isins modifications
          await m.alterTable(TableMigration(isins));

          // Tickers modifications
          await m.alterTable(TableMigration(tickers));
        }
        if (from < 6) {
          try {
            await m.addColumn(
              marketDataCaches,
              marketDataCaches.regularMarketStart,
            );
          } catch (e, stackTrace) {
            // Can be ignored if it exists, but log for visibility
            print('Error adding regularMarketStart: $e');
          }
          try {
            await m.addColumn(
              marketDataCaches,
              marketDataCaches.regularMarketEnd,
            );
          } catch (e, stackTrace) {
            print('Error adding regularMarketEnd: $e');
          }
          try {
            await m.addColumn(
              marketDataCaches,
              marketDataCaches.preMarketStart,
            );
          } catch (e, stackTrace) {
            print('Error adding preMarketStart: $e');
          }
          try {
            await m.addColumn(marketDataCaches, marketDataCaches.preMarketEnd);
          } catch (e, stackTrace) {
            print('Error adding preMarketEnd: $e');
          }
          try {
            await m.addColumn(
              marketDataCaches,
              marketDataCaches.postMarketStart,
            );
          } catch (e, stackTrace) {
            print('Error adding postMarketStart: $e');
          }
          try {
            await m.addColumn(marketDataCaches, marketDataCaches.postMarketEnd);
          } catch (e, stackTrace) {
            print('Error adding postMarketEnd: $e');
          }
        }
      },
    );
  }
}
