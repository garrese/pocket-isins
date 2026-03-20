// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $IsinsTable extends Isins with TableInfo<$IsinsTable, IsinData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IsinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _isinCodeMeta =
      const VerificationMeta('isinCode');
  @override
  late final GeneratedColumn<String> isinCode = GeneratedColumn<String>(
      'isin_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shortNameMeta =
      const VerificationMeta('shortName');
  @override
  late final GeneratedColumn<String> shortName = GeneratedColumn<String>(
      'short_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, isinCode, name, shortName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'isins';
  @override
  VerificationContext validateIntegrity(Insertable<IsinData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('isin_code')) {
      context.handle(_isinCodeMeta,
          isinCode.isAcceptableOrUnknown(data['isin_code']!, _isinCodeMeta));
    } else if (isInserting) {
      context.missing(_isinCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('short_name')) {
      context.handle(_shortNameMeta,
          shortName.isAcceptableOrUnknown(data['short_name']!, _shortNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IsinData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IsinData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      isinCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}isin_code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      shortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}short_name']),
    );
  }

  @override
  $IsinsTable createAlias(String alias) {
    return $IsinsTable(attachedDatabase, alias);
  }
}

class IsinData extends DataClass implements Insertable<IsinData> {
  final int id;
  final String isinCode;
  final String name;
  final String? shortName;
  const IsinData(
      {required this.id,
      required this.isinCode,
      required this.name,
      this.shortName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['isin_code'] = Variable<String>(isinCode);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || shortName != null) {
      map['short_name'] = Variable<String>(shortName);
    }
    return map;
  }

  IsinsCompanion toCompanion(bool nullToAbsent) {
    return IsinsCompanion(
      id: Value(id),
      isinCode: Value(isinCode),
      name: Value(name),
      shortName: shortName == null && nullToAbsent
          ? const Value.absent()
          : Value(shortName),
    );
  }

  factory IsinData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IsinData(
      id: serializer.fromJson<int>(json['id']),
      isinCode: serializer.fromJson<String>(json['isinCode']),
      name: serializer.fromJson<String>(json['name']),
      shortName: serializer.fromJson<String?>(json['shortName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isinCode': serializer.toJson<String>(isinCode),
      'name': serializer.toJson<String>(name),
      'shortName': serializer.toJson<String?>(shortName),
    };
  }

  IsinData copyWith(
          {int? id,
          String? isinCode,
          String? name,
          Value<String?> shortName = const Value.absent()}) =>
      IsinData(
        id: id ?? this.id,
        isinCode: isinCode ?? this.isinCode,
        name: name ?? this.name,
        shortName: shortName.present ? shortName.value : this.shortName,
      );
  IsinData copyWithCompanion(IsinsCompanion data) {
    return IsinData(
      id: data.id.present ? data.id.value : this.id,
      isinCode: data.isinCode.present ? data.isinCode.value : this.isinCode,
      name: data.name.present ? data.name.value : this.name,
      shortName: data.shortName.present ? data.shortName.value : this.shortName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IsinData(')
          ..write('id: $id, ')
          ..write('isinCode: $isinCode, ')
          ..write('name: $name, ')
          ..write('shortName: $shortName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, isinCode, name, shortName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IsinData &&
          other.id == this.id &&
          other.isinCode == this.isinCode &&
          other.name == this.name &&
          other.shortName == this.shortName);
}

class IsinsCompanion extends UpdateCompanion<IsinData> {
  final Value<int> id;
  final Value<String> isinCode;
  final Value<String> name;
  final Value<String?> shortName;
  const IsinsCompanion({
    this.id = const Value.absent(),
    this.isinCode = const Value.absent(),
    this.name = const Value.absent(),
    this.shortName = const Value.absent(),
  });
  IsinsCompanion.insert({
    this.id = const Value.absent(),
    required String isinCode,
    required String name,
    this.shortName = const Value.absent(),
  })  : isinCode = Value(isinCode),
        name = Value(name);
  static Insertable<IsinData> custom({
    Expression<int>? id,
    Expression<String>? isinCode,
    Expression<String>? name,
    Expression<String>? shortName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isinCode != null) 'isin_code': isinCode,
      if (name != null) 'name': name,
      if (shortName != null) 'short_name': shortName,
    });
  }

  IsinsCompanion copyWith(
      {Value<int>? id,
      Value<String>? isinCode,
      Value<String>? name,
      Value<String?>? shortName}) {
    return IsinsCompanion(
      id: id ?? this.id,
      isinCode: isinCode ?? this.isinCode,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isinCode.present) {
      map['isin_code'] = Variable<String>(isinCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (shortName.present) {
      map['short_name'] = Variable<String>(shortName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IsinsCompanion(')
          ..write('id: $id, ')
          ..write('isinCode: $isinCode, ')
          ..write('name: $name, ')
          ..write('shortName: $shortName')
          ..write(')'))
        .toString();
  }
}

class $TickersTable extends Tickers with TableInfo<$TickersTable, TickerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TickersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _exchangeMeta =
      const VerificationMeta('exchange');
  @override
  late final GeneratedColumn<String> exchange = GeneratedColumn<String>(
      'exchange', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isinIdMeta = const VerificationMeta('isinId');
  @override
  late final GeneratedColumn<int> isinId = GeneratedColumn<int>(
      'isin_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES isins (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, symbol, exchange, currency, isinId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tickers';
  @override
  VerificationContext validateIntegrity(Insertable<TickerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('exchange')) {
      context.handle(_exchangeMeta,
          exchange.isAcceptableOrUnknown(data['exchange']!, _exchangeMeta));
    } else if (isInserting) {
      context.missing(_exchangeMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('isin_id')) {
      context.handle(_isinIdMeta,
          isinId.isAcceptableOrUnknown(data['isin_id']!, _isinIdMeta));
    } else if (isInserting) {
      context.missing(_isinIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TickerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TickerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      exchange: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exchange'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      isinId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}isin_id'])!,
    );
  }

  @override
  $TickersTable createAlias(String alias) {
    return $TickersTable(attachedDatabase, alias);
  }
}

class TickerData extends DataClass implements Insertable<TickerData> {
  final int id;
  final String symbol;
  final String exchange;
  final String currency;
  final int isinId;
  const TickerData(
      {required this.id,
      required this.symbol,
      required this.exchange,
      required this.currency,
      required this.isinId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['exchange'] = Variable<String>(exchange);
    map['currency'] = Variable<String>(currency);
    map['isin_id'] = Variable<int>(isinId);
    return map;
  }

  TickersCompanion toCompanion(bool nullToAbsent) {
    return TickersCompanion(
      id: Value(id),
      symbol: Value(symbol),
      exchange: Value(exchange),
      currency: Value(currency),
      isinId: Value(isinId),
    );
  }

  factory TickerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TickerData(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      exchange: serializer.fromJson<String>(json['exchange']),
      currency: serializer.fromJson<String>(json['currency']),
      isinId: serializer.fromJson<int>(json['isinId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'symbol': serializer.toJson<String>(symbol),
      'exchange': serializer.toJson<String>(exchange),
      'currency': serializer.toJson<String>(currency),
      'isinId': serializer.toJson<int>(isinId),
    };
  }

  TickerData copyWith(
          {int? id,
          String? symbol,
          String? exchange,
          String? currency,
          int? isinId}) =>
      TickerData(
        id: id ?? this.id,
        symbol: symbol ?? this.symbol,
        exchange: exchange ?? this.exchange,
        currency: currency ?? this.currency,
        isinId: isinId ?? this.isinId,
      );
  TickerData copyWithCompanion(TickersCompanion data) {
    return TickerData(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      exchange: data.exchange.present ? data.exchange.value : this.exchange,
      currency: data.currency.present ? data.currency.value : this.currency,
      isinId: data.isinId.present ? data.isinId.value : this.isinId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TickerData(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('exchange: $exchange, ')
          ..write('currency: $currency, ')
          ..write('isinId: $isinId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, symbol, exchange, currency, isinId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TickerData &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.exchange == this.exchange &&
          other.currency == this.currency &&
          other.isinId == this.isinId);
}

class TickersCompanion extends UpdateCompanion<TickerData> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<String> exchange;
  final Value<String> currency;
  final Value<int> isinId;
  const TickersCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.exchange = const Value.absent(),
    this.currency = const Value.absent(),
    this.isinId = const Value.absent(),
  });
  TickersCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required String exchange,
    required String currency,
    required int isinId,
  })  : symbol = Value(symbol),
        exchange = Value(exchange),
        currency = Value(currency),
        isinId = Value(isinId);
  static Insertable<TickerData> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<String>? exchange,
    Expression<String>? currency,
    Expression<int>? isinId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (exchange != null) 'exchange': exchange,
      if (currency != null) 'currency': currency,
      if (isinId != null) 'isin_id': isinId,
    });
  }

  TickersCompanion copyWith(
      {Value<int>? id,
      Value<String>? symbol,
      Value<String>? exchange,
      Value<String>? currency,
      Value<int>? isinId}) {
    return TickersCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      exchange: exchange ?? this.exchange,
      currency: currency ?? this.currency,
      isinId: isinId ?? this.isinId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (exchange.present) {
      map['exchange'] = Variable<String>(exchange.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (isinId.present) {
      map['isin_id'] = Variable<int>(isinId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TickersCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('exchange: $exchange, ')
          ..write('currency: $currency, ')
          ..write('isinId: $isinId')
          ..write(')'))
        .toString();
  }
}

class $PositionsTable extends Positions
    with TableInfo<$PositionsTable, PositionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _capitalInvestedMeta =
      const VerificationMeta('capitalInvested');
  @override
  late final GeneratedColumn<double> capitalInvested = GeneratedColumn<double>(
      'capital_invested', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _purchasePriceMeta =
      const VerificationMeta('purchasePrice');
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
      'purchase_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tickerIdMeta =
      const VerificationMeta('tickerId');
  @override
  late final GeneratedColumn<int> tickerId = GeneratedColumn<int>(
      'ticker_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tickers (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, capitalInvested, purchasePrice, tickerId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'positions';
  @override
  VerificationContext validateIntegrity(Insertable<PositionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('capital_invested')) {
      context.handle(
          _capitalInvestedMeta,
          capitalInvested.isAcceptableOrUnknown(
              data['capital_invested']!, _capitalInvestedMeta));
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
          _purchasePriceMeta,
          purchasePrice.isAcceptableOrUnknown(
              data['purchase_price']!, _purchasePriceMeta));
    }
    if (data.containsKey('ticker_id')) {
      context.handle(_tickerIdMeta,
          tickerId.isAcceptableOrUnknown(data['ticker_id']!, _tickerIdMeta));
    } else if (isInserting) {
      context.missing(_tickerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PositionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PositionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      capitalInvested: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}capital_invested'])!,
      purchasePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}purchase_price'])!,
      tickerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ticker_id'])!,
    );
  }

  @override
  $PositionsTable createAlias(String alias) {
    return $PositionsTable(attachedDatabase, alias);
  }
}

class PositionData extends DataClass implements Insertable<PositionData> {
  final int id;
  final double capitalInvested;
  final double purchasePrice;
  final int tickerId;
  const PositionData(
      {required this.id,
      required this.capitalInvested,
      required this.purchasePrice,
      required this.tickerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['capital_invested'] = Variable<double>(capitalInvested);
    map['purchase_price'] = Variable<double>(purchasePrice);
    map['ticker_id'] = Variable<int>(tickerId);
    return map;
  }

  PositionsCompanion toCompanion(bool nullToAbsent) {
    return PositionsCompanion(
      id: Value(id),
      capitalInvested: Value(capitalInvested),
      purchasePrice: Value(purchasePrice),
      tickerId: Value(tickerId),
    );
  }

  factory PositionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PositionData(
      id: serializer.fromJson<int>(json['id']),
      capitalInvested: serializer.fromJson<double>(json['capitalInvested']),
      purchasePrice: serializer.fromJson<double>(json['purchasePrice']),
      tickerId: serializer.fromJson<int>(json['tickerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'capitalInvested': serializer.toJson<double>(capitalInvested),
      'purchasePrice': serializer.toJson<double>(purchasePrice),
      'tickerId': serializer.toJson<int>(tickerId),
    };
  }

  PositionData copyWith(
          {int? id,
          double? capitalInvested,
          double? purchasePrice,
          int? tickerId}) =>
      PositionData(
        id: id ?? this.id,
        capitalInvested: capitalInvested ?? this.capitalInvested,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        tickerId: tickerId ?? this.tickerId,
      );
  PositionData copyWithCompanion(PositionsCompanion data) {
    return PositionData(
      id: data.id.present ? data.id.value : this.id,
      capitalInvested: data.capitalInvested.present
          ? data.capitalInvested.value
          : this.capitalInvested,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      tickerId: data.tickerId.present ? data.tickerId.value : this.tickerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PositionData(')
          ..write('id: $id, ')
          ..write('capitalInvested: $capitalInvested, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('tickerId: $tickerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, capitalInvested, purchasePrice, tickerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PositionData &&
          other.id == this.id &&
          other.capitalInvested == this.capitalInvested &&
          other.purchasePrice == this.purchasePrice &&
          other.tickerId == this.tickerId);
}

class PositionsCompanion extends UpdateCompanion<PositionData> {
  final Value<int> id;
  final Value<double> capitalInvested;
  final Value<double> purchasePrice;
  final Value<int> tickerId;
  const PositionsCompanion({
    this.id = const Value.absent(),
    this.capitalInvested = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.tickerId = const Value.absent(),
  });
  PositionsCompanion.insert({
    this.id = const Value.absent(),
    this.capitalInvested = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    required int tickerId,
  }) : tickerId = Value(tickerId);
  static Insertable<PositionData> custom({
    Expression<int>? id,
    Expression<double>? capitalInvested,
    Expression<double>? purchasePrice,
    Expression<int>? tickerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (capitalInvested != null) 'capital_invested': capitalInvested,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (tickerId != null) 'ticker_id': tickerId,
    });
  }

  PositionsCompanion copyWith(
      {Value<int>? id,
      Value<double>? capitalInvested,
      Value<double>? purchasePrice,
      Value<int>? tickerId}) {
    return PositionsCompanion(
      id: id ?? this.id,
      capitalInvested: capitalInvested ?? this.capitalInvested,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      tickerId: tickerId ?? this.tickerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (capitalInvested.present) {
      map['capital_invested'] = Variable<double>(capitalInvested.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (tickerId.present) {
      map['ticker_id'] = Variable<int>(tickerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PositionsCompanion(')
          ..write('id: $id, ')
          ..write('capitalInvested: $capitalInvested, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('tickerId: $tickerId')
          ..write(')'))
        .toString();
  }
}

class $MarketDataCachesTable extends MarketDataCaches
    with TableInfo<$MarketDataCachesTable, MarketDataCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarketDataCachesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _regularMarketPriceMeta =
      const VerificationMeta('regularMarketPrice');
  @override
  late final GeneratedColumn<double> regularMarketPrice =
      GeneratedColumn<double>('regular_market_price', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _chartPreviousCloseMeta =
      const VerificationMeta('chartPreviousClose');
  @override
  late final GeneratedColumn<double> chartPreviousClose =
      GeneratedColumn<double>('chart_previous_close', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  @override
  late final GeneratedColumnWithTypeConverter<List<double>, String>
      intradayPrices = GeneratedColumn<String>(
              'intraday_prices', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<double>>(
              $MarketDataCachesTable.$converterintradayPrices);
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String>
      intradayTimestamps = GeneratedColumn<String>(
              'intraday_timestamps', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<int>>(
              $MarketDataCachesTable.$converterintradayTimestamps);
  static const VerificationMeta _tickerIdMeta =
      const VerificationMeta('tickerId');
  @override
  late final GeneratedColumn<int> tickerId = GeneratedColumn<int>(
      'ticker_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tickers (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        symbol,
        lastUpdated,
        regularMarketPrice,
        chartPreviousClose,
        intradayPrices,
        intradayTimestamps,
        tickerId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'market_data_caches';
  @override
  VerificationContext validateIntegrity(
      Insertable<MarketDataCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('regular_market_price')) {
      context.handle(
          _regularMarketPriceMeta,
          regularMarketPrice.isAcceptableOrUnknown(
              data['regular_market_price']!, _regularMarketPriceMeta));
    }
    if (data.containsKey('chart_previous_close')) {
      context.handle(
          _chartPreviousCloseMeta,
          chartPreviousClose.isAcceptableOrUnknown(
              data['chart_previous_close']!, _chartPreviousCloseMeta));
    }
    if (data.containsKey('ticker_id')) {
      context.handle(_tickerIdMeta,
          tickerId.isAcceptableOrUnknown(data['ticker_id']!, _tickerIdMeta));
    } else if (isInserting) {
      context.missing(_tickerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MarketDataCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MarketDataCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
      regularMarketPrice: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}regular_market_price'])!,
      chartPreviousClose: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}chart_previous_close'])!,
      intradayPrices: $MarketDataCachesTable.$converterintradayPrices.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}intraday_prices'])!),
      intradayTimestamps: $MarketDataCachesTable.$converterintradayTimestamps
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}intraday_timestamps'])!),
      tickerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ticker_id'])!,
    );
  }

  @override
  $MarketDataCachesTable createAlias(String alias) {
    return $MarketDataCachesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<double>, String> $converterintradayPrices =
      const DoubleListConverter();
  static TypeConverter<List<int>, String> $converterintradayTimestamps =
      const IntListConverter();
}

class MarketDataCacheData extends DataClass
    implements Insertable<MarketDataCacheData> {
  final int id;
  final String symbol;
  final DateTime lastUpdated;
  final double regularMarketPrice;
  final double chartPreviousClose;
  final List<double> intradayPrices;
  final List<int> intradayTimestamps;
  final int tickerId;
  const MarketDataCacheData(
      {required this.id,
      required this.symbol,
      required this.lastUpdated,
      required this.regularMarketPrice,
      required this.chartPreviousClose,
      required this.intradayPrices,
      required this.intradayTimestamps,
      required this.tickerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['regular_market_price'] = Variable<double>(regularMarketPrice);
    map['chart_previous_close'] = Variable<double>(chartPreviousClose);
    {
      map['intraday_prices'] = Variable<String>($MarketDataCachesTable
          .$converterintradayPrices
          .toSql(intradayPrices));
    }
    {
      map['intraday_timestamps'] = Variable<String>($MarketDataCachesTable
          .$converterintradayTimestamps
          .toSql(intradayTimestamps));
    }
    map['ticker_id'] = Variable<int>(tickerId);
    return map;
  }

  MarketDataCachesCompanion toCompanion(bool nullToAbsent) {
    return MarketDataCachesCompanion(
      id: Value(id),
      symbol: Value(symbol),
      lastUpdated: Value(lastUpdated),
      regularMarketPrice: Value(regularMarketPrice),
      chartPreviousClose: Value(chartPreviousClose),
      intradayPrices: Value(intradayPrices),
      intradayTimestamps: Value(intradayTimestamps),
      tickerId: Value(tickerId),
    );
  }

  factory MarketDataCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarketDataCacheData(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      regularMarketPrice:
          serializer.fromJson<double>(json['regularMarketPrice']),
      chartPreviousClose:
          serializer.fromJson<double>(json['chartPreviousClose']),
      intradayPrices: serializer.fromJson<List<double>>(json['intradayPrices']),
      intradayTimestamps:
          serializer.fromJson<List<int>>(json['intradayTimestamps']),
      tickerId: serializer.fromJson<int>(json['tickerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'symbol': serializer.toJson<String>(symbol),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'regularMarketPrice': serializer.toJson<double>(regularMarketPrice),
      'chartPreviousClose': serializer.toJson<double>(chartPreviousClose),
      'intradayPrices': serializer.toJson<List<double>>(intradayPrices),
      'intradayTimestamps': serializer.toJson<List<int>>(intradayTimestamps),
      'tickerId': serializer.toJson<int>(tickerId),
    };
  }

  MarketDataCacheData copyWith(
          {int? id,
          String? symbol,
          DateTime? lastUpdated,
          double? regularMarketPrice,
          double? chartPreviousClose,
          List<double>? intradayPrices,
          List<int>? intradayTimestamps,
          int? tickerId}) =>
      MarketDataCacheData(
        id: id ?? this.id,
        symbol: symbol ?? this.symbol,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        regularMarketPrice: regularMarketPrice ?? this.regularMarketPrice,
        chartPreviousClose: chartPreviousClose ?? this.chartPreviousClose,
        intradayPrices: intradayPrices ?? this.intradayPrices,
        intradayTimestamps: intradayTimestamps ?? this.intradayTimestamps,
        tickerId: tickerId ?? this.tickerId,
      );
  MarketDataCacheData copyWithCompanion(MarketDataCachesCompanion data) {
    return MarketDataCacheData(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      regularMarketPrice: data.regularMarketPrice.present
          ? data.regularMarketPrice.value
          : this.regularMarketPrice,
      chartPreviousClose: data.chartPreviousClose.present
          ? data.chartPreviousClose.value
          : this.chartPreviousClose,
      intradayPrices: data.intradayPrices.present
          ? data.intradayPrices.value
          : this.intradayPrices,
      intradayTimestamps: data.intradayTimestamps.present
          ? data.intradayTimestamps.value
          : this.intradayTimestamps,
      tickerId: data.tickerId.present ? data.tickerId.value : this.tickerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MarketDataCacheData(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('regularMarketPrice: $regularMarketPrice, ')
          ..write('chartPreviousClose: $chartPreviousClose, ')
          ..write('intradayPrices: $intradayPrices, ')
          ..write('intradayTimestamps: $intradayTimestamps, ')
          ..write('tickerId: $tickerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, symbol, lastUpdated, regularMarketPrice,
      chartPreviousClose, intradayPrices, intradayTimestamps, tickerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarketDataCacheData &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.lastUpdated == this.lastUpdated &&
          other.regularMarketPrice == this.regularMarketPrice &&
          other.chartPreviousClose == this.chartPreviousClose &&
          other.intradayPrices == this.intradayPrices &&
          other.intradayTimestamps == this.intradayTimestamps &&
          other.tickerId == this.tickerId);
}

class MarketDataCachesCompanion extends UpdateCompanion<MarketDataCacheData> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<DateTime> lastUpdated;
  final Value<double> regularMarketPrice;
  final Value<double> chartPreviousClose;
  final Value<List<double>> intradayPrices;
  final Value<List<int>> intradayTimestamps;
  final Value<int> tickerId;
  const MarketDataCachesCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.regularMarketPrice = const Value.absent(),
    this.chartPreviousClose = const Value.absent(),
    this.intradayPrices = const Value.absent(),
    this.intradayTimestamps = const Value.absent(),
    this.tickerId = const Value.absent(),
  });
  MarketDataCachesCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required DateTime lastUpdated,
    this.regularMarketPrice = const Value.absent(),
    this.chartPreviousClose = const Value.absent(),
    this.intradayPrices = const Value.absent(),
    this.intradayTimestamps = const Value.absent(),
    required int tickerId,
  })  : symbol = Value(symbol),
        lastUpdated = Value(lastUpdated),
        tickerId = Value(tickerId);
  static Insertable<MarketDataCacheData> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<DateTime>? lastUpdated,
    Expression<double>? regularMarketPrice,
    Expression<double>? chartPreviousClose,
    Expression<String>? intradayPrices,
    Expression<String>? intradayTimestamps,
    Expression<int>? tickerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (regularMarketPrice != null)
        'regular_market_price': regularMarketPrice,
      if (chartPreviousClose != null)
        'chart_previous_close': chartPreviousClose,
      if (intradayPrices != null) 'intraday_prices': intradayPrices,
      if (intradayTimestamps != null) 'intraday_timestamps': intradayTimestamps,
      if (tickerId != null) 'ticker_id': tickerId,
    });
  }

  MarketDataCachesCompanion copyWith(
      {Value<int>? id,
      Value<String>? symbol,
      Value<DateTime>? lastUpdated,
      Value<double>? regularMarketPrice,
      Value<double>? chartPreviousClose,
      Value<List<double>>? intradayPrices,
      Value<List<int>>? intradayTimestamps,
      Value<int>? tickerId}) {
    return MarketDataCachesCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      regularMarketPrice: regularMarketPrice ?? this.regularMarketPrice,
      chartPreviousClose: chartPreviousClose ?? this.chartPreviousClose,
      intradayPrices: intradayPrices ?? this.intradayPrices,
      intradayTimestamps: intradayTimestamps ?? this.intradayTimestamps,
      tickerId: tickerId ?? this.tickerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (regularMarketPrice.present) {
      map['regular_market_price'] = Variable<double>(regularMarketPrice.value);
    }
    if (chartPreviousClose.present) {
      map['chart_previous_close'] = Variable<double>(chartPreviousClose.value);
    }
    if (intradayPrices.present) {
      map['intraday_prices'] = Variable<String>($MarketDataCachesTable
          .$converterintradayPrices
          .toSql(intradayPrices.value));
    }
    if (intradayTimestamps.present) {
      map['intraday_timestamps'] = Variable<String>($MarketDataCachesTable
          .$converterintradayTimestamps
          .toSql(intradayTimestamps.value));
    }
    if (tickerId.present) {
      map['ticker_id'] = Variable<int>(tickerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarketDataCachesCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('regularMarketPrice: $regularMarketPrice, ')
          ..write('chartPreviousClose: $chartPreviousClose, ')
          ..write('intradayPrices: $intradayPrices, ')
          ..write('intradayTimestamps: $intradayTimestamps, ')
          ..write('tickerId: $tickerId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IsinsTable isins = $IsinsTable(this);
  late final $TickersTable tickers = $TickersTable(this);
  late final $PositionsTable positions = $PositionsTable(this);
  late final $MarketDataCachesTable marketDataCaches =
      $MarketDataCachesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [isins, tickers, positions, marketDataCaches];
}

typedef $$IsinsTableCreateCompanionBuilder = IsinsCompanion Function({
  Value<int> id,
  required String isinCode,
  required String name,
  Value<String?> shortName,
});
typedef $$IsinsTableUpdateCompanionBuilder = IsinsCompanion Function({
  Value<int> id,
  Value<String> isinCode,
  Value<String> name,
  Value<String?> shortName,
});

final class $$IsinsTableReferences
    extends BaseReferences<_$AppDatabase, $IsinsTable, IsinData> {
  $$IsinsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TickersTable, List<TickerData>> _tickersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.tickers,
          aliasName: $_aliasNameGenerator(db.isins.id, db.tickers.isinId));

  $$TickersTableProcessedTableManager get tickersRefs {
    final manager = $$TickersTableTableManager($_db, $_db.tickers)
        .filter((f) => f.isinId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tickersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$IsinsTableFilterComposer extends Composer<_$AppDatabase, $IsinsTable> {
  $$IsinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get isinCode => $composableBuilder(
      column: $table.isinCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shortName => $composableBuilder(
      column: $table.shortName, builder: (column) => ColumnFilters(column));

  Expression<bool> tickersRefs(
      Expression<bool> Function($$TickersTableFilterComposer f) f) {
    final $$TickersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tickers,
        getReferencedColumn: (t) => t.isinId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TickersTableFilterComposer(
              $db: $db,
              $table: $db.tickers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$IsinsTableOrderingComposer
    extends Composer<_$AppDatabase, $IsinsTable> {
  $$IsinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get isinCode => $composableBuilder(
      column: $table.isinCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shortName => $composableBuilder(
      column: $table.shortName, builder: (column) => ColumnOrderings(column));
}

class $$IsinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IsinsTable> {
  $$IsinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get isinCode =>
      $composableBuilder(column: $table.isinCode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get shortName =>
      $composableBuilder(column: $table.shortName, builder: (column) => column);

  Expression<T> tickersRefs<T extends Object>(
      Expression<T> Function($$TickersTableAnnotationComposer a) f) {
    final $$TickersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tickers,
        getReferencedColumn: (t) => t.isinId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TickersTableAnnotationComposer(
              $db: $db,
              $table: $db.tickers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$IsinsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IsinsTable,
    IsinData,
    $$IsinsTableFilterComposer,
    $$IsinsTableOrderingComposer,
    $$IsinsTableAnnotationComposer,
    $$IsinsTableCreateCompanionBuilder,
    $$IsinsTableUpdateCompanionBuilder,
    (IsinData, $$IsinsTableReferences),
    IsinData,
    PrefetchHooks Function({bool tickersRefs})> {
  $$IsinsTableTableManager(_$AppDatabase db, $IsinsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IsinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IsinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IsinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> isinCode = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> shortName = const Value.absent(),
          }) =>
              IsinsCompanion(
            id: id,
            isinCode: isinCode,
            name: name,
            shortName: shortName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String isinCode,
            required String name,
            Value<String?> shortName = const Value.absent(),
          }) =>
              IsinsCompanion.insert(
            id: id,
            isinCode: isinCode,
            name: name,
            shortName: shortName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$IsinsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({tickersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tickersRefs) db.tickers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tickersRefs)
                    await $_getPrefetchedData<IsinData, $IsinsTable,
                            TickerData>(
                        currentTable: table,
                        referencedTable:
                            $$IsinsTableReferences._tickersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IsinsTableReferences(db, table, p0).tickersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.isinId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$IsinsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IsinsTable,
    IsinData,
    $$IsinsTableFilterComposer,
    $$IsinsTableOrderingComposer,
    $$IsinsTableAnnotationComposer,
    $$IsinsTableCreateCompanionBuilder,
    $$IsinsTableUpdateCompanionBuilder,
    (IsinData, $$IsinsTableReferences),
    IsinData,
    PrefetchHooks Function({bool tickersRefs})>;
typedef $$TickersTableCreateCompanionBuilder = TickersCompanion Function({
  Value<int> id,
  required String symbol,
  required String exchange,
  required String currency,
  required int isinId,
});
typedef $$TickersTableUpdateCompanionBuilder = TickersCompanion Function({
  Value<int> id,
  Value<String> symbol,
  Value<String> exchange,
  Value<String> currency,
  Value<int> isinId,
});

final class $$TickersTableReferences
    extends BaseReferences<_$AppDatabase, $TickersTable, TickerData> {
  $$TickersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IsinsTable _isinIdTable(_$AppDatabase db) => db.isins
      .createAlias($_aliasNameGenerator(db.tickers.isinId, db.isins.id));

  $$IsinsTableProcessedTableManager get isinId {
    final $_column = $_itemColumn<int>('isin_id')!;

    final manager = $$IsinsTableTableManager($_db, $_db.isins)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_isinIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PositionsTable, List<PositionData>>
      _positionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.positions,
              aliasName:
                  $_aliasNameGenerator(db.tickers.id, db.positions.tickerId));

  $$PositionsTableProcessedTableManager get positionsRefs {
    final manager = $$PositionsTableTableManager($_db, $_db.positions)
        .filter((f) => f.tickerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_positionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MarketDataCachesTable, List<MarketDataCacheData>>
      _marketDataCachesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.marketDataCaches,
              aliasName: $_aliasNameGenerator(
                  db.tickers.id, db.marketDataCaches.tickerId));

  $$MarketDataCachesTableProcessedTableManager get marketDataCachesRefs {
    final manager =
        $$MarketDataCachesTableTableManager($_db, $_db.marketDataCaches)
            .filter((f) => f.tickerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_marketDataCachesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TickersTableFilterComposer
    extends Composer<_$AppDatabase, $TickersTable> {
  $$TickersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exchange => $composableBuilder(
      column: $table.exchange, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  $$IsinsTableFilterComposer get isinId {
    final $$IsinsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.isinId,
        referencedTable: $db.isins,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IsinsTableFilterComposer(
              $db: $db,
              $table: $db.isins,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> positionsRefs(
      Expression<bool> Function($$PositionsTableFilterComposer f) f) {
    final $$PositionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.positions,
        getReferencedColumn: (t) => t.tickerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PositionsTableFilterComposer(
              $db: $db,
              $table: $db.positions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> marketDataCachesRefs(
      Expression<bool> Function($$MarketDataCachesTableFilterComposer f) f) {
    final $$MarketDataCachesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.marketDataCaches,
        getReferencedColumn: (t) => t.tickerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MarketDataCachesTableFilterComposer(
              $db: $db,
              $table: $db.marketDataCaches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TickersTableOrderingComposer
    extends Composer<_$AppDatabase, $TickersTable> {
  $$TickersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exchange => $composableBuilder(
      column: $table.exchange, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  $$IsinsTableOrderingComposer get isinId {
    final $$IsinsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.isinId,
        referencedTable: $db.isins,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IsinsTableOrderingComposer(
              $db: $db,
              $table: $db.isins,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TickersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TickersTable> {
  $$TickersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get exchange =>
      $composableBuilder(column: $table.exchange, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  $$IsinsTableAnnotationComposer get isinId {
    final $$IsinsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.isinId,
        referencedTable: $db.isins,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IsinsTableAnnotationComposer(
              $db: $db,
              $table: $db.isins,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> positionsRefs<T extends Object>(
      Expression<T> Function($$PositionsTableAnnotationComposer a) f) {
    final $$PositionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.positions,
        getReferencedColumn: (t) => t.tickerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PositionsTableAnnotationComposer(
              $db: $db,
              $table: $db.positions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> marketDataCachesRefs<T extends Object>(
      Expression<T> Function($$MarketDataCachesTableAnnotationComposer a) f) {
    final $$MarketDataCachesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.marketDataCaches,
        getReferencedColumn: (t) => t.tickerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MarketDataCachesTableAnnotationComposer(
              $db: $db,
              $table: $db.marketDataCaches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TickersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TickersTable,
    TickerData,
    $$TickersTableFilterComposer,
    $$TickersTableOrderingComposer,
    $$TickersTableAnnotationComposer,
    $$TickersTableCreateCompanionBuilder,
    $$TickersTableUpdateCompanionBuilder,
    (TickerData, $$TickersTableReferences),
    TickerData,
    PrefetchHooks Function(
        {bool isinId, bool positionsRefs, bool marketDataCachesRefs})> {
  $$TickersTableTableManager(_$AppDatabase db, $TickersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TickersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TickersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TickersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> exchange = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<int> isinId = const Value.absent(),
          }) =>
              TickersCompanion(
            id: id,
            symbol: symbol,
            exchange: exchange,
            currency: currency,
            isinId: isinId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String symbol,
            required String exchange,
            required String currency,
            required int isinId,
          }) =>
              TickersCompanion.insert(
            id: id,
            symbol: symbol,
            exchange: exchange,
            currency: currency,
            isinId: isinId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TickersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {isinId = false,
              positionsRefs = false,
              marketDataCachesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (positionsRefs) db.positions,
                if (marketDataCachesRefs) db.marketDataCaches
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (isinId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.isinId,
                    referencedTable: $$TickersTableReferences._isinIdTable(db),
                    referencedColumn:
                        $$TickersTableReferences._isinIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (positionsRefs)
                    await $_getPrefetchedData<TickerData, $TickersTable,
                            PositionData>(
                        currentTable: table,
                        referencedTable:
                            $$TickersTableReferences._positionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TickersTableReferences(db, table, p0)
                                .positionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tickerId == item.id),
                        typedResults: items),
                  if (marketDataCachesRefs)
                    await $_getPrefetchedData<TickerData, $TickersTable,
                            MarketDataCacheData>(
                        currentTable: table,
                        referencedTable: $$TickersTableReferences
                            ._marketDataCachesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TickersTableReferences(db, table, p0)
                                .marketDataCachesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tickerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TickersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TickersTable,
    TickerData,
    $$TickersTableFilterComposer,
    $$TickersTableOrderingComposer,
    $$TickersTableAnnotationComposer,
    $$TickersTableCreateCompanionBuilder,
    $$TickersTableUpdateCompanionBuilder,
    (TickerData, $$TickersTableReferences),
    TickerData,
    PrefetchHooks Function(
        {bool isinId, bool positionsRefs, bool marketDataCachesRefs})>;
typedef $$PositionsTableCreateCompanionBuilder = PositionsCompanion Function({
  Value<int> id,
  Value<double> capitalInvested,
  Value<double> purchasePrice,
  required int tickerId,
});
typedef $$PositionsTableUpdateCompanionBuilder = PositionsCompanion Function({
  Value<int> id,
  Value<double> capitalInvested,
  Value<double> purchasePrice,
  Value<int> tickerId,
});

final class $$PositionsTableReferences
    extends BaseReferences<_$AppDatabase, $PositionsTable, PositionData> {
  $$PositionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TickersTable _tickerIdTable(_$AppDatabase db) => db.tickers
      .createAlias($_aliasNameGenerator(db.positions.tickerId, db.tickers.id));

  $$TickersTableProcessedTableManager get tickerId {
    final $_column = $_itemColumn<int>('ticker_id')!;

    final manager = $$TickersTableTableManager($_db, $_db.tickers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tickerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PositionsTableFilterComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get capitalInvested => $composableBuilder(
      column: $table.capitalInvested,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => ColumnFilters(column));

  $$TickersTableFilterComposer get tickerId {
    final $$TickersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tickerId,
        referencedTable: $db.tickers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TickersTableFilterComposer(
              $db: $db,
              $table: $db.tickers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get capitalInvested => $composableBuilder(
      column: $table.capitalInvested,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice,
      builder: (column) => ColumnOrderings(column));

  $$TickersTableOrderingComposer get tickerId {
    final $$TickersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tickerId,
        referencedTable: $db.tickers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TickersTableOrderingComposer(
              $db: $db,
              $table: $db.tickers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get capitalInvested => $composableBuilder(
      column: $table.capitalInvested, builder: (column) => column);

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => column);

  $$TickersTableAnnotationComposer get tickerId {
    final $$TickersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tickerId,
        referencedTable: $db.tickers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TickersTableAnnotationComposer(
              $db: $db,
              $table: $db.tickers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PositionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PositionsTable,
    PositionData,
    $$PositionsTableFilterComposer,
    $$PositionsTableOrderingComposer,
    $$PositionsTableAnnotationComposer,
    $$PositionsTableCreateCompanionBuilder,
    $$PositionsTableUpdateCompanionBuilder,
    (PositionData, $$PositionsTableReferences),
    PositionData,
    PrefetchHooks Function({bool tickerId})> {
  $$PositionsTableTableManager(_$AppDatabase db, $PositionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> capitalInvested = const Value.absent(),
            Value<double> purchasePrice = const Value.absent(),
            Value<int> tickerId = const Value.absent(),
          }) =>
              PositionsCompanion(
            id: id,
            capitalInvested: capitalInvested,
            purchasePrice: purchasePrice,
            tickerId: tickerId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> capitalInvested = const Value.absent(),
            Value<double> purchasePrice = const Value.absent(),
            required int tickerId,
          }) =>
              PositionsCompanion.insert(
            id: id,
            capitalInvested: capitalInvested,
            purchasePrice: purchasePrice,
            tickerId: tickerId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PositionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tickerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tickerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tickerId,
                    referencedTable:
                        $$PositionsTableReferences._tickerIdTable(db),
                    referencedColumn:
                        $$PositionsTableReferences._tickerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PositionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PositionsTable,
    PositionData,
    $$PositionsTableFilterComposer,
    $$PositionsTableOrderingComposer,
    $$PositionsTableAnnotationComposer,
    $$PositionsTableCreateCompanionBuilder,
    $$PositionsTableUpdateCompanionBuilder,
    (PositionData, $$PositionsTableReferences),
    PositionData,
    PrefetchHooks Function({bool tickerId})>;
typedef $$MarketDataCachesTableCreateCompanionBuilder
    = MarketDataCachesCompanion Function({
  Value<int> id,
  required String symbol,
  required DateTime lastUpdated,
  Value<double> regularMarketPrice,
  Value<double> chartPreviousClose,
  Value<List<double>> intradayPrices,
  Value<List<int>> intradayTimestamps,
  required int tickerId,
});
typedef $$MarketDataCachesTableUpdateCompanionBuilder
    = MarketDataCachesCompanion Function({
  Value<int> id,
  Value<String> symbol,
  Value<DateTime> lastUpdated,
  Value<double> regularMarketPrice,
  Value<double> chartPreviousClose,
  Value<List<double>> intradayPrices,
  Value<List<int>> intradayTimestamps,
  Value<int> tickerId,
});

final class $$MarketDataCachesTableReferences extends BaseReferences<
    _$AppDatabase, $MarketDataCachesTable, MarketDataCacheData> {
  $$MarketDataCachesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TickersTable _tickerIdTable(_$AppDatabase db) =>
      db.tickers.createAlias(
          $_aliasNameGenerator(db.marketDataCaches.tickerId, db.tickers.id));

  $$TickersTableProcessedTableManager get tickerId {
    final $_column = $_itemColumn<int>('ticker_id')!;

    final manager = $$TickersTableTableManager($_db, $_db.tickers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tickerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MarketDataCachesTableFilterComposer
    extends Composer<_$AppDatabase, $MarketDataCachesTable> {
  $$MarketDataCachesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get regularMarketPrice => $composableBuilder(
      column: $table.regularMarketPrice,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get chartPreviousClose => $composableBuilder(
      column: $table.chartPreviousClose,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<double>, List<double>, String>
      get intradayPrices => $composableBuilder(
          column: $table.intradayPrices,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<int>, List<int>, String>
      get intradayTimestamps => $composableBuilder(
          column: $table.intradayTimestamps,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$TickersTableFilterComposer get tickerId {
    final $$TickersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tickerId,
        referencedTable: $db.tickers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TickersTableFilterComposer(
              $db: $db,
              $table: $db.tickers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MarketDataCachesTableOrderingComposer
    extends Composer<_$AppDatabase, $MarketDataCachesTable> {
  $$MarketDataCachesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get regularMarketPrice => $composableBuilder(
      column: $table.regularMarketPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get chartPreviousClose => $composableBuilder(
      column: $table.chartPreviousClose,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get intradayPrices => $composableBuilder(
      column: $table.intradayPrices,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get intradayTimestamps => $composableBuilder(
      column: $table.intradayTimestamps,
      builder: (column) => ColumnOrderings(column));

  $$TickersTableOrderingComposer get tickerId {
    final $$TickersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tickerId,
        referencedTable: $db.tickers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TickersTableOrderingComposer(
              $db: $db,
              $table: $db.tickers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MarketDataCachesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MarketDataCachesTable> {
  $$MarketDataCachesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<double> get regularMarketPrice => $composableBuilder(
      column: $table.regularMarketPrice, builder: (column) => column);

  GeneratedColumn<double> get chartPreviousClose => $composableBuilder(
      column: $table.chartPreviousClose, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<double>, String> get intradayPrices =>
      $composableBuilder(
          column: $table.intradayPrices, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get intradayTimestamps =>
      $composableBuilder(
          column: $table.intradayTimestamps, builder: (column) => column);

  $$TickersTableAnnotationComposer get tickerId {
    final $$TickersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tickerId,
        referencedTable: $db.tickers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TickersTableAnnotationComposer(
              $db: $db,
              $table: $db.tickers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MarketDataCachesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MarketDataCachesTable,
    MarketDataCacheData,
    $$MarketDataCachesTableFilterComposer,
    $$MarketDataCachesTableOrderingComposer,
    $$MarketDataCachesTableAnnotationComposer,
    $$MarketDataCachesTableCreateCompanionBuilder,
    $$MarketDataCachesTableUpdateCompanionBuilder,
    (MarketDataCacheData, $$MarketDataCachesTableReferences),
    MarketDataCacheData,
    PrefetchHooks Function({bool tickerId})> {
  $$MarketDataCachesTableTableManager(
      _$AppDatabase db, $MarketDataCachesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarketDataCachesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarketDataCachesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarketDataCachesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<double> regularMarketPrice = const Value.absent(),
            Value<double> chartPreviousClose = const Value.absent(),
            Value<List<double>> intradayPrices = const Value.absent(),
            Value<List<int>> intradayTimestamps = const Value.absent(),
            Value<int> tickerId = const Value.absent(),
          }) =>
              MarketDataCachesCompanion(
            id: id,
            symbol: symbol,
            lastUpdated: lastUpdated,
            regularMarketPrice: regularMarketPrice,
            chartPreviousClose: chartPreviousClose,
            intradayPrices: intradayPrices,
            intradayTimestamps: intradayTimestamps,
            tickerId: tickerId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String symbol,
            required DateTime lastUpdated,
            Value<double> regularMarketPrice = const Value.absent(),
            Value<double> chartPreviousClose = const Value.absent(),
            Value<List<double>> intradayPrices = const Value.absent(),
            Value<List<int>> intradayTimestamps = const Value.absent(),
            required int tickerId,
          }) =>
              MarketDataCachesCompanion.insert(
            id: id,
            symbol: symbol,
            lastUpdated: lastUpdated,
            regularMarketPrice: regularMarketPrice,
            chartPreviousClose: chartPreviousClose,
            intradayPrices: intradayPrices,
            intradayTimestamps: intradayTimestamps,
            tickerId: tickerId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MarketDataCachesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tickerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tickerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tickerId,
                    referencedTable:
                        $$MarketDataCachesTableReferences._tickerIdTable(db),
                    referencedColumn:
                        $$MarketDataCachesTableReferences._tickerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MarketDataCachesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MarketDataCachesTable,
    MarketDataCacheData,
    $$MarketDataCachesTableFilterComposer,
    $$MarketDataCachesTableOrderingComposer,
    $$MarketDataCachesTableAnnotationComposer,
    $$MarketDataCachesTableCreateCompanionBuilder,
    $$MarketDataCachesTableUpdateCompanionBuilder,
    (MarketDataCacheData, $$MarketDataCachesTableReferences),
    MarketDataCacheData,
    PrefetchHooks Function({bool tickerId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IsinsTableTableManager get isins =>
      $$IsinsTableTableManager(_db, _db.isins);
  $$TickersTableTableManager get tickers =>
      $$TickersTableTableManager(_db, _db.tickers);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db, _db.positions);
  $$MarketDataCachesTableTableManager get marketDataCaches =>
      $$MarketDataCachesTableTableManager(_db, _db.marketDataCaches);
}
