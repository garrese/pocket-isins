import 'package:isar/isar.dart';
import 'isin.dart';
import 'market_data_cache.dart';

part 'ticker.g.dart';

@collection
class Ticker {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String symbol;

  late String exchange;

  late String currency;

  @Backlink(to: 'tickers')
  final isin = IsarLink<Isin>();

  final marketDataCache = IsarLink<MarketDataCache>();
}
