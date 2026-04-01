import 'isin.dart';
import 'market_data_cache.dart';

class Ticker {
  int id;
  String symbol;
  String exchange;
  String? currency;
  String? quoteType;
  int? regularMarketStart;
  int? regularMarketEnd;
  int? preMarketStart;
  int? preMarketEnd;
  int? postMarketStart;
  int? postMarketEnd;

  Isin? isin;
  MarketDataCache? marketDataCache;

  Ticker({
    this.id = 0,
    required this.symbol,
    required this.exchange,
    this.currency,
    this.quoteType,
    this.regularMarketStart,
    this.regularMarketEnd,
    this.preMarketStart,
    this.preMarketEnd,
    this.postMarketStart,
    this.postMarketEnd,
    this.isin,
    this.marketDataCache,
  });

  @override
  String toString() {
    return 'Ticker{id: $id, symbol: $symbol, exchange: $exchange, currency: $currency, isinId: ${isin?.id}}';
  }
}
