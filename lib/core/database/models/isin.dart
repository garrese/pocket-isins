import 'package:isar/isar.dart';
import 'ticker.dart';

part 'isin.g.dart';

@collection
class Isin {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String isinCode;

  late String name;

  double position = 0.0;
  
  // The price at which the asset was purchased
  double purchasePrice = 0.0;
  
  // Currency in which the asset was purchased (e.g. USD, EUR)
  late String currency;
  
  final tickers = IsarLinks<Ticker>();
}
