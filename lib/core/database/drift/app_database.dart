import 'package:drift/drift.dart';

import 'app_tables.dart';
import 'connection/connection.dart' as impl;

part 'app_database.g.dart';

@DriftDatabase(tables: [Isins, Tickers, Positions, MarketDataCaches])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 1;
}
