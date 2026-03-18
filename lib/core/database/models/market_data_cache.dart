import 'package:isar/isar.dart';

import 'ticker.dart';

part 'market_data_cache.g.dart';

@collection
class MarketDataCache {
  Id id = Isar.autoIncrement;

  // The symbol this cache belongs to (e.g. "GOOGL")
  @Index(unique: true)
  late String symbol;

  // Timestamp of the last successful fetch
  late DateTime lastUpdated;

  // Level 1 Data
  double regularMarketPrice = 0.0;
  double chartPreviousClose = 0.0;
  
  // Level 2 Data (Intraday Chart points - usually around 80 data points for a single day at 5m interval)
  List<double> intradayPrices = [];

  // Backlink to the parent Ticker
  @Backlink(to: 'marketDataCache')
  final ticker = IsarLink<Ticker>();
}
