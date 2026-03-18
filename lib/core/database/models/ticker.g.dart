// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticker.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTickerCollection on Isar {
  IsarCollection<Ticker> get tickers => this.collection();
}

const TickerSchema = CollectionSchema(
  name: r'Ticker',
  id: 1779033375502683,
  properties: {
    r'currency': PropertySchema(
      id: 0,
      name: r'currency',
      type: IsarType.string,
    ),
    r'exchange': PropertySchema(
      id: 1,
      name: r'exchange',
      type: IsarType.string,
    ),
    r'symbol': PropertySchema(
      id: 2,
      name: r'symbol',
      type: IsarType.string,
    )
  },
  estimateSize: _tickerEstimateSize,
  serialize: _tickerSerialize,
  deserialize: _tickerDeserialize,
  deserializeProp: _tickerDeserializeProp,
  idName: r'id',
  indexes: {
    r'symbol': IndexSchema(
      id: 1683861666205597,
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
    r'isin': LinkSchema(
      id: 5114864820990436,
      name: r'isin',
      target: r'Isin',
      single: true,
      linkName: r'tickers',
    ),
    r'positions': LinkSchema(
      id: 4567090115273782,
      name: r'positions',
      target: r'Position',
      single: false,
    ),
    r'marketDataCache': LinkSchema(
      id: 6576026691645002,
      name: r'marketDataCache',
      target: r'MarketDataCache',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _tickerGetId,
  getLinks: _tickerGetLinks,
  attach: _tickerAttach,
  version: '3.1.0+1',
);

int _tickerEstimateSize(
  Ticker object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currency.length * 3;
  bytesCount += 3 + object.exchange.length * 3;
  bytesCount += 3 + object.symbol.length * 3;
  return bytesCount;
}

void _tickerSerialize(
  Ticker object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.currency);
  writer.writeString(offsets[1], object.exchange);
  writer.writeString(offsets[2], object.symbol);
}

Ticker _tickerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Ticker();
  object.currency = reader.readString(offsets[0]);
  object.exchange = reader.readString(offsets[1]);
  object.id = id;
  object.symbol = reader.readString(offsets[2]);
  return object;
}

P _tickerDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tickerGetId(Ticker object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tickerGetLinks(Ticker object) {
  return [object.isin, object.positions, object.marketDataCache];
}

void _tickerAttach(IsarCollection<dynamic> col, Id id, Ticker object) {
  object.id = id;
  object.isin.attach(col, col.isar.collection<Isin>(), r'isin', id);
  object.positions
      .attach(col, col.isar.collection<Position>(), r'positions', id);
  object.marketDataCache.attach(
      col, col.isar.collection<MarketDataCache>(), r'marketDataCache', id);
}

extension TickerByIndex on IsarCollection<Ticker> {
  Future<Ticker?> getBySymbol(String symbol) {
    return getByIndex(r'symbol', [symbol]);
  }

  Ticker? getBySymbolSync(String symbol) {
    return getByIndexSync(r'symbol', [symbol]);
  }

  Future<bool> deleteBySymbol(String symbol) {
    return deleteByIndex(r'symbol', [symbol]);
  }

  bool deleteBySymbolSync(String symbol) {
    return deleteByIndexSync(r'symbol', [symbol]);
  }

  Future<List<Ticker?>> getAllBySymbol(List<String> symbolValues) {
    final values = symbolValues.map((e) => [e]).toList();
    return getAllByIndex(r'symbol', values);
  }

  List<Ticker?> getAllBySymbolSync(List<String> symbolValues) {
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

  Future<Id> putBySymbol(Ticker object) {
    return putByIndex(r'symbol', object);
  }

  Id putBySymbolSync(Ticker object, {bool saveLinks = true}) {
    return putByIndexSync(r'symbol', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySymbol(List<Ticker> objects) {
    return putAllByIndex(r'symbol', objects);
  }

  List<Id> putAllBySymbolSync(List<Ticker> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'symbol', objects, saveLinks: saveLinks);
  }
}

extension TickerQueryWhereSort on QueryBuilder<Ticker, Ticker, QWhere> {
  QueryBuilder<Ticker, Ticker, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TickerQueryWhere on QueryBuilder<Ticker, Ticker, QWhereClause> {
  QueryBuilder<Ticker, Ticker, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Ticker, Ticker, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterWhereClause> idBetween(
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

  QueryBuilder<Ticker, Ticker, QAfterWhereClause> symbolEqualTo(String symbol) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'symbol',
        value: [symbol],
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterWhereClause> symbolNotEqualTo(
      String symbol) {
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

extension TickerQueryFilter on QueryBuilder<Ticker, Ticker, QFilterCondition> {
  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> currencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> currencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> currencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> currencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> currencyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> currencyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> exchangeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exchange',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> exchangeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exchange',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> exchangeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exchange',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> exchangeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exchange',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> exchangeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exchange',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> exchangeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exchange',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> exchangeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exchange',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> exchangeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exchange',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> exchangeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exchange',
        value: '',
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> exchangeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exchange',
        value: '',
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> symbolEqualTo(
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

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> symbolGreaterThan(
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

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> symbolLessThan(
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

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> symbolBetween(
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

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> symbolStartsWith(
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

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> symbolEndsWith(
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

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> symbolContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> symbolMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'symbol',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> symbolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'symbol',
        value: '',
      ));
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> symbolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'symbol',
        value: '',
      ));
    });
  }
}

extension TickerQueryObject on QueryBuilder<Ticker, Ticker, QFilterCondition> {}

extension TickerQueryLinks on QueryBuilder<Ticker, Ticker, QFilterCondition> {
  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> isin(
      FilterQuery<Isin> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'isin');
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> isinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'isin', 0, true, 0, true);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> positions(
      FilterQuery<Position> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'positions');
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> positionsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'positions', length, true, length, true);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> positionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'positions', 0, true, 0, true);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> positionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'positions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> positionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'positions', 0, true, length, include);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition>
      positionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'positions', length, include, 999999, true);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> positionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'positions', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> marketDataCache(
      FilterQuery<MarketDataCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'marketDataCache');
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterFilterCondition> marketDataCacheIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'marketDataCache', 0, true, 0, true);
    });
  }
}

