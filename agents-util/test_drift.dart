import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'lib/core/database/drift/app_database.dart';
import 'lib/core/database/drift/app_tables.dart';

void main() async {
  final db = AppDatabase();

  // Insert some data
  final isinId = await db.into(db.isins).insert(
    IsinsCompanion.insert(
      isinCode: const Value('US0378331005'),
      altName: const Value('Apple'),
    )
  );

  final tickerId = await db.into(db.tickers).insert(
    TickersCompanion.insert(
      symbol: 'AAPL',
      exchange: 'NASDAQ',
      isinId: isinId,
    )
  );

  print('Inserted ISIN $isinId, Ticker $tickerId');

  try {
    await db.transaction(() async {
      await db.delete(db.marketDataCaches).go();
      await db.delete(db.feedNews).go();
      await db.delete(db.tickers).go();
      await db.delete(db.isins).go();
    });
    print('Transaction successful!');

    final remaining = await db.select(db.isins).get();
    print('Remaining ISINs: ${remaining.length}');
  } catch (e, stack) {
    print('Transaction failed: $e');
    print(stack);
  }
}
