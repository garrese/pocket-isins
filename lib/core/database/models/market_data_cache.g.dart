// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_data_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMarketDataCacheCollection on Isar {
  IsarCollection<MarketDataCache> get marketDataCaches => this.collection();
}

const MarketDataCacheSchema = CollectionSchema(
  name: r'MarketDataCache',
  id: 9054608117232239594,
  properties: {
    r'chartPreviousClose': PropertySchema(
      id: 0,
      name: r'chartPreviousClose',
      type: IsarType.double,
    ),
    r'intradayPrices': PropertySchema(
      id: 1,
      name: r'intradayPrices',
      type: IsarType.doubleList,
    ),
    r'lastUpdated': PropertySchema(
      id: 2,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'regularMarketPrice': PropertySchema(
      id: 3,
      name: r'regularMarketPrice',
      type: IsarType.double,
    ),
    r'symbol': PropertySchema(
      id: 4,
      name: r'symbol',
      type: IsarType.string,
    )
  },
  estimateSize: _marketDataCacheEstimateSize,
  serialize: _marketDataCacheSerialize,
  deserialize: _marketDataCacheDeserialize,
  deserializeProp: _marketDataCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'symbol': IndexSchema(
      id: -7050953154795990356,
      name: r'symbol',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'symbol',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'ticker': LinkSchema(
      id: -5762245600520024605,
      name: r'ticker',
      target: r'Ticker',
      single: true,
      linkName: r'marketDataCache',
    )
  },
  embeddedSchemas: {},
  getId: _marketDataCacheGetId,
  getLinks: _marketDataCacheGetLinks,
  attach: _marketDataCacheAttach,
  version: '3.1.0+1',
);

int _marketDataCacheEstimateSize(
  MarketDataCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.intradayPrices.length * 8;
  bytesCount += 3 + object.symbol.length * 3;
  return bytesCount;
}

void _marketDataCacheSerialize(
  MarketDataCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.chartPreviousClose);
  writer.writeDoubleList(offsets[1], object.intradayPrices);
  writer.writeDateTime(offsets[2], object.lastUpdated);
  writer.writeDouble(offsets[3], object.regularMarketPrice);
  writer.writeString(offsets[4], object.symbol);
}

MarketDataCache _marketDataCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MarketDataCache();
  object.chartPreviousClose = reader.readDouble(offsets[0]);
  object.id = id;
  object.intradayPrices = reader.readDoubleList(offsets[1]) ?? [];
  object.lastUpdated = reader.readDateTime(offsets[2]);
  object.regularMarketPrice = reader.readDouble(offsets[3]);
  object.symbol = reader.readString(offsets[4]);
  return object;
}

P _marketDataCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _marketDataCacheGetId(MarketDataCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _marketDataCacheGetLinks(MarketDataCache object) {
  return [object.ticker];
}

void _marketDataCacheAttach(
    IsarCollection<dynamic> col, Id id, MarketDataCache object) {
  object.id = id;
  object.ticker.attach(col, col.isar.collection<Ticker>(), r'ticker', id);
}

extension MarketDataCacheByIndex on IsarCollection<MarketDataCache> {
  Future<MarketDataCache?> getBySymbol(String symbol) {
    return getByIndex(r'symbol', [symbol]);
  }

  MarketDataCache? getBySymbolSync(String symbol) {
    return getByIndexSync(r'symbol', [symbol]);
  }

  Future<bool> deleteBySymbol(String symbol) {
    return deleteByIndex(r'symbol', [symbol]);
  }

  bool deleteBySymbolSync(String symbol) {
    return deleteByIndexSync(r'symbol', [symbol]);
  }

  Future<List<MarketDataCache?>> getAllBySymbol(List<String> symbolValues) {
    final values = symbolValues.map((e) => [e]).toList();
    return getAllByIndex(r'symbol', values);
  }

  List<MarketDataCache?> getAllBySymbolSync(List<String> symbolValues) {
    final values = symbolValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'symbol', values);
  }

  Future<int> deleteAllBySymbol(List<String> symbolValues) {
    final values = symbolValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'symbol', values);
  }

  int deleteAllBySymbolSync(List<String> symbolValues) {
    final values = symbolValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'symbol', values);
  }

  Future<Id> putBySymbol(MarketDataCache object) {
    return putByIndex(r'symbol', object);
  }

  Id putBySymbolSync(MarketDataCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'symbol', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySymbol(List<MarketDataCache> objects) {
    return putAllByIndex(r'symbol', objects);
  }

  List<Id> putAllBySymbolSync(List<MarketDataCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'symbol', objects, saveLinks: saveLinks);
  }
}

