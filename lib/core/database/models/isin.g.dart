// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isin.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsinCollection on Isar {
  IsarCollection<Isin> get isins => this.collection();
}

const IsinSchema = CollectionSchema(
  name: r'Isin',
  id: -9173980691444550219,
  properties: {
    r'isinCode': PropertySchema(
      id: 0,
      name: r'isinCode',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _isinEstimateSize,
  serialize: _isinSerialize,
  deserialize: _isinDeserialize,
  deserializeProp: _isinDeserializeProp,
  idName: r'id',
  indexes: {
    r'isinCode': IndexSchema(
      id: 8832190407207977596,
      name: r'isinCode',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isinCode',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'tickers': LinkSchema(
      id: 6048463559542401895,
      name: r'tickers',
      target: r'Ticker',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _isinGetId,
  getLinks: _isinGetLinks,
  attach: _isinAttach,
  version: '3.1.0+1',
);

int _isinEstimateSize(
  Isin object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.isinCode.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _isinSerialize(
  Isin object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.isinCode);
  writer.writeString(offsets[1], object.name);
}

Isin _isinDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Isin();
  object.id = id;
  object.isinCode = reader.readString(offsets[0]);
  object.name = reader.readString(offsets[1]);
  return object;
}

P _isinDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isinGetId(Isin object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isinGetLinks(Isin object) {
  return [object.tickers];
}

void _isinAttach(IsarCollection<dynamic> col, Id id, Isin object) {
  object.id = id;
  object.tickers.attach(col, col.isar.collection<Ticker>(), r'tickers', id);
}

extension IsinByIndex on IsarCollection<Isin> {
  Future<Isin?> getByIsinCode(String isinCode) {
    return getByIndex(r'isinCode', [isinCode]);
  }

  Isin? getByIsinCodeSync(String isinCode) {
    return getByIndexSync(r'isinCode', [isinCode]);
  }

  Future<bool> deleteByIsinCode(String isinCode) {
    return deleteByIndex(r'isinCode', [isinCode]);
  }

  bool deleteByIsinCodeSync(String isinCode) {
    return deleteByIndexSync(r'isinCode', [isinCode]);
  }

  Future<List<Isin?>> getAllByIsinCode(List<String> isinCodeValues) {
    final values = isinCodeValues.map((e) => [e]).toList();
    return getAllByIndex(r'isinCode', values);
  }

  List<Isin?> getAllByIsinCodeSync(List<String> isinCodeValues) {
    final values = isinCodeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'isinCode', values);
  }

  Future<int> deleteAllByIsinCode(List<String> isinCodeValues) {
    final values = isinCodeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'isinCode', values);
  }

  int deleteAllByIsinCodeSync(List<String> isinCodeValues) {
    final values = isinCodeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'isinCode', values);
  }

  Future<Id> putByIsinCode(Isin object) {
    return putByIndex(r'isinCode', object);
  }

  Id putByIsinCodeSync(Isin object, {bool saveLinks = true}) {
    return putByIndexSync(r'isinCode', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIsinCode(List<Isin> objects) {
    return putAllByIndex(r'isinCode', objects);
  }

  List<Id> putAllByIsinCodeSync(List<Isin> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'isinCode', objects, saveLinks: saveLinks);
  }
}

extension IsinQueryWhereSort on QueryBuilder<Isin, Isin, QWhere> {
  QueryBuilder<Isin, Isin, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsinQueryWhere on QueryBuilder<Isin, Isin, QWhereClause> {
  QueryBuilder<Isin, Isin, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Isin, Isin, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Isin, Isin, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Isin, Isin, QAfterWhereClause> idBetween(
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

  QueryBuilder<Isin, Isin, QAfterWhereClause> isinCodeEqualTo(String isinCode) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isinCode',
        value: [isinCode],
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterWhereClause> isinCodeNotEqualTo(
      String isinCode) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isinCode',
              lower: [],
              upper: [isinCode],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isinCode',
              lower: [isinCode],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isinCode',
              lower: [isinCode],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isinCode',
              lower: [],
              upper: [isinCode],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsinQueryFilter on QueryBuilder<Isin, Isin, QFilterCondition> {
  QueryBuilder<Isin, Isin, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Isin, Isin, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Isin, Isin, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Isin, Isin, QAfterFilterCondition> isinCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isinCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> isinCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isinCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> isinCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isinCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> isinCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isinCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> isinCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isinCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> isinCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isinCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> isinCodeContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isinCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> isinCodeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isinCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> isinCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isinCode',
        value: '',
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> isinCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isinCode',
        value: '',
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension IsinQueryObject on QueryBuilder<Isin, Isin, QFilterCondition> {}

extension IsinQueryLinks on QueryBuilder<Isin, Isin, QFilterCondition> {
  QueryBuilder<Isin, Isin, QAfterFilterCondition> tickers(
      FilterQuery<Ticker> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'tickers');
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> tickersLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'tickers', length, true, length, true);
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> tickersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'tickers', 0, true, 0, true);
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> tickersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'tickers', 0, false, 999999, true);
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> tickersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'tickers', 0, true, length, include);
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> tickersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'tickers', length, include, 999999, true);
    });
  }

  QueryBuilder<Isin, Isin, QAfterFilterCondition> tickersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'tickers', lower, includeLower, upper, includeUpper);
    });
  }
}

extension IsinQuerySortBy on QueryBuilder<Isin, Isin, QSortBy> {
  QueryBuilder<Isin, Isin, QAfterSortBy> sortByIsinCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isinCode', Sort.asc);
    });
  }

  QueryBuilder<Isin, Isin, QAfterSortBy> sortByIsinCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isinCode', Sort.desc);
    });
  }

  QueryBuilder<Isin, Isin, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Isin, Isin, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IsinQuerySortThenBy on QueryBuilder<Isin, Isin, QSortThenBy> {
  QueryBuilder<Isin, Isin, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Isin, Isin, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Isin, Isin, QAfterSortBy> thenByIsinCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isinCode', Sort.asc);
    });
  }

  QueryBuilder<Isin, Isin, QAfterSortBy> thenByIsinCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isinCode', Sort.desc);
    });
  }

  QueryBuilder<Isin, Isin, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Isin, Isin, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IsinQueryWhereDistinct on QueryBuilder<Isin, Isin, QDistinct> {
  QueryBuilder<Isin, Isin, QDistinct> distinctByIsinCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isinCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Isin, Isin, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension IsinQueryProperty on QueryBuilder<Isin, Isin, QQueryProperty> {
  QueryBuilder<Isin, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Isin, String, QQueryOperations> isinCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isinCode');
    });
  }

  QueryBuilder<Isin, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
