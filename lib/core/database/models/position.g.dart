// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPositionCollection on Isar {
  IsarCollection<Position> get positions => this.collection();
}

const PositionSchema = CollectionSchema(
  name: r'Position',
  id: 4328721527386811,
  properties: {
    r'capitalInvested': PropertySchema(
      id: 0,
      name: r'capitalInvested',
      type: IsarType.double,
    ),
    r'purchasePrice': PropertySchema(
      id: 1,
      name: r'purchasePrice',
      type: IsarType.double,
    )
  },
  estimateSize: _positionEstimateSize,
  serialize: _positionSerialize,
  deserialize: _positionDeserialize,
  deserializeProp: _positionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'ticker': LinkSchema(
      id: 6876549769867856,
      name: r'ticker',
      target: r'Ticker',
      single: true,
      linkName: r'positions',
    )
  },
  embeddedSchemas: {},
  getId: _positionGetId,
  getLinks: _positionGetLinks,
  attach: _positionAttach,
  version: '3.1.0+1',
);

int _positionEstimateSize(
  Position object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _positionSerialize(
  Position object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.capitalInvested);
  writer.writeDouble(offsets[1], object.purchasePrice);
}

Position _positionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Position();
  object.capitalInvested = reader.readDouble(offsets[0]);
  object.id = id;
  object.purchasePrice = reader.readDouble(offsets[1]);
  return object;
}

P _positionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _positionGetId(Position object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _positionGetLinks(Position object) {
  return [object.ticker];
}

void _positionAttach(IsarCollection<dynamic> col, Id id, Position object) {
  object.id = id;
  object.ticker.attach(col, col.isar.collection<Ticker>(), r'ticker', id);
}

extension PositionQueryWhereSort on QueryBuilder<Position, Position, QWhere> {
  QueryBuilder<Position, Position, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PositionQueryWhere on QueryBuilder<Position, Position, QWhereClause> {
  QueryBuilder<Position, Position, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Position, Position, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Position, Position, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Position, Position, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Position, Position, QAfterWhereClause> idBetween(
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
}

extension PositionQueryFilter
    on QueryBuilder<Position, Position, QFilterCondition> {
  QueryBuilder<Position, Position, QAfterFilterCondition>
      capitalInvestedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capitalInvested',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Position, Position, QAfterFilterCondition>
      capitalInvestedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'capitalInvested',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Position, Position, QAfterFilterCondition>
      capitalInvestedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'capitalInvested',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Position, Position, QAfterFilterCondition>
      capitalInvestedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'capitalInvested',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Position, Position, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Position, Position, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Position, Position, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Position, Position, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Position, Position, QAfterFilterCondition> purchasePriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Position, Position, QAfterFilterCondition>
      purchasePriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Position, Position, QAfterFilterCondition> purchasePriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Position, Position, QAfterFilterCondition> purchasePriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchasePrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PositionQueryObject
    on QueryBuilder<Position, Position, QFilterCondition> {}

extension PositionQueryLinks
    on QueryBuilder<Position, Position, QFilterCondition> {
  QueryBuilder<Position, Position, QAfterFilterCondition> ticker(
      FilterQuery<Ticker> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'ticker');
    });
  }

  QueryBuilder<Position, Position, QAfterFilterCondition> tickerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'ticker', 0, true, 0, true);
    });
  }
}

extension PositionQuerySortBy on QueryBuilder<Position, Position, QSortBy> {
  QueryBuilder<Position, Position, QAfterSortBy> sortByCapitalInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capitalInvested', Sort.asc);
    });
  }

  QueryBuilder<Position, Position, QAfterSortBy> sortByCapitalInvestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capitalInvested', Sort.desc);
    });
  }

  QueryBuilder<Position, Position, QAfterSortBy> sortByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.asc);
    });
  }

  QueryBuilder<Position, Position, QAfterSortBy> sortByPurchasePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.desc);
    });
  }
}

extension PositionQuerySortThenBy
    on QueryBuilder<Position, Position, QSortThenBy> {
  QueryBuilder<Position, Position, QAfterSortBy> thenByCapitalInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capitalInvested', Sort.asc);
    });
  }

  QueryBuilder<Position, Position, QAfterSortBy> thenByCapitalInvestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capitalInvested', Sort.desc);
    });
  }

  QueryBuilder<Position, Position, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Position, Position, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Position, Position, QAfterSortBy> thenByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.asc);
    });
  }

  QueryBuilder<Position, Position, QAfterSortBy> thenByPurchasePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.desc);
    });
  }
}

extension PositionQueryWhereDistinct
    on QueryBuilder<Position, Position, QDistinct> {
  QueryBuilder<Position, Position, QDistinct> distinctByCapitalInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capitalInvested');
    });
  }

  QueryBuilder<Position, Position, QDistinct> distinctByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchasePrice');
    });
  }
}

extension PositionQueryProperty
    on QueryBuilder<Position, Position, QQueryProperty> {
  QueryBuilder<Position, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Position, double, QQueryOperations> capitalInvestedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capitalInvested');
    });
  }

  QueryBuilder<Position, double, QQueryOperations> purchasePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchasePrice');
    });
  }
}
