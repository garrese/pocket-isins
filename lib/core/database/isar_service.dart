import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models/isin.dart';
import 'models/ticker.dart';
import 'models/position.dart';
import 'models/market_data_cache.dart';

part 'isar_service.g.dart';

class IsarService {
  late final Isar db;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open(
      [IsinSchema, TickerSchema, PositionSchema, MarketDataCacheSchema],
      directory: dir.path,
    );
    await _seedInitialData();
  }

  Future<void> _seedInitialData() async {
    // Check if db is empty before seeding
    try {
      final count = await db.isins.count();
      if (count > 0) return;

      await db.writeTxn(() async {
        // Seed Apple
        final apple = Isin()
          ..isinCode = 'US0378331005'
          ..name = 'Apple Inc.';

        final aaplTicker = Ticker()
          ..symbol = 'AAPL'
          ..exchange = 'NASDAQ'
          ..currency = 'USD'
          ..isin.value = apple;

        final aplsTicker = Ticker()
          ..symbol = '0R2V.L'
          ..exchange = 'LSE'
          ..currency = 'GBP'
          ..isin.value = apple;

        final applePos = Position()
          ..capitalInvested = 1500.0
          ..purchasePrice = 150.0
          ..ticker.value = aaplTicker;

        await db.isins.put(apple);
        await db.tickers.putAll([aaplTicker, aplsTicker]);
        apple.tickers.addAll([aaplTicker, aplsTicker]);
        await apple.tickers.save();

        await db.positions.put(applePos);
        aaplTicker.positions.add(applePos);
        await aaplTicker.positions.save();

        // Seed Alphabet
        final alphabet = Isin()
          ..isinCode = 'US02079K3059'
          ..name = 'Alphabet Inc. (Class A)';

        final googTicker = Ticker()
          ..symbol = 'GOOGL'
          ..exchange = 'NASDAQ'
          ..currency = 'USD'
          ..isin.value = alphabet;

        final googLseTicker = Ticker()
          ..symbol = '0RIH.L'
          ..exchange = 'LSE'
          ..currency = 'GBP'
          ..isin.value = alphabet;

        final googPos = Position()
          ..capitalInvested = 600.0
          ..purchasePrice = 120.0
          ..ticker.value = googTicker;

        await db.isins.put(alphabet);
        await db.tickers.putAll([googTicker, googLseTicker]);
        alphabet.tickers.addAll([googTicker, googLseTicker]);
        await alphabet.tickers.save();

        await db.positions.put(googPos);
        googTicker.positions.add(googPos);
        await googTicker.positions.save();
      });
    } catch (e) {
      print('Seeding failed, cleaning up: \$e');
      await db.writeTxn(() => db.clear());
    }
  }
}

// Riverpod Provider for Isar Database
@Riverpod(keepAlive: true)
IsarService isarService(Ref ref) {
  // This provider expects to be overridden in main() after initialization
  throw UnimplementedError('IsarService must be initialized');
}
