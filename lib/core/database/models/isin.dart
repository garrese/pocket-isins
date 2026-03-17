import 'package:isar/isar.dart';
import 'ticker.dart';

part 'isin.g.dart';

@collection
class Isin {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String isinCode;

  late String name;

  final tickers = IsarLinks<Ticker>();
}
