import 'dart:convert';
import 'package:drift/drift.dart';

@DataClassName('IsinData')
class Isins extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get isinCode => text().unique()();
  TextColumn get name => text()();
  TextColumn get shortName => text().nullable()();
}

@DataClassName('TickerData')
class Tickers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text().unique()();
  TextColumn get exchange => text()();
  TextColumn get currency => text()();
  IntColumn get isinId => integer().references(Isins, #id)();
}

@DataClassName('PositionData')
class Positions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get capitalInvested => real().withDefault(const Constant(0.0))();
  RealColumn get purchasePrice => real().withDefault(const Constant(0.0))();
  IntColumn get tickerId => integer().references(Tickers, #id)();
}

@DataClassName('MarketDataCacheData')
class MarketDataCaches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text().unique()();
  DateTimeColumn get lastUpdated => dateTime()();
  RealColumn get regularMarketPrice => real().withDefault(const Constant(0.0))();
  RealColumn get chartPreviousClose => real().withDefault(const Constant(0.0))();

  // Stored as JSON string to maintain NoSQL-like capability
  TextColumn get intradayPrices => text().map(const DoubleListConverter()).withDefault(const Constant('[]'))();
  TextColumn get intradayTimestamps => text().map(const IntListConverter()).withDefault(const Constant('[]'))();

  IntColumn get tickerId => integer().references(Tickers, #id)();
}

@DataClassName('FeedNewsData')
class FeedNews extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get isinId => integer().references(Isins, #id)();
  TextColumn get title => text()();
  TextColumn get link => text()();
  TextColumn get sourceUrl => text()();
  TextColumn get sourceName => text()();
  DateTimeColumn get pubDate => dateTime()();
  IntColumn get round => integer()();
  IntColumn get subround => integer()();
}

// Custom converters for JSON arrays
class DoubleListConverter extends TypeConverter<List<double>, String> {
  const DoubleListConverter();

  @override
  List<double> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(fromDb);
    return decoded.map((e) => (e as num).toDouble()).toList();
  }

  @override
  String toSql(List<double> value) {
    return jsonEncode(value);
  }
}

class IntListConverter extends TypeConverter<List<int>, String> {
  const IntListConverter();

  @override
  List<int> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(fromDb);
    return decoded.map((e) => e as int).toList();
  }

  @override
  String toSql(List<int> value) {
    return jsonEncode(value);
  }
}
