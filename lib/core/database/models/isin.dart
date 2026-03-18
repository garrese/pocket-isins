import 'package:isar/isar.dart';
import 'ticker.dart';

part 'isin.g.dart';


@Collection(accessor: "isins")
@Name("Isin")
class Isin {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String isinCode;

  late String name;

  String? shortName;

  @ignore
  String get displayName => (shortName != null && shortName!.trim().isNotEmpty) ? shortName! : name;

  final tickers = IsarLinks<Ticker>();
}
