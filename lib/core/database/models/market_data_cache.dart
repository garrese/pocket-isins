import 'ticker.dart';

class MarketDataCache {
  int id;
  String symbol;
  DateTime lastUpdated;
  double regularMarketPrice;
  double chartPreviousClose;
  List<double> intradayPrices;
  List<int> intradayTimestamps;
  int? regularMarketStart;
  int? regularMarketEnd;
  int? preMarketStart;
  int? preMarketEnd;
  int? postMarketStart;
  int? postMarketEnd;

  Ticker? ticker;

  MarketDataCache({
    this.id = 0,
    required this.symbol,
    required this.lastUpdated,
    this.regularMarketPrice = 0.0,
    this.chartPreviousClose = 0.0,
    this.intradayPrices = const [],
    this.intradayTimestamps = const [],
    this.regularMarketStart,
    this.regularMarketEnd,
    this.preMarketStart,
    this.preMarketEnd,
    this.postMarketStart,
    this.postMarketEnd,
    this.ticker,
  });

  @override
  String toString() {
    return 'MarketDataCache{id: $id, symbol: $symbol, lastUpdated: $lastUpdated, regularMarketPrice: $regularMarketPrice, chartPreviousClose: $chartPreviousClose, points: ${intradayPrices.length}}';
  }
}
