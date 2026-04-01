import 'dart:convert';
import 'package:drift/drift.dart';

@DataClassName('IsinData')
class Isins extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get isinCode => text().nullable().unique()();
  TextColumn get altName => text().nullable()();
  TextColumn get registeredNames => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get shortName => text().nullable()();
}

@DataClassName('TickerData')
class Tickers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text().unique()();
  TextColumn get exchange => text()();
  TextColumn get currency => text().nullable()();
  TextColumn get quoteType => text().nullable()();
  IntColumn get regularMarketStart => integer().nullable()();
  IntColumn get regularMarketEnd => integer().nullable()();
  IntColumn get preMarketStart => integer().nullable()();
  IntColumn get preMarketEnd => integer().nullable()();
  IntColumn get postMarketStart => integer().nullable()();
  IntColumn get postMarketEnd => integer().nullable()();
  IntColumn get isinId => integer().references(Isins, #id)();
}

@DataClassName('MarketDataCacheData')
class MarketDataCaches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text().unique()();
  DateTimeColumn get lastUpdated => dateTime()();
  RealColumn get regularMarketPrice =>
      real().withDefault(const Constant(0.0))();
  RealColumn get chartPreviousClose =>
      real().withDefault(const Constant(0.0))();

  // Stored as JSON string to maintain NoSQL-like capability
  TextColumn get intradayPrices => text()
      .map(const DoubleListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get intradayTimestamps =>
      text().map(const IntListConverter()).withDefault(const Constant('[]'))();

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
  IntColumn get relevanceScore => integer().nullable()();
}

@DataClassName('ChatMessageData')
class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get role => text()(); // 'user' or 'assistant'
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
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

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(fromDb);
    return decoded.map((e) => e.toString()).toList();
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}