extension MarketDataCacheQueryWhereSort
    on QueryBuilder<MarketDataCache, MarketDataCache, QWhere> {
  QueryBuilder<MarketDataCache, MarketDataCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MarketDataCacheQueryWhere
    on QueryBuilder<MarketDataCache, MarketDataCache, QWhereClause> {
  QueryBuilder<MarketDataCache, MarketDataCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterWhereClause>
      symbolEqualTo(String symbol) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'symbol',
        value: [symbol],
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterWhereClause>
      symbolNotEqualTo(String symbol) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'symbol',
              lower: [],
              upper: [symbol],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'symbol',
              lower: [symbol],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'symbol',
              lower: [symbol],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'symbol',
              lower: [],
              upper: [symbol],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MarketDataCacheQueryFilter
    on QueryBuilder<MarketDataCache, MarketDataCache, QFilterCondition> {
  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      chartPreviousCloseEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chartPreviousClose',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      chartPreviousCloseGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chartPreviousClose',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      chartPreviousCloseLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chartPreviousClose',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      chartPreviousCloseBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chartPreviousClose',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      intradayPricesElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intradayPrices',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      intradayPricesElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intradayPrices',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      intradayPricesElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intradayPrices',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      intradayPricesElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intradayPrices',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      intradayPricesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intradayPrices',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      intradayPricesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intradayPrices',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      intradayPricesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intradayPrices',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      intradayPricesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intradayPrices',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      intradayPricesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intradayPrices',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      intradayPricesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intradayPrices',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      regularMarketPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regularMarketPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      regularMarketPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regularMarketPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      regularMarketPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regularMarketPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      regularMarketPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regularMarketPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      symbolEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      symbolGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      symbolLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      symbolBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'symbol',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      symbolStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      symbolEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      symbolContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      symbolMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'symbol',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      symbolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'symbol',
        value: '',
      ));
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      symbolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'symbol',
        value: '',
      ));
    });
  }
}

extension MarketDataCacheQueryObject
    on QueryBuilder<MarketDataCache, MarketDataCache, QFilterCondition> {}

extension MarketDataCacheQueryLinks
    on QueryBuilder<MarketDataCache, MarketDataCache, QFilterCondition> {
  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition> ticker(
      FilterQuery<Ticker> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'ticker');
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterFilterCondition>
      tickerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'ticker', 0, true, 0, true);
    });
  }
}

extension MarketDataCacheQuerySortBy
    on QueryBuilder<MarketDataCache, MarketDataCache, QSortBy> {
  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      sortByChartPreviousClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartPreviousClose', Sort.asc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      sortByChartPreviousCloseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartPreviousClose', Sort.desc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      sortByRegularMarketPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regularMarketPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      sortByRegularMarketPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regularMarketPrice', Sort.desc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy> sortBySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.asc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      sortBySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.desc);
    });
  }
}

extension MarketDataCacheQuerySortThenBy
    on QueryBuilder<MarketDataCache, MarketDataCache, QSortThenBy> {
  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      thenByChartPreviousClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartPreviousClose', Sort.asc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      thenByChartPreviousCloseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chartPreviousClose', Sort.desc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      thenByRegularMarketPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regularMarketPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      thenByRegularMarketPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regularMarketPrice', Sort.desc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy> thenBySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.asc);
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QAfterSortBy>
      thenBySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.desc);
    });
  }
}

extension MarketDataCacheQueryWhereDistinct
    on QueryBuilder<MarketDataCache, MarketDataCache, QDistinct> {
  QueryBuilder<MarketDataCache, MarketDataCache, QDistinct>
      distinctByChartPreviousClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chartPreviousClose');
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QDistinct>
      distinctByIntradayPrices() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intradayPrices');
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QDistinct>
      distinctByRegularMarketPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regularMarketPrice');
    });
  }

  QueryBuilder<MarketDataCache, MarketDataCache, QDistinct> distinctBySymbol(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'symbol', caseSensitive: caseSensitive);
    });
  }
}

extension MarketDataCacheQueryProperty
    on QueryBuilder<MarketDataCache, MarketDataCache, QQueryProperty> {
  QueryBuilder<MarketDataCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MarketDataCache, double, QQueryOperations>
      chartPreviousCloseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chartPreviousClose');
    });
  }

  QueryBuilder<MarketDataCache, List<double>, QQueryOperations>
      intradayPricesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intradayPrices');
    });
  }

  QueryBuilder<MarketDataCache, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<MarketDataCache, double, QQueryOperations>
      regularMarketPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regularMarketPrice');
    });
  }

  QueryBuilder<MarketDataCache, String, QQueryOperations> symbolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'symbol');
    });
  }
}
