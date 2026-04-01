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
    if (shortName != null && shortName!.trim().isNotEmpty) return shortName!;
    if (registeredNames.isNotEmpty) return registeredNames.first;
    if (altName != null && altName!.trim().isNotEmpty) return altName!;
    if (isinCode != null && isinCode!.trim().isNotEmpty) return isinCode!;
    return 'Unknown ISIN';
  }

  @override
  String toString() {
    return 'Isin{id: $id, isinCode: $isinCode, altName: $altName, registeredNames: $registeredNames, shortName: $shortName, tickers: ${tickers.length}}';
  }
}