extension TickerQuerySortBy on QueryBuilder<Ticker, Ticker, QSortBy> {
  QueryBuilder<Ticker, Ticker, QAfterSortBy> sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> sortByExchange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exchange', Sort.asc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> sortByExchangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exchange', Sort.desc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> sortBySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.asc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> sortBySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.desc);
    });
  }
}

extension TickerQuerySortThenBy on QueryBuilder<Ticker, Ticker, QSortThenBy> {
  QueryBuilder<Ticker, Ticker, QAfterSortBy> thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> thenByExchange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exchange', Sort.asc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> thenByExchangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exchange', Sort.desc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> thenBySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.asc);
    });
  }

  QueryBuilder<Ticker, Ticker, QAfterSortBy> thenBySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.desc);
    });
  }
}

extension TickerQueryWhereDistinct on QueryBuilder<Ticker, Ticker, QDistinct> {
  QueryBuilder<Ticker, Ticker, QDistinct> distinctByCurrency(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Ticker, Ticker, QDistinct> distinctByExchange(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exchange', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Ticker, Ticker, QDistinct> distinctBySymbol(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'symbol', caseSensitive: caseSensitive);
    });
  }
}

extension TickerQueryProperty on QueryBuilder<Ticker, Ticker, QQueryProperty> {
  QueryBuilder<Ticker, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Ticker, String, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<Ticker, String, QQueryOperations> exchangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exchange');
    });
  }

  QueryBuilder<Ticker, String, QQueryOperations> symbolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'symbol');
    });
  }
}
