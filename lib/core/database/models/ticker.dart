import 'package:isar/isar.dart';
import 'isin.dart';
import 'position.dart';
import 'market_data_cache.dart';

part 'ticker.g.dart';


@Collection(accessor: "tickers")
@Name("Ticker")
class Ticker {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String symbol;

  late String exchange;

  late String currency;

  @Backlink(to: 'tickers')
  final isin = IsarLink<Isin>();

  final positions = IsarLinks<Position>();

  final marketDataCache = IsarLink<MarketDataCache>();
}
