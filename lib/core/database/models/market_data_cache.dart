import 'ticker.dart';

class MarketDataCache {
  int id;
  String symbol;
  DateTime lastUpdated;
  double regularMarketPrice;
  double chartPreviousClose;
  List<double> intradayPrices;
  List<int> intradayTimestamps;

  Ticker? ticker;

  MarketDataCache({
    this.id = 0,
    required this.symbol,
    required this.lastUpdated,
    this.regularMarketPrice = 0.0,
    this.chartPreviousClose = 0.0,
    this.intradayPrices = const [],
    this.intradayTimestamps = const [],
    this.ticker,
  });
}
