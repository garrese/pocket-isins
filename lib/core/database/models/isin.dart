import 'ticker.dart';

class Isin {
  int id;
  String isinCode;
  String name;
  String? shortName;

  List<Ticker> tickers;

  Isin({
    this.id = 0,
    required this.isinCode,
    required this.name,
    this.shortName,
    this.tickers = const [],
  });

  String get displayName => (shortName != null && shortName!.trim().isNotEmpty) ? shortName! : name;
}
