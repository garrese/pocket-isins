import 'isin.dart';
import 'position.dart';
import 'market_data_cache.dart';

class Ticker {
  int id;
  String symbol;
  String exchange;
  String currency;

  Isin? isin;
  List<Position> positions;
  MarketDataCache? marketDataCache;

  Ticker({
    this.id = 0,
    required this.symbol,
    required this.exchange,
    required this.currency,
    this.isin,
    this.positions = const [],
    this.marketDataCache,
  });
}
