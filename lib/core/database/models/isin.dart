import 'ticker.dart';

class Isin {
  int id;
  String? isinCode;
  String? altName;
  List<String> registeredNames;
  String? shortName;

  List<Ticker> tickers;

  Isin({
    this.id = 0,
    this.isinCode,
    this.altName,
    this.registeredNames = const [],
    this.shortName,
    this.tickers = const [],
  });

  String get displayName {
    if (altName != null && altName!.trim().isNotEmpty) return altName!;
    if (registeredNames.isNotEmpty) return registeredNames.first;
    if (shortName != null && shortName!.trim().isNotEmpty) return shortName!;
    return 'Unknown';
  }

  @override
  String toString() {
    return 'Isin{id: $id, isinCode: $isinCode, altName: $altName, registeredNames: $registeredNames, shortName: $shortName, tickers: ${tickers.length}}';
  }
}
