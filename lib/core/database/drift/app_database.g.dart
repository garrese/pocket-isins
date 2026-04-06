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
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _isinCodeMeta = const VerificationMeta(
    'isinCode',
  );
  @override
  late final GeneratedColumn<String> isinCode = GeneratedColumn<String>(
    'isin_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _altNameMeta = const VerificationMeta(
    'altName',
  );
  @override
  late final GeneratedColumn<String> altName = GeneratedColumn<String>(
    'alt_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  registeredNames = GeneratedColumn<String>(
    'registered_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($IsinsTable.$converterregisteredNames);
  static const VerificationMeta _shortNameMeta = const VerificationMeta(
    'shortName',
  );
  @override
  late final GeneratedColumn<String> shortName = GeneratedColumn<String>(
    'short_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isinCode,
    altName,
    registeredNames,
    shortName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'isins';
  @override
  VerificationContext validateIntegrity(
    Insertable<IsinData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('isin_code')) {
      context.handle(
        _isinCodeMeta,
        isinCode.isAcceptableOrUnknown(data['isin_code']!, _isinCodeMeta),
      );
    }
    if (data.containsKey('alt_name')) {
      context.handle(
        _altNameMeta,
        altName.isAcceptableOrUnknown(data['alt_name']!, _altNameMeta),
      );
    }
    if (data.containsKey('short_name')) {
      context.handle(
        _shortNameMeta,
        shortName.isAcceptableOrUnknown(data['short_name']!, _shortNameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IsinData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IsinData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      isinCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isin_code'],
      ),
      altName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alt_name'],
      ),
      registeredNames: $IsinsTable.$converterregisteredNames.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}registered_names'],
        )!,
      ),
      shortName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_name'],
      ),
    );
  }

  @override
  $IsinsTable createAlias(String alias) {
    return $IsinsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterregisteredNames =
      const StringListConverter();
}

class IsinData extends DataClass implements Insertable<IsinData> {
  final int id;
  final String? isinCode;
  final String? altName;
  final List<String> registeredNames;
  final String? shortName;
  const IsinData({
    required this.id,
    this.isinCode,
    this.altName,
    required this.registeredNames,
    this.shortName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || isinCode != null) {
      map['isin_code'] = Variable<String>(isinCode);
    }
    if (!nullToAbsent || altName != null) {
      map['alt_name'] = Variable<String>(altName);
    }
    {
      map['registered_names'] = Variable<String>(
        $IsinsTable.$converterregisteredNames.toSql(registeredNames),
      );
    }
    if (!nullToAbsent || shortName != null) {
      map['short_name'] = Variable<String>(shortName);
    }
    return map;
  }

  IsinsCompanion toCompanion(bool nullToAbsent) {
    return IsinsCompanion(
      id: Value(id),
      isinCode: isinCode == null && nullToAbsent
          ? const Value.absent()
          : Value(isinCode),
      altName: altName == null && nullToAbsent
          ? const Value.absent()
          : Value(altName),
      registeredNames: Value(registeredNames),
      shortName: shortName == null && nullToAbsent
          ? const Value.absent()
          : Value(shortName),
    );
  }

  factory IsinData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IsinData(
      id: serializer.fromJson<int>(json['id']),
      isinCode: serializer.fromJson<String?>(json['isinCode']),
      altName: serializer.fromJson<String?>(json['altName']),
      registeredNames: serializer.fromJson<List<String>>(
        json['registeredNames'],
      ),
      shortName: serializer.fromJson<String?>(json['shortName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isinCode': serializer.toJson<String?>(isinCode),
      'altName': serializer.toJson<String?>(altName),
      'registeredNames': serializer.toJson<List<String>>(registeredNames),
      'shortName': serializer.toJson<String?>(shortName),
    };
  }

  IsinData copyWith({
    int? id,
    Value<String?> isinCode = const Value.absent(),
    Value<String?> altName = const Value.absent(),
    List<String>? registeredNames,
    Value<String?> shortName = const Value.absent(),
  }) => IsinData(
    id: id ?? this.id,
    isinCode: isinCode.present ? isinCode.value : this.isinCode,
    altName: altName.present ? altName.value : this.altName,
    registeredNames: registeredNames ?? this.registeredNames,
    shortName: shortName.present ? shortName.value : this.shortName,
  );
  IsinData copyWithCompanion(IsinsCompanion data) {
    return IsinData(
      id: data.id.present ? data.id.value : this.id,
      isinCode: data.isinCode.present ? data.isinCode.value : this.isinCode,
      altName: data.altName.present ? data.altName.value : this.altName,
      registeredNames: data.registeredNames.present
          ? data.registeredNames.value
          : this.registeredNames,
      shortName: data.shortName.present ? data.shortName.value : this.shortName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IsinData(')
          ..write('id: $id, ')
          ..write('isinCode: $isinCode, ')
          ..write('altName: $altName, ')
          ..write('registeredNames: $registeredNames, ')
          ..write('shortName: $shortName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, isinCode, altName, registeredNames, shortName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IsinData &&
          other.id == this.id &&
          other.isinCode == this.isinCode &&
          other.altName == this.altName &&
          other.registeredNames == this.registeredNames &&
          other.shortName == this.shortName);
}

class IsinsCompanion extends UpdateCompanion<IsinData> {
  final Value<int> id;
  final Value<String?> isinCode;
  final Value<String?> altName;
  final Value<List<String>> registeredNames;
  final Value<String?> shortName;
  const IsinsCompanion({
    this.id = const Value.absent(),
    this.isinCode = const Value.absent(),
    this.altName = const Value.absent(),
    this.registeredNames = const Value.absent(),
    this.shortName = const Value.absent(),
  });
  IsinsCompanion.insert({
    this.id = const Value.absent(),
    this.isinCode = const Value.absent(),
    this.altName = const Value.absent(),
    this.registeredNames = const Value.absent(),
    this.shortName = const Value.absent(),
  });
  static Insertable<IsinData> custom({
    Expression<int>? id,
    Expression<String>? isinCode,
    Expression<String>? altName,
    Expression<String>? registeredNames,
    Expression<String>? shortName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isinCode != null) 'isin_code': isinCode,
      if (altName != null) 'alt_name': altName,
      if (registeredNames != null) 'registered_names': registeredNames,
      if (shortName != null) 'short_name': shortName,
    });
  }

  IsinsCompanion copyWith({
    Value<int>? id,
    Value<String?>? isinCode,
    Value<String?>? altName,
    Value<List<String>>? registeredNames,
    Value<String?>? shortName,
  }) {
    return IsinsCompanion(
      id: id ?? this.id,
      isinCode: isinCode ?? this.isinCode,
      altName: altName ?? this.altName,
      registeredNames: registeredNames ?? this.registeredNames,
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
    if (altName.present) {
      map['alt_name'] = Variable<String>(altName.value);
    }
    if (registeredNames.present) {
      map['registered_names'] = Variable<String>(
        $IsinsTable.$converterregisteredNames.toSql(registeredNames.value),
      );
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
          ..write('altName: $altName, ')
          ..write('registeredNames: $registeredNames, ')
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
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _exchangeMeta = const VerificationMeta(
    'exchange',
  );
  @override
  late final GeneratedColumn<String> exchange = GeneratedColumn<String>(
    'exchange',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quoteTypeMeta = const VerificationMeta(
    'quoteType',
  );
  @override
  late final GeneratedColumn<String> quoteType = GeneratedColumn<String>(
    'quote_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regularMarketStartMeta =
      const VerificationMeta('regularMarketStart');
  @override
  late final GeneratedColumn<int> regularMarketStart = GeneratedColumn<int>(
    'regular_market_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regularMarketEndMeta = const VerificationMeta(
    'regularMarketEnd',
  );
  @override
  late final GeneratedColumn<int> regularMarketEnd = GeneratedColumn<int>(
    'regular_market_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preMarketStartMeta = const VerificationMeta(
    'preMarketStart',
  );
  @override
  late final GeneratedColumn<int> preMarketStart = GeneratedColumn<int>(
    'pre_market_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preMarketEndMeta = const VerificationMeta(
    'preMarketEnd',
  );
  @override
  late final GeneratedColumn<int> preMarketEnd = GeneratedColumn<int>(
    'pre_market_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postMarketStartMeta = const VerificationMeta(
    'postMarketStart',
  );
  @override
  late final GeneratedColumn<int> postMarketStart = GeneratedColumn<int>(
    'post_market_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postMarketEndMeta = const VerificationMeta(
    'postMarketEnd',
  );
  @override
  late final GeneratedColumn<int> postMarketEnd = GeneratedColumn<int>(
    'post_market_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isinIdMeta = const VerificationMeta('isinId');
  @override
  late final GeneratedColumn<int> isinId = GeneratedColumn<int>(
    'isin_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES isins (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    symbol,
    exchange,
    currency,
    quoteType,
    regularMarketStart,
    regularMarketEnd,
    preMarketStart,
    preMarketEnd,
    postMarketStart,
    postMarketEnd,
    isinId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tickers';
  @override
  VerificationContext validateIntegrity(
    Insertable<TickerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('exchange')) {
      context.handle(
        _exchangeMeta,
        exchange.isAcceptableOrUnknown(data['exchange']!, _exchangeMeta),
      );
    } else if (isInserting) {
      context.missing(_exchangeMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('quote_type')) {
      context.handle(
        _quoteTypeMeta,
        quoteType.isAcceptableOrUnknown(data['quote_type']!, _quoteTypeMeta),
      );
    }
    if (data.containsKey('regular_market_start')) {
      context.handle(
        _regularMarketStartMeta,
        regularMarketStart.isAcceptableOrUnknown(
          data['regular_market_start']!,
          _regularMarketStartMeta,
        ),
      );
    }
    if (data.containsKey('regular_market_end')) {
      context.handle(
        _regularMarketEndMeta,
        regularMarketEnd.isAcceptableOrUnknown(
          data['regular_market_end']!,
          _regularMarketEndMeta,
        ),
      );
    }
    if (data.containsKey('pre_market_start')) {
      context.handle(
        _preMarketStartMeta,
        preMarketStart.isAcceptableOrUnknown(
          data['pre_market_start']!,
          _preMarketStartMeta,
        ),
      );
    }
    if (data.containsKey('pre_market_end')) {
      context.handle(
        _preMarketEndMeta,
        preMarketEnd.isAcceptableOrUnknown(
          data['pre_market_end']!,
          _preMarketEndMeta,
        ),
      );
    }
    if (data.containsKey('post_market_start')) {
      context.handle(
        _postMarketStartMeta,
        postMarketStart.isAcceptableOrUnknown(
          data['post_market_start']!,
          _postMarketStartMeta,
        ),
      );
    }
    if (data.containsKey('post_market_end')) {
      context.handle(
        _postMarketEndMeta,
        postMarketEnd.isAcceptableOrUnknown(
          data['post_market_end']!,
          _postMarketEndMeta,
        ),
      );
    }
    if (data.containsKey('isin_id')) {
      context.handle(
        _isinIdMeta,
        isinId.isAcceptableOrUnknown(data['isin_id']!, _isinIdMeta),
      );
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
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      exchange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exchange'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      quoteType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_type'],
      ),
      regularMarketStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}regular_market_start'],
      ),
      regularMarketEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}regular_market_end'],
      ),
      preMarketStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pre_market_start'],
      ),
      preMarketEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pre_market_end'],
      ),
      postMarketStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}post_market_start'],
      ),
      postMarketEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}post_market_end'],
      ),
      isinId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isin_id'],
      )!,
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
  final String? currency;
  final String? quoteType;
  final int? regularMarketStart;
  final int? regularMarketEnd;
  final int? preMarketStart;
  final int? preMarketEnd;
  final int? postMarketStart;
  final int? postMarketEnd;
  final int isinId;
  const TickerData({
    required this.id,
    required this.symbol,
    required this.exchange,
    this.currency,
    this.quoteType,
    this.regularMarketStart,
    this.regularMarketEnd,
    this.preMarketStart,
    this.preMarketEnd,
    this.postMarketStart,
    this.postMarketEnd,
    required this.isinId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['exchange'] = Variable<String>(exchange);
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || quoteType != null) {
      map['quote_type'] = Variable<String>(quoteType);
    }
    if (!nullToAbsent || regularMarketStart != null) {
      map['regular_market_start'] = Variable<int>(regularMarketStart);
    }
    if (!nullToAbsent || regularMarketEnd != null) {
      map['regular_market_end'] = Variable<int>(regularMarketEnd);
    }
    if (!nullToAbsent || preMarketStart != null) {
      map['pre_market_start'] = Variable<int>(preMarketStart);
    }
    if (!nullToAbsent || preMarketEnd != null) {
      map['pre_market_end'] = Variable<int>(preMarketEnd);
    }
    if (!nullToAbsent || postMarketStart != null) {
      map['post_market_start'] = Variable<int>(postMarketStart);
    }
    if (!nullToAbsent || postMarketEnd != null) {
      map['post_market_end'] = Variable<int>(postMarketEnd);
    }
    map['isin_id'] = Variable<int>(isinId);
    return map;
  }

  TickersCompanion toCompanion(bool nullToAbsent) {
    return TickersCompanion(
      id: Value(id),
      symbol: Value(symbol),
      exchange: Value(exchange),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      quoteType: quoteType == null && nullToAbsent
          ? const Value.absent()
          : Value(quoteType),
      regularMarketStart: regularMarketStart == null && nullToAbsent
          ? const Value.absent()
          : Value(regularMarketStart),
      regularMarketEnd: regularMarketEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(regularMarketEnd),
      preMarketStart: preMarketStart == null && nullToAbsent
          ? const Value.absent()
          : Value(preMarketStart),
      preMarketEnd: preMarketEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(preMarketEnd),
      postMarketStart: postMarketStart == null && nullToAbsent
          ? const Value.absent()
          : Value(postMarketStart),
      postMarketEnd: postMarketEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(postMarketEnd),
      isinId: Value(isinId),
    );
  }

  factory TickerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TickerData(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      exchange: serializer.fromJson<String>(json['exchange']),
      currency: serializer.fromJson<String?>(json['currency']),
      quoteType: serializer.fromJson<String?>(json['quoteType']),
      regularMarketStart: serializer.fromJson<int?>(json['regularMarketStart']),
      regularMarketEnd: serializer.fromJson<int?>(json['regularMarketEnd']),
      preMarketStart: serializer.fromJson<int?>(json['preMarketStart']),
      preMarketEnd: serializer.fromJson<int?>(json['preMarketEnd']),
      postMarketStart: serializer.fromJson<int?>(json['postMarketStart']),
      postMarketEnd: serializer.fromJson<int?>(json['postMarketEnd']),
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
      'currency': serializer.toJson<String?>(currency),
      'quoteType': serializer.toJson<String?>(quoteType),
      'regularMarketStart': serializer.toJson<int?>(regularMarketStart),
      'regularMarketEnd': serializer.toJson<int?>(regularMarketEnd),
      'preMarketStart': serializer.toJson<int?>(preMarketStart),
      'preMarketEnd': serializer.toJson<int?>(preMarketEnd),
      'postMarketStart': serializer.toJson<int?>(postMarketStart),
      'postMarketEnd': serializer.toJson<int?>(postMarketEnd),
      'isinId': serializer.toJson<int>(isinId),
    };
  }

  TickerData copyWith({
    int? id,
    String? symbol,
    String? exchange,
    Value<String?> currency = const Value.absent(),
    Value<String?> quoteType = const Value.absent(),
    Value<int?> regularMarketStart = const Value.absent(),
    Value<int?> regularMarketEnd = const Value.absent(),
    Value<int?> preMarketStart = const Value.absent(),
    Value<int?> preMarketEnd = const Value.absent(),
    Value<int?> postMarketStart = const Value.absent(),
    Value<int?> postMarketEnd = const Value.absent(),
    int? isinId,
  }) => TickerData(
    id: id ?? this.id,
    symbol: symbol ?? this.symbol,
    exchange: exchange ?? this.exchange,
    currency: currency.present ? currency.value : this.currency,
    quoteType: quoteType.present ? quoteType.value : this.quoteType,
    regularMarketStart: regularMarketStart.present
        ? regularMarketStart.value
        : this.regularMarketStart,
    regularMarketEnd: regularMarketEnd.present
        ? regularMarketEnd.value
        : this.regularMarketEnd,
    preMarketStart: preMarketStart.present
        ? preMarketStart.value
        : this.preMarketStart,
    preMarketEnd: preMarketEnd.present ? preMarketEnd.value : this.preMarketEnd,
    postMarketStart: postMarketStart.present
        ? postMarketStart.value
        : this.postMarketStart,
    postMarketEnd: postMarketEnd.present
        ? postMarketEnd.value
        : this.postMarketEnd,
    isinId: isinId ?? this.isinId,
  );
  TickerData copyWithCompanion(TickersCompanion data) {
    return TickerData(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      exchange: data.exchange.present ? data.exchange.value : this.exchange,
      currency: data.currency.present ? data.currency.value : this.currency,
      quoteType: data.quoteType.present ? data.quoteType.value : this.quoteType,
      regularMarketStart: data.regularMarketStart.present
          ? data.regularMarketStart.value
          : this.regularMarketStart,
      regularMarketEnd: data.regularMarketEnd.present
          ? data.regularMarketEnd.value
          : this.regularMarketEnd,
      preMarketStart: data.preMarketStart.present
          ? data.preMarketStart.value
          : this.preMarketStart,
      preMarketEnd: data.preMarketEnd.present
          ? data.preMarketEnd.value
          : this.preMarketEnd,
      postMarketStart: data.postMarketStart.present
          ? data.postMarketStart.value
          : this.postMarketStart,
      postMarketEnd: data.postMarketEnd.present
          ? data.postMarketEnd.value
          : this.postMarketEnd,
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
          ..write('quoteType: $quoteType, ')
          ..write('regularMarketStart: $regularMarketStart, ')
          ..write('regularMarketEnd: $regularMarketEnd, ')
          ..write('preMarketStart: $preMarketStart, ')
          ..write('preMarketEnd: $preMarketEnd, ')
          ..write('postMarketStart: $postMarketStart, ')
          ..write('postMarketEnd: $postMarketEnd, ')
          ..write('isinId: $isinId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    symbol,
    exchange,
    currency,
    quoteType,
    regularMarketStart,
    regularMarketEnd,
    preMarketStart,
    preMarketEnd,
    postMarketStart,
    postMarketEnd,
    isinId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TickerData &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.exchange == this.exchange &&
          other.currency == this.currency &&
          other.quoteType == this.quoteType &&
          other.regularMarketStart == this.regularMarketStart &&
          other.regularMarketEnd == this.regularMarketEnd &&
          other.preMarketStart == this.preMarketStart &&
          other.preMarketEnd == this.preMarketEnd &&
          other.postMarketStart == this.postMarketStart &&
          other.postMarketEnd == this.postMarketEnd &&
          other.isinId == this.isinId);
}

class TickersCompanion extends UpdateCompanion<TickerData> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<String> exchange;
  final Value<String?> currency;
  final Value<String?> quoteType;
  final Value<int?> regularMarketStart;
  final Value<int?> regularMarketEnd;
  final Value<int?> preMarketStart;
  final Value<int?> preMarketEnd;
  final Value<int?> postMarketStart;
  final Value<int?> postMarketEnd;
  final Value<int> isinId;
  const TickersCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.exchange = const Value.absent(),
    this.currency = const Value.absent(),
    this.quoteType = const Value.absent(),
    this.regularMarketStart = const Value.absent(),
    this.regularMarketEnd = const Value.absent(),
    this.preMarketStart = const Value.absent(),
    this.preMarketEnd = const Value.absent(),
    this.postMarketStart = const Value.absent(),
    this.postMarketEnd = const Value.absent(),
    this.isinId = const Value.absent(),
  });
  TickersCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required String exchange,
    this.currency = const Value.absent(),
    this.quoteType = const Value.absent(),
    this.regularMarketStart = const Value.absent(),
    this.regularMarketEnd = const Value.absent(),
    this.preMarketStart = const Value.absent(),
    this.preMarketEnd = const Value.absent(),
    this.postMarketStart = const Value.absent(),
    this.postMarketEnd = const Value.absent(),
    required int isinId,
  }) : symbol = Value(symbol),
       exchange = Value(exchange),
       isinId = Value(isinId);
  static Insertable<TickerData> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<String>? exchange,
    Expression<String>? currency,
    Expression<String>? quoteType,
    Expression<int>? regularMarketStart,
    Expression<int>? regularMarketEnd,
    Expression<int>? preMarketStart,
    Expression<int>? preMarketEnd,
    Expression<int>? postMarketStart,
    Expression<int>? postMarketEnd,
    Expression<int>? isinId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (exchange != null) 'exchange': exchange,
      if (currency != null) 'currency': currency,
      if (quoteType != null) 'quote_type': quoteType,
      if (regularMarketStart != null)
        'regular_market_start': regularMarketStart,
      if (regularMarketEnd != null) 'regular_market_end': regularMarketEnd,
      if (preMarketStart != null) 'pre_market_start': preMarketStart,
      if (preMarketEnd != null) 'pre_market_end': preMarketEnd,
      if (postMarketStart != null) 'post_market_start': postMarketStart,
      if (postMarketEnd != null) 'post_market_end': postMarketEnd,
      if (isinId != null) 'isin_id': isinId,
    });
  }

  TickersCompanion copyWith({
    Value<int>? id,
    Value<String>? symbol,
    Value<String>? exchange,
    Value<String?>? currency,
    Value<String?>? quoteType,
    Value<int?>? regularMarketStart,
    Value<int?>? regularMarketEnd,
    Value<int?>? preMarketStart,
    Value<int?>? preMarketEnd,
    Value<int?>? postMarketStart,
    Value<int?>? postMarketEnd,
    Value<int>? isinId,
  }) {
    return TickersCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      exchange: exchange ?? this.exchange,
      currency: currency ?? this.currency,
      quoteType: quoteType ?? this.quoteType,
      regularMarketStart: regularMarketStart ?? this.regularMarketStart,
      regularMarketEnd: regularMarketEnd ?? this.regularMarketEnd,
      preMarketStart: preMarketStart ?? this.preMarketStart,
      preMarketEnd: preMarketEnd ?? this.preMarketEnd,
      postMarketStart: postMarketStart ?? this.postMarketStart,
      postMarketEnd: postMarketEnd ?? this.postMarketEnd,
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
    if (quoteType.present) {
      map['quote_type'] = Variable<String>(quoteType.value);
    }
    if (regularMarketStart.present) {
      map['regular_market_start'] = Variable<int>(regularMarketStart.value);
    }
    if (regularMarketEnd.present) {
      map['regular_market_end'] = Variable<int>(regularMarketEnd.value);
    }
    if (preMarketStart.present) {
      map['pre_market_start'] = Variable<int>(preMarketStart.value);
    }
    if (preMarketEnd.present) {
      map['pre_market_end'] = Variable<int>(preMarketEnd.value);
    }
    if (postMarketStart.present) {
      map['post_market_start'] = Variable<int>(postMarketStart.value);
    }
    if (postMarketEnd.present) {
      map['post_market_end'] = Variable<int>(postMarketEnd.value);
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
          ..write('quoteType: $quoteType, ')
          ..write('regularMarketStart: $regularMarketStart, ')
          ..write('regularMarketEnd: $regularMarketEnd, ')
          ..write('preMarketStart: $preMarketStart, ')
          ..write('preMarketEnd: $preMarketEnd, ')
          ..write('postMarketStart: $postMarketStart, ')
          ..write('postMarketEnd: $postMarketEnd, ')
          ..write('isinId: $isinId')
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
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regularMarketPriceMeta =
      const VerificationMeta('regularMarketPrice');
  @override
  late final GeneratedColumn<double> regularMarketPrice =
      GeneratedColumn<double>(
        'regular_market_price',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _chartPreviousCloseMeta =
      const VerificationMeta('chartPreviousClose');
  @override
  late final GeneratedColumn<double> chartPreviousClose =
      GeneratedColumn<double>(
        'chart_previous_close',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<double>, String>
  intradayPrices =
      GeneratedColumn<String>(
        'intraday_prices',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<double>>(
        $MarketDataCachesTable.$converterintradayPrices,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String>
  intradayTimestamps =
      GeneratedColumn<String>(
        'intraday_timestamps',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<int>>(
        $MarketDataCachesTable.$converterintradayTimestamps,
      );
  static const VerificationMeta _regularMarketStartMeta =
      const VerificationMeta('regularMarketStart');
  @override
  late final GeneratedColumn<int> regularMarketStart = GeneratedColumn<int>(
    'regular_market_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regularMarketEndMeta = const VerificationMeta(
    'regularMarketEnd',
  );
  @override
  late final GeneratedColumn<int> regularMarketEnd = GeneratedColumn<int>(
    'regular_market_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preMarketStartMeta = const VerificationMeta(
    'preMarketStart',
  );
  @override
  late final GeneratedColumn<int> preMarketStart = GeneratedColumn<int>(
    'pre_market_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preMarketEndMeta = const VerificationMeta(
    'preMarketEnd',
  );
  @override
  late final GeneratedColumn<int> preMarketEnd = GeneratedColumn<int>(
    'pre_market_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postMarketStartMeta = const VerificationMeta(
    'postMarketStart',
  );
  @override
  late final GeneratedColumn<int> postMarketStart = GeneratedColumn<int>(
    'post_market_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postMarketEndMeta = const VerificationMeta(
    'postMarketEnd',
  );
  @override
  late final GeneratedColumn<int> postMarketEnd = GeneratedColumn<int>(
    'post_market_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tickerIdMeta = const VerificationMeta(
    'tickerId',
  );
  @override
  late final GeneratedColumn<int> tickerId = GeneratedColumn<int>(
    'ticker_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tickers (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    symbol,
    lastUpdated,
    regularMarketPrice,
    chartPreviousClose,
    intradayPrices,
    intradayTimestamps,
    regularMarketStart,
    regularMarketEnd,
    preMarketStart,
    preMarketEnd,
    postMarketStart,
    postMarketEnd,
    tickerId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'market_data_caches';
  @override
  VerificationContext validateIntegrity(
    Insertable<MarketDataCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('regular_market_price')) {
      context.handle(
        _regularMarketPriceMeta,
        regularMarketPrice.isAcceptableOrUnknown(
          data['regular_market_price']!,
          _regularMarketPriceMeta,
        ),
      );
    }
    if (data.containsKey('chart_previous_close')) {
      context.handle(
        _chartPreviousCloseMeta,
        chartPreviousClose.isAcceptableOrUnknown(
          data['chart_previous_close']!,
          _chartPreviousCloseMeta,
        ),
      );
    }
    if (data.containsKey('regular_market_start')) {
      context.handle(
        _regularMarketStartMeta,
        regularMarketStart.isAcceptableOrUnknown(
          data['regular_market_start']!,
          _regularMarketStartMeta,
        ),
      );
    }
    if (data.containsKey('regular_market_end')) {
      context.handle(
        _regularMarketEndMeta,
        regularMarketEnd.isAcceptableOrUnknown(
          data['regular_market_end']!,
          _regularMarketEndMeta,
        ),
      );
    }
    if (data.containsKey('pre_market_start')) {
      context.handle(
        _preMarketStartMeta,
        preMarketStart.isAcceptableOrUnknown(
          data['pre_market_start']!,
          _preMarketStartMeta,
        ),
      );
    }
    if (data.containsKey('pre_market_end')) {
      context.handle(
        _preMarketEndMeta,
        preMarketEnd.isAcceptableOrUnknown(
          data['pre_market_end']!,
          _preMarketEndMeta,
        ),
      );
    }
    if (data.containsKey('post_market_start')) {
      context.handle(
        _postMarketStartMeta,
        postMarketStart.isAcceptableOrUnknown(
          data['post_market_start']!,
          _postMarketStartMeta,
        ),
      );
    }
    if (data.containsKey('post_market_end')) {
      context.handle(
        _postMarketEndMeta,
        postMarketEnd.isAcceptableOrUnknown(
          data['post_market_end']!,
          _postMarketEndMeta,
        ),
      );
    }
    if (data.containsKey('ticker_id')) {
      context.handle(
        _tickerIdMeta,
        tickerId.isAcceptableOrUnknown(data['ticker_id']!, _tickerIdMeta),
      );
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
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
      regularMarketPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}regular_market_price'],
      )!,
      chartPreviousClose: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chart_previous_close'],
      )!,
      intradayPrices: $MarketDataCachesTable.$converterintradayPrices.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}intraday_prices'],
        )!,
      ),
      intradayTimestamps: $MarketDataCachesTable.$converterintradayTimestamps
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}intraday_timestamps'],
            )!,
          ),
      regularMarketStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}regular_market_start'],
      ),
      regularMarketEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}regular_market_end'],
      ),
      preMarketStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pre_market_start'],
      ),
      preMarketEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pre_market_end'],
      ),
      postMarketStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}post_market_start'],
      ),
      postMarketEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}post_market_end'],
      ),
      tickerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ticker_id'],
      )!,
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
  final int? regularMarketStart;
  final int? regularMarketEnd;
  final int? preMarketStart;
  final int? preMarketEnd;
  final int? postMarketStart;
  final int? postMarketEnd;
  final int tickerId;
  const MarketDataCacheData({
    required this.id,
    required this.symbol,
    required this.lastUpdated,
    required this.regularMarketPrice,
    required this.chartPreviousClose,
    required this.intradayPrices,
    required this.intradayTimestamps,
    this.regularMarketStart,
    this.regularMarketEnd,
    this.preMarketStart,
    this.preMarketEnd,
    this.postMarketStart,
    this.postMarketEnd,
    required this.tickerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['regular_market_price'] = Variable<double>(regularMarketPrice);
    map['chart_previous_close'] = Variable<double>(chartPreviousClose);
    {
      map['intraday_prices'] = Variable<String>(
        $MarketDataCachesTable.$converterintradayPrices.toSql(intradayPrices),
      );
    }
    {
      map['intraday_timestamps'] = Variable<String>(
        $MarketDataCachesTable.$converterintradayTimestamps.toSql(
          intradayTimestamps,
        ),
      );
    }
    if (!nullToAbsent || regularMarketStart != null) {
      map['regular_market_start'] = Variable<int>(regularMarketStart);
    }
    if (!nullToAbsent || regularMarketEnd != null) {
      map['regular_market_end'] = Variable<int>(regularMarketEnd);
    }
    if (!nullToAbsent || preMarketStart != null) {
      map['pre_market_start'] = Variable<int>(preMarketStart);
    }
    if (!nullToAbsent || preMarketEnd != null) {
      map['pre_market_end'] = Variable<int>(preMarketEnd);
    }
    if (!nullToAbsent || postMarketStart != null) {
      map['post_market_start'] = Variable<int>(postMarketStart);
    }
    if (!nullToAbsent || postMarketEnd != null) {
      map['post_market_end'] = Variable<int>(postMarketEnd);
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
      regularMarketStart: regularMarketStart == null && nullToAbsent
          ? const Value.absent()
          : Value(regularMarketStart),
      regularMarketEnd: regularMarketEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(regularMarketEnd),
      preMarketStart: preMarketStart == null && nullToAbsent
          ? const Value.absent()
          : Value(preMarketStart),
      preMarketEnd: preMarketEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(preMarketEnd),
      postMarketStart: postMarketStart == null && nullToAbsent
          ? const Value.absent()
          : Value(postMarketStart),
      postMarketEnd: postMarketEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(postMarketEnd),
      tickerId: Value(tickerId),
    );
  }

  factory MarketDataCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarketDataCacheData(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      regularMarketPrice: serializer.fromJson<double>(
        json['regularMarketPrice'],
      ),
      chartPreviousClose: serializer.fromJson<double>(
        json['chartPreviousClose'],
      ),
      intradayPrices: serializer.fromJson<List<double>>(json['intradayPrices']),
      intradayTimestamps: serializer.fromJson<List<int>>(
        json['intradayTimestamps'],
      ),
      regularMarketStart: serializer.fromJson<int?>(json['regularMarketStart']),
      regularMarketEnd: serializer.fromJson<int?>(json['regularMarketEnd']),
      preMarketStart: serializer.fromJson<int?>(json['preMarketStart']),
      preMarketEnd: serializer.fromJson<int?>(json['preMarketEnd']),
      postMarketStart: serializer.fromJson<int?>(json['postMarketStart']),
      postMarketEnd: serializer.fromJson<int?>(json['postMarketEnd']),
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
      'regularMarketStart': serializer.toJson<int?>(regularMarketStart),
      'regularMarketEnd': serializer.toJson<int?>(regularMarketEnd),
      'preMarketStart': serializer.toJson<int?>(preMarketStart),
      'preMarketEnd': serializer.toJson<int?>(preMarketEnd),
      'postMarketStart': serializer.toJson<int?>(postMarketStart),
      'postMarketEnd': serializer.toJson<int?>(postMarketEnd),
      'tickerId': serializer.toJson<int>(tickerId),
    };
  }

  MarketDataCacheData copyWith({
    int? id,
    String? symbol,
    DateTime? lastUpdated,
    double? regularMarketPrice,
    double? chartPreviousClose,
    List<double>? intradayPrices,
    List<int>? intradayTimestamps,
    Value<int?> regularMarketStart = const Value.absent(),
    Value<int?> regularMarketEnd = const Value.absent(),
    Value<int?> preMarketStart = const Value.absent(),
    Value<int?> preMarketEnd = const Value.absent(),
    Value<int?> postMarketStart = const Value.absent(),
    Value<int?> postMarketEnd = const Value.absent(),
    int? tickerId,
  }) => MarketDataCacheData(
    id: id ?? this.id,
    symbol: symbol ?? this.symbol,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    regularMarketPrice: regularMarketPrice ?? this.regularMarketPrice,
    chartPreviousClose: chartPreviousClose ?? this.chartPreviousClose,
    intradayPrices: intradayPrices ?? this.intradayPrices,
    intradayTimestamps: intradayTimestamps ?? this.intradayTimestamps,
    regularMarketStart: regularMarketStart.present
        ? regularMarketStart.value
        : this.regularMarketStart,
    regularMarketEnd: regularMarketEnd.present
        ? regularMarketEnd.value
        : this.regularMarketEnd,
    preMarketStart: preMarketStart.present
        ? preMarketStart.value
        : this.preMarketStart,
    preMarketEnd: preMarketEnd.present ? preMarketEnd.value : this.preMarketEnd,
    postMarketStart: postMarketStart.present
        ? postMarketStart.value
        : this.postMarketStart,
    postMarketEnd: postMarketEnd.present
        ? postMarketEnd.value
        : this.postMarketEnd,
    tickerId: tickerId ?? this.tickerId,
  );
  MarketDataCacheData copyWithCompanion(MarketDataCachesCompanion data) {
    return MarketDataCacheData(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
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
      regularMarketStart: data.regularMarketStart.present
          ? data.regularMarketStart.value
          : this.regularMarketStart,
      regularMarketEnd: data.regularMarketEnd.present
          ? data.regularMarketEnd.value
          : this.regularMarketEnd,
      preMarketStart: data.preMarketStart.present
          ? data.preMarketStart.value
          : this.preMarketStart,
      preMarketEnd: data.preMarketEnd.present
          ? data.preMarketEnd.value
          : this.preMarketEnd,
      postMarketStart: data.postMarketStart.present
          ? data.postMarketStart.value
          : this.postMarketStart,
      postMarketEnd: data.postMarketEnd.present
          ? data.postMarketEnd.value
          : this.postMarketEnd,
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
          ..write('regularMarketStart: $regularMarketStart, ')
          ..write('regularMarketEnd: $regularMarketEnd, ')
          ..write('preMarketStart: $preMarketStart, ')
          ..write('preMarketEnd: $preMarketEnd, ')
          ..write('postMarketStart: $postMarketStart, ')
          ..write('postMarketEnd: $postMarketEnd, ')
          ..write('tickerId: $tickerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    symbol,
    lastUpdated,
    regularMarketPrice,
    chartPreviousClose,
    intradayPrices,
    intradayTimestamps,
    regularMarketStart,
    regularMarketEnd,
    preMarketStart,
    preMarketEnd,
    postMarketStart,
    postMarketEnd,
    tickerId,
  );
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
          other.regularMarketStart == this.regularMarketStart &&
          other.regularMarketEnd == this.regularMarketEnd &&
          other.preMarketStart == this.preMarketStart &&
          other.preMarketEnd == this.preMarketEnd &&
          other.postMarketStart == this.postMarketStart &&
          other.postMarketEnd == this.postMarketEnd &&
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
  final Value<int?> regularMarketStart;
  final Value<int?> regularMarketEnd;
  final Value<int?> preMarketStart;
  final Value<int?> preMarketEnd;
  final Value<int?> postMarketStart;
  final Value<int?> postMarketEnd;
  final Value<int> tickerId;
  const MarketDataCachesCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.regularMarketPrice = const Value.absent(),
    this.chartPreviousClose = const Value.absent(),
    this.intradayPrices = const Value.absent(),
    this.intradayTimestamps = const Value.absent(),
    this.regularMarketStart = const Value.absent(),
    this.regularMarketEnd = const Value.absent(),
    this.preMarketStart = const Value.absent(),
    this.preMarketEnd = const Value.absent(),
    this.postMarketStart = const Value.absent(),
    this.postMarketEnd = const Value.absent(),
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
    this.regularMarketStart = const Value.absent(),
    this.regularMarketEnd = const Value.absent(),
    this.preMarketStart = const Value.absent(),
    this.preMarketEnd = const Value.absent(),
    this.postMarketStart = const Value.absent(),
    this.postMarketEnd = const Value.absent(),
    required int tickerId,
  }) : symbol = Value(symbol),
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
    Expression<int>? regularMarketStart,
    Expression<int>? regularMarketEnd,
    Expression<int>? preMarketStart,
    Expression<int>? preMarketEnd,
    Expression<int>? postMarketStart,
    Expression<int>? postMarketEnd,
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
      if (regularMarketStart != null)
        'regular_market_start': regularMarketStart,
      if (regularMarketEnd != null) 'regular_market_end': regularMarketEnd,
      if (preMarketStart != null) 'pre_market_start': preMarketStart,
      if (preMarketEnd != null) 'pre_market_end': preMarketEnd,
      if (postMarketStart != null) 'post_market_start': postMarketStart,
      if (postMarketEnd != null) 'post_market_end': postMarketEnd,
      if (tickerId != null) 'ticker_id': tickerId,
    });
  }

  MarketDataCachesCompanion copyWith({
    Value<int>? id,
    Value<String>? symbol,
    Value<DateTime>? lastUpdated,
    Value<double>? regularMarketPrice,
    Value<double>? chartPreviousClose,
    Value<List<double>>? intradayPrices,
    Value<List<int>>? intradayTimestamps,
    Value<int?>? regularMarketStart,
    Value<int?>? regularMarketEnd,
    Value<int?>? preMarketStart,
    Value<int?>? preMarketEnd,
    Value<int?>? postMarketStart,
    Value<int?>? postMarketEnd,
    Value<int>? tickerId,
  }) {
    return MarketDataCachesCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      regularMarketPrice: regularMarketPrice ?? this.regularMarketPrice,
      chartPreviousClose: chartPreviousClose ?? this.chartPreviousClose,
      intradayPrices: intradayPrices ?? this.intradayPrices,
      intradayTimestamps: intradayTimestamps ?? this.intradayTimestamps,
      regularMarketStart: regularMarketStart ?? this.regularMarketStart,
      regularMarketEnd: regularMarketEnd ?? this.regularMarketEnd,
      preMarketStart: preMarketStart ?? this.preMarketStart,
      preMarketEnd: preMarketEnd ?? this.preMarketEnd,
      postMarketStart: postMarketStart ?? this.postMarketStart,
      postMarketEnd: postMarketEnd ?? this.postMarketEnd,
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
      map['intraday_prices'] = Variable<String>(
        $MarketDataCachesTable.$converterintradayPrices.toSql(
          intradayPrices.value,
        ),
      );
    }
    if (intradayTimestamps.present) {
      map['intraday_timestamps'] = Variable<String>(
        $MarketDataCachesTable.$converterintradayTimestamps.toSql(
          intradayTimestamps.value,
        ),
      );
    }
    if (regularMarketStart.present) {
      map['regular_market_start'] = Variable<int>(regularMarketStart.value);
    }
    if (regularMarketEnd.present) {
      map['regular_market_end'] = Variable<int>(regularMarketEnd.value);
    }
    if (preMarketStart.present) {
      map['pre_market_start'] = Variable<int>(preMarketStart.value);
    }
    if (preMarketEnd.present) {
      map['pre_market_end'] = Variable<int>(preMarketEnd.value);
    }
    if (postMarketStart.present) {
      map['post_market_start'] = Variable<int>(postMarketStart.value);
    }
    if (postMarketEnd.present) {
      map['post_market_end'] = Variable<int>(postMarketEnd.value);
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
          ..write('regularMarketStart: $regularMarketStart, ')
          ..write('regularMarketEnd: $regularMarketEnd, ')
          ..write('preMarketStart: $preMarketStart, ')
          ..write('preMarketEnd: $preMarketEnd, ')
          ..write('postMarketStart: $postMarketStart, ')
          ..write('postMarketEnd: $postMarketEnd, ')
          ..write('tickerId: $tickerId')
          ..write(')'))
        .toString();
  }
}

class $FeedNewsTable extends FeedNews
    with TableInfo<$FeedNewsTable, FeedNewsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedNewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _isinIdMeta = const VerificationMeta('isinId');
  @override
  late final GeneratedColumn<int> isinId = GeneratedColumn<int>(
    'isin_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES isins (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
    'link',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pubDateMeta = const VerificationMeta(
    'pubDate',
  );
  @override
  late final GeneratedColumn<DateTime> pubDate = GeneratedColumn<DateTime>(
    'pub_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roundMeta = const VerificationMeta('round');
  @override
  late final GeneratedColumn<int> round = GeneratedColumn<int>(
    'round',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subroundMeta = const VerificationMeta(
    'subround',
  );
  @override
  late final GeneratedColumn<int> subround = GeneratedColumn<int>(
    'subround',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relevanceScoreMeta = const VerificationMeta(
    'relevanceScore',
  );
  @override
  late final GeneratedColumn<int> relevanceScore = GeneratedColumn<int>(
    'relevance_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isinId,
    title,
    link,
    sourceUrl,
    sourceName,
    pubDate,
    round,
    subround,
    relevanceScore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feed_news';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedNewsData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('isin_id')) {
      context.handle(
        _isinIdMeta,
        isinId.isAcceptableOrUnknown(data['isin_id']!, _isinIdMeta),
      );
    } else if (isInserting) {
      context.missing(_isinIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('link')) {
      context.handle(
        _linkMeta,
        link.isAcceptableOrUnknown(data['link']!, _linkMeta),
      );
    } else if (isInserting) {
      context.missing(_linkMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceNameMeta);
    }
    if (data.containsKey('pub_date')) {
      context.handle(
        _pubDateMeta,
        pubDate.isAcceptableOrUnknown(data['pub_date']!, _pubDateMeta),
      );
    } else if (isInserting) {
      context.missing(_pubDateMeta);
    }
    if (data.containsKey('round')) {
      context.handle(
        _roundMeta,
        round.isAcceptableOrUnknown(data['round']!, _roundMeta),
      );
    } else if (isInserting) {
      context.missing(_roundMeta);
    }
    if (data.containsKey('subround')) {
      context.handle(
        _subroundMeta,
        subround.isAcceptableOrUnknown(data['subround']!, _subroundMeta),
      );
    } else if (isInserting) {
      context.missing(_subroundMeta);
    }
    if (data.containsKey('relevance_score')) {
      context.handle(
        _relevanceScoreMeta,
        relevanceScore.isAcceptableOrUnknown(
          data['relevance_score']!,
          _relevanceScoreMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedNewsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedNewsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      isinId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isin_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      link: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      sourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_name'],
      )!,
      pubDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pub_date'],
      )!,
      round: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round'],
      )!,
      subround: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subround'],
      )!,
      relevanceScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}relevance_score'],
      ),
    );
  }

  @override
  $FeedNewsTable createAlias(String alias) {
    return $FeedNewsTable(attachedDatabase, alias);
  }
}

class FeedNewsData extends DataClass implements Insertable<FeedNewsData> {
  final int id;
  final int isinId;
  final String title;
  final String link;
  final String sourceUrl;
  final String sourceName;
  final DateTime pubDate;
  final int round;
  final int subround;
  final int? relevanceScore;
  const FeedNewsData({
    required this.id,
    required this.isinId,
    required this.title,
    required this.link,
    required this.sourceUrl,
    required this.sourceName,
    required this.pubDate,
    required this.round,
    required this.subround,
    this.relevanceScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['isin_id'] = Variable<int>(isinId);
    map['title'] = Variable<String>(title);
    map['link'] = Variable<String>(link);
    map['source_url'] = Variable<String>(sourceUrl);
    map['source_name'] = Variable<String>(sourceName);
    map['pub_date'] = Variable<DateTime>(pubDate);
    map['round'] = Variable<int>(round);
    map['subround'] = Variable<int>(subround);
    if (!nullToAbsent || relevanceScore != null) {
      map['relevance_score'] = Variable<int>(relevanceScore);
    }
    return map;
  }

  FeedNewsCompanion toCompanion(bool nullToAbsent) {
    return FeedNewsCompanion(
      id: Value(id),
      isinId: Value(isinId),
      title: Value(title),
      link: Value(link),
      sourceUrl: Value(sourceUrl),
      sourceName: Value(sourceName),
      pubDate: Value(pubDate),
      round: Value(round),
      subround: Value(subround),
      relevanceScore: relevanceScore == null && nullToAbsent
          ? const Value.absent()
          : Value(relevanceScore),
    );
  }

  factory FeedNewsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedNewsData(
      id: serializer.fromJson<int>(json['id']),
      isinId: serializer.fromJson<int>(json['isinId']),
      title: serializer.fromJson<String>(json['title']),
      link: serializer.fromJson<String>(json['link']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      sourceName: serializer.fromJson<String>(json['sourceName']),
      pubDate: serializer.fromJson<DateTime>(json['pubDate']),
      round: serializer.fromJson<int>(json['round']),
      subround: serializer.fromJson<int>(json['subround']),
      relevanceScore: serializer.fromJson<int?>(json['relevanceScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isinId': serializer.toJson<int>(isinId),
      'title': serializer.toJson<String>(title),
      'link': serializer.toJson<String>(link),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'sourceName': serializer.toJson<String>(sourceName),
      'pubDate': serializer.toJson<DateTime>(pubDate),
      'round': serializer.toJson<int>(round),
      'subround': serializer.toJson<int>(subround),
      'relevanceScore': serializer.toJson<int?>(relevanceScore),
    };
  }

  FeedNewsData copyWith({
    int? id,
    int? isinId,
    String? title,
    String? link,
    String? sourceUrl,
    String? sourceName,
    DateTime? pubDate,
    int? round,
    int? subround,
    Value<int?> relevanceScore = const Value.absent(),
  }) => FeedNewsData(
    id: id ?? this.id,
    isinId: isinId ?? this.isinId,
    title: title ?? this.title,
    link: link ?? this.link,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    sourceName: sourceName ?? this.sourceName,
    pubDate: pubDate ?? this.pubDate,
    round: round ?? this.round,
    subround: subround ?? this.subround,
    relevanceScore: relevanceScore.present
        ? relevanceScore.value
        : this.relevanceScore,
  );
  FeedNewsData copyWithCompanion(FeedNewsCompanion data) {
    return FeedNewsData(
      id: data.id.present ? data.id.value : this.id,
      isinId: data.isinId.present ? data.isinId.value : this.isinId,
      title: data.title.present ? data.title.value : this.title,
      link: data.link.present ? data.link.value : this.link,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      sourceName: data.sourceName.present
          ? data.sourceName.value
          : this.sourceName,
      pubDate: data.pubDate.present ? data.pubDate.value : this.pubDate,
      round: data.round.present ? data.round.value : this.round,
      subround: data.subround.present ? data.subround.value : this.subround,
      relevanceScore: data.relevanceScore.present
          ? data.relevanceScore.value
          : this.relevanceScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedNewsData(')
          ..write('id: $id, ')
          ..write('isinId: $isinId, ')
          ..write('title: $title, ')
          ..write('link: $link, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('sourceName: $sourceName, ')
          ..write('pubDate: $pubDate, ')
          ..write('round: $round, ')
          ..write('subround: $subround, ')
          ..write('relevanceScore: $relevanceScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    isinId,
    title,
    link,
    sourceUrl,
    sourceName,
    pubDate,
    round,
    subround,
    relevanceScore,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedNewsData &&
          other.id == this.id &&
          other.isinId == this.isinId &&
          other.title == this.title &&
          other.link == this.link &&
          other.sourceUrl == this.sourceUrl &&
          other.sourceName == this.sourceName &&
          other.pubDate == this.pubDate &&
          other.round == this.round &&
          other.subround == this.subround &&
          other.relevanceScore == this.relevanceScore);
}

class FeedNewsCompanion extends UpdateCompanion<FeedNewsData> {
  final Value<int> id;
  final Value<int> isinId;
  final Value<String> title;
  final Value<String> link;
  final Value<String> sourceUrl;
  final Value<String> sourceName;
  final Value<DateTime> pubDate;
  final Value<int> round;
  final Value<int> subround;
  final Value<int?> relevanceScore;
  const FeedNewsCompanion({
    this.id = const Value.absent(),
    this.isinId = const Value.absent(),
    this.title = const Value.absent(),
    this.link = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.pubDate = const Value.absent(),
    this.round = const Value.absent(),
    this.subround = const Value.absent(),
    this.relevanceScore = const Value.absent(),
  });
  FeedNewsCompanion.insert({
    this.id = const Value.absent(),
    required int isinId,
    required String title,
    required String link,
    required String sourceUrl,
    required String sourceName,
    required DateTime pubDate,
    required int round,
    required int subround,
    this.relevanceScore = const Value.absent(),
  }) : isinId = Value(isinId),
       title = Value(title),
       link = Value(link),
       sourceUrl = Value(sourceUrl),
       sourceName = Value(sourceName),
       pubDate = Value(pubDate),
       round = Value(round),
       subround = Value(subround);
  static Insertable<FeedNewsData> custom({
    Expression<int>? id,
    Expression<int>? isinId,
    Expression<String>? title,
    Expression<String>? link,
    Expression<String>? sourceUrl,
    Expression<String>? sourceName,
    Expression<DateTime>? pubDate,
    Expression<int>? round,
    Expression<int>? subround,
    Expression<int>? relevanceScore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isinId != null) 'isin_id': isinId,
      if (title != null) 'title': title,
      if (link != null) 'link': link,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (sourceName != null) 'source_name': sourceName,
      if (pubDate != null) 'pub_date': pubDate,
      if (round != null) 'round': round,
      if (subround != null) 'subround': subround,
      if (relevanceScore != null) 'relevance_score': relevanceScore,
    });
  }

  FeedNewsCompanion copyWith({
    Value<int>? id,
    Value<int>? isinId,
    Value<String>? title,
    Value<String>? link,
    Value<String>? sourceUrl,
    Value<String>? sourceName,
    Value<DateTime>? pubDate,
    Value<int>? round,
    Value<int>? subround,
    Value<int?>? relevanceScore,
  }) {
    return FeedNewsCompanion(
      id: id ?? this.id,
      isinId: isinId ?? this.isinId,
      title: title ?? this.title,
      link: link ?? this.link,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceName: sourceName ?? this.sourceName,
      pubDate: pubDate ?? this.pubDate,
      round: round ?? this.round,
      subround: subround ?? this.subround,
      relevanceScore: relevanceScore ?? this.relevanceScore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isinId.present) {
      map['isin_id'] = Variable<int>(isinId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (pubDate.present) {
      map['pub_date'] = Variable<DateTime>(pubDate.value);
    }
    if (round.present) {
      map['round'] = Variable<int>(round.value);
    }
    if (subround.present) {
      map['subround'] = Variable<int>(subround.value);
    }
    if (relevanceScore.present) {
      map['relevance_score'] = Variable<int>(relevanceScore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedNewsCompanion(')
          ..write('id: $id, ')
          ..write('isinId: $isinId, ')
          ..write('title: $title, ')
          ..write('link: $link, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('sourceName: $sourceName, ')
          ..write('pubDate: $pubDate, ')
          ..write('round: $round, ')
          ..write('subround: $subround, ')
          ..write('relevanceScore: $relevanceScore')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, role, content, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessageData extends DataClass implements Insertable<ChatMessageData> {
  final int id;
  final String role;
  final String content;
  final DateTime timestamp;
  const ChatMessageData({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      role: Value(role),
      content: Value(content),
      timestamp: Value(timestamp),
    );
  }

  factory ChatMessageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageData(
      id: serializer.fromJson<int>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ChatMessageData copyWith({
    int? id,
    String? role,
    String? content,
    DateTime? timestamp,
  }) => ChatMessageData(
    id: id ?? this.id,
    role: role ?? this.role,
    content: content ?? this.content,
    timestamp: timestamp ?? this.timestamp,
  );
  ChatMessageData copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessageData(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageData(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, role, content, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageData &&
          other.id == this.id &&
          other.role == this.role &&
          other.content == this.content &&
          other.timestamp == this.timestamp);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessageData> {
  final Value<int> id;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> timestamp;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String role,
    required String content,
    required DateTime timestamp,
  }) : role = Value(role),
       content = Value(content),
       timestamp = Value(timestamp);
  static Insertable<ChatMessageData> custom({
    Expression<int>? id,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<int>? id,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? timestamp,
  }) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IsinsTable isins = $IsinsTable(this);
  late final $TickersTable tickers = $TickersTable(this);
  late final $MarketDataCachesTable marketDataCaches = $MarketDataCachesTable(
    this,
  );
  late final $FeedNewsTable feedNews = $FeedNewsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    isins,
    tickers,
    marketDataCaches,
    feedNews,
    chatMessages,
  ];
}

typedef $$IsinsTableCreateCompanionBuilder =
    IsinsCompanion Function({
      Value<int> id,
      Value<String?> isinCode,
      Value<String?> altName,
      Value<List<String>> registeredNames,
      Value<String?> shortName,
    });
typedef $$IsinsTableUpdateCompanionBuilder =
    IsinsCompanion Function({
      Value<int> id,
      Value<String?> isinCode,
      Value<String?> altName,
      Value<List<String>> registeredNames,
      Value<String?> shortName,
    });

final class $$IsinsTableReferences
    extends BaseReferences<_$AppDatabase, $IsinsTable, IsinData> {
  $$IsinsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TickersTable, List<TickerData>> _tickersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tickers,
    aliasName: $_aliasNameGenerator(db.isins.id, db.tickers.isinId),
  );

  $$TickersTableProcessedTableManager get tickersRefs {
    final manager = $$TickersTableTableManager(
      $_db,
      $_db.tickers,
    ).filter((f) => f.isinId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tickersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FeedNewsTable, List<FeedNewsData>>
  _feedNewsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.feedNews,
    aliasName: $_aliasNameGenerator(db.isins.id, db.feedNews.isinId),
  );

  $$FeedNewsTableProcessedTableManager get feedNewsRefs {
    final manager = $$FeedNewsTableTableManager(
      $_db,
      $_db.feedNews,
    ).filter((f) => f.isinId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_feedNewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isinCode => $composableBuilder(
    column: $table.isinCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get altName => $composableBuilder(
    column: $table.altName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get registeredNames => $composableBuilder(
    column: $table.registeredNames,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tickersRefs(
    Expression<bool> Function($$TickersTableFilterComposer f) f,
  ) {
    final $$TickersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickers,
      getReferencedColumn: (t) => t.isinId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TickersTableFilterComposer(
            $db: $db,
            $table: $db.tickers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> feedNewsRefs(
    Expression<bool> Function($$FeedNewsTableFilterComposer f) f,
  ) {
    final $$FeedNewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feedNews,
      getReferencedColumn: (t) => t.isinId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedNewsTableFilterComposer(
            $db: $db,
            $table: $db.feedNews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isinCode => $composableBuilder(
    column: $table.isinCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get altName => $composableBuilder(
    column: $table.altName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registeredNames => $composableBuilder(
    column: $table.registeredNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<String> get altName =>
      $composableBuilder(column: $table.altName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get registeredNames =>
      $composableBuilder(
        column: $table.registeredNames,
        builder: (column) => column,
      );

  GeneratedColumn<String> get shortName =>
      $composableBuilder(column: $table.shortName, builder: (column) => column);

  Expression<T> tickersRefs<T extends Object>(
    Expression<T> Function($$TickersTableAnnotationComposer a) f,
  ) {
    final $$TickersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickers,
      getReferencedColumn: (t) => t.isinId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TickersTableAnnotationComposer(
            $db: $db,
            $table: $db.tickers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> feedNewsRefs<T extends Object>(
    Expression<T> Function($$FeedNewsTableAnnotationComposer a) f,
  ) {
    final $$FeedNewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feedNews,
      getReferencedColumn: (t) => t.isinId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedNewsTableAnnotationComposer(
            $db: $db,
            $table: $db.feedNews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IsinsTableTableManager
    extends
        RootTableManager<
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
          PrefetchHooks Function({bool tickersRefs, bool feedNewsRefs})
        > {
  $$IsinsTableTableManager(_$AppDatabase db, $IsinsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IsinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IsinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IsinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> isinCode = const Value.absent(),
                Value<String?> altName = const Value.absent(),
                Value<List<String>> registeredNames = const Value.absent(),
                Value<String?> shortName = const Value.absent(),
              }) => IsinsCompanion(
                id: id,
                isinCode: isinCode,
                altName: altName,
                registeredNames: registeredNames,
                shortName: shortName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> isinCode = const Value.absent(),
                Value<String?> altName = const Value.absent(),
                Value<List<String>> registeredNames = const Value.absent(),
                Value<String?> shortName = const Value.absent(),
              }) => IsinsCompanion.insert(
                id: id,
                isinCode: isinCode,
                altName: altName,
                registeredNames: registeredNames,
                shortName: shortName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$IsinsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({tickersRefs = false, feedNewsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tickersRefs) db.tickers,
                if (feedNewsRefs) db.feedNews,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tickersRefs)
                    await $_getPrefetchedData<
                      IsinData,
                      $IsinsTable,
                      TickerData
                    >(
                      currentTable: table,
                      referencedTable: $$IsinsTableReferences._tickersRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$IsinsTableReferences(db, table, p0).tickersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.isinId == item.id),
                      typedResults: items,
                    ),
                  if (feedNewsRefs)
                    await $_getPrefetchedData<
                      IsinData,
                      $IsinsTable,
                      FeedNewsData
                    >(
                      currentTable: table,
                      referencedTable: $$IsinsTableReferences
                          ._feedNewsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$IsinsTableReferences(db, table, p0).feedNewsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.isinId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$IsinsTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function({bool tickersRefs, bool feedNewsRefs})
    >;
typedef $$TickersTableCreateCompanionBuilder =
    TickersCompanion Function({
      Value<int> id,
      required String symbol,
      required String exchange,
      Value<String?> currency,
      Value<String?> quoteType,
      Value<int?> regularMarketStart,
      Value<int?> regularMarketEnd,
      Value<int?> preMarketStart,
      Value<int?> preMarketEnd,
      Value<int?> postMarketStart,
      Value<int?> postMarketEnd,
      required int isinId,
    });
typedef $$TickersTableUpdateCompanionBuilder =
    TickersCompanion Function({
      Value<int> id,
      Value<String> symbol,
      Value<String> exchange,
      Value<String?> currency,
      Value<String?> quoteType,
      Value<int?> regularMarketStart,
      Value<int?> regularMarketEnd,
      Value<int?> preMarketStart,
      Value<int?> preMarketEnd,
      Value<int?> postMarketStart,
      Value<int?> postMarketEnd,
      Value<int> isinId,
    });

final class $$TickersTableReferences
    extends BaseReferences<_$AppDatabase, $TickersTable, TickerData> {
  $$TickersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IsinsTable _isinIdTable(_$AppDatabase db) => db.isins.createAlias(
    $_aliasNameGenerator(db.tickers.isinId, db.isins.id),
  );

  $$IsinsTableProcessedTableManager get isinId {
    final $_column = $_itemColumn<int>('isin_id')!;

    final manager = $$IsinsTableTableManager(
      $_db,
      $_db.isins,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_isinIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MarketDataCachesTable, List<MarketDataCacheData>>
  _marketDataCachesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.marketDataCaches,
    aliasName: $_aliasNameGenerator(
      db.tickers.id,
      db.marketDataCaches.tickerId,
    ),
  );

  $$MarketDataCachesTableProcessedTableManager get marketDataCachesRefs {
    final manager = $$MarketDataCachesTableTableManager(
      $_db,
      $_db.marketDataCaches,
    ).filter((f) => f.tickerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _marketDataCachesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exchange => $composableBuilder(
    column: $table.exchange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteType => $composableBuilder(
    column: $table.quoteType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get regularMarketStart => $composableBuilder(
    column: $table.regularMarketStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get regularMarketEnd => $composableBuilder(
    column: $table.regularMarketEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preMarketStart => $composableBuilder(
    column: $table.preMarketStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preMarketEnd => $composableBuilder(
    column: $table.preMarketEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get postMarketStart => $composableBuilder(
    column: $table.postMarketStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get postMarketEnd => $composableBuilder(
    column: $table.postMarketEnd,
    builder: (column) => ColumnFilters(column),
  );

  $$IsinsTableFilterComposer get isinId {
    final $$IsinsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.isinId,
      referencedTable: $db.isins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IsinsTableFilterComposer(
            $db: $db,
            $table: $db.isins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> marketDataCachesRefs(
    Expression<bool> Function($$MarketDataCachesTableFilterComposer f) f,
  ) {
    final $$MarketDataCachesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.marketDataCaches,
      getReferencedColumn: (t) => t.tickerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MarketDataCachesTableFilterComposer(
            $db: $db,
            $table: $db.marketDataCaches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exchange => $composableBuilder(
    column: $table.exchange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteType => $composableBuilder(
    column: $table.quoteType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get regularMarketStart => $composableBuilder(
    column: $table.regularMarketStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get regularMarketEnd => $composableBuilder(
    column: $table.regularMarketEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preMarketStart => $composableBuilder(
    column: $table.preMarketStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preMarketEnd => $composableBuilder(
    column: $table.preMarketEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get postMarketStart => $composableBuilder(
    column: $table.postMarketStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get postMarketEnd => $composableBuilder(
    column: $table.postMarketEnd,
    builder: (column) => ColumnOrderings(column),
  );

  $$IsinsTableOrderingComposer get isinId {
    final $$IsinsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.isinId,
      referencedTable: $db.isins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IsinsTableOrderingComposer(
            $db: $db,
            $table: $db.isins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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

  GeneratedColumn<String> get quoteType =>
      $composableBuilder(column: $table.quoteType, builder: (column) => column);

  GeneratedColumn<int> get regularMarketStart => $composableBuilder(
    column: $table.regularMarketStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get regularMarketEnd => $composableBuilder(
    column: $table.regularMarketEnd,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preMarketStart => $composableBuilder(
    column: $table.preMarketStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preMarketEnd => $composableBuilder(
    column: $table.preMarketEnd,
    builder: (column) => column,
  );

  GeneratedColumn<int> get postMarketStart => $composableBuilder(
    column: $table.postMarketStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get postMarketEnd => $composableBuilder(
    column: $table.postMarketEnd,
    builder: (column) => column,
  );

  $$IsinsTableAnnotationComposer get isinId {
    final $$IsinsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.isinId,
      referencedTable: $db.isins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IsinsTableAnnotationComposer(
            $db: $db,
            $table: $db.isins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> marketDataCachesRefs<T extends Object>(
    Expression<T> Function($$MarketDataCachesTableAnnotationComposer a) f,
  ) {
    final $$MarketDataCachesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.marketDataCaches,
      getReferencedColumn: (t) => t.tickerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MarketDataCachesTableAnnotationComposer(
            $db: $db,
            $table: $db.marketDataCaches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TickersTableTableManager
    extends
        RootTableManager<
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
          PrefetchHooks Function({bool isinId, bool marketDataCachesRefs})
        > {
  $$TickersTableTableManager(_$AppDatabase db, $TickersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TickersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TickersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TickersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<String> exchange = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> quoteType = const Value.absent(),
                Value<int?> regularMarketStart = const Value.absent(),
                Value<int?> regularMarketEnd = const Value.absent(),
                Value<int?> preMarketStart = const Value.absent(),
                Value<int?> preMarketEnd = const Value.absent(),
                Value<int?> postMarketStart = const Value.absent(),
                Value<int?> postMarketEnd = const Value.absent(),
                Value<int> isinId = const Value.absent(),
              }) => TickersCompanion(
                id: id,
                symbol: symbol,
                exchange: exchange,
                currency: currency,
                quoteType: quoteType,
                regularMarketStart: regularMarketStart,
                regularMarketEnd: regularMarketEnd,
                preMarketStart: preMarketStart,
                preMarketEnd: preMarketEnd,
                postMarketStart: postMarketStart,
                postMarketEnd: postMarketEnd,
                isinId: isinId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String symbol,
                required String exchange,
                Value<String?> currency = const Value.absent(),
                Value<String?> quoteType = const Value.absent(),
                Value<int?> regularMarketStart = const Value.absent(),
                Value<int?> regularMarketEnd = const Value.absent(),
                Value<int?> preMarketStart = const Value.absent(),
                Value<int?> preMarketEnd = const Value.absent(),
                Value<int?> postMarketStart = const Value.absent(),
                Value<int?> postMarketEnd = const Value.absent(),
                required int isinId,
              }) => TickersCompanion.insert(
                id: id,
                symbol: symbol,
                exchange: exchange,
                currency: currency,
                quoteType: quoteType,
                regularMarketStart: regularMarketStart,
                regularMarketEnd: regularMarketEnd,
                preMarketStart: preMarketStart,
                preMarketEnd: preMarketEnd,
                postMarketStart: postMarketStart,
                postMarketEnd: postMarketEnd,
                isinId: isinId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TickersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({isinId = false, marketDataCachesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (marketDataCachesRefs) db.marketDataCaches,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (isinId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.isinId,
                                    referencedTable: $$TickersTableReferences
                                        ._isinIdTable(db),
                                    referencedColumn: $$TickersTableReferences
                                        ._isinIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (marketDataCachesRefs)
                        await $_getPrefetchedData<
                          TickerData,
                          $TickersTable,
                          MarketDataCacheData
                        >(
                          currentTable: table,
                          referencedTable: $$TickersTableReferences
                              ._marketDataCachesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TickersTableReferences(
                                db,
                                table,
                                p0,
                              ).marketDataCachesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tickerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TickersTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function({bool isinId, bool marketDataCachesRefs})
    >;
typedef $$MarketDataCachesTableCreateCompanionBuilder =
    MarketDataCachesCompanion Function({
      Value<int> id,
      required String symbol,
      required DateTime lastUpdated,
      Value<double> regularMarketPrice,
      Value<double> chartPreviousClose,
      Value<List<double>> intradayPrices,
      Value<List<int>> intradayTimestamps,
      Value<int?> regularMarketStart,
      Value<int?> regularMarketEnd,
      Value<int?> preMarketStart,
      Value<int?> preMarketEnd,
      Value<int?> postMarketStart,
      Value<int?> postMarketEnd,
      required int tickerId,
    });
typedef $$MarketDataCachesTableUpdateCompanionBuilder =
    MarketDataCachesCompanion Function({
      Value<int> id,
      Value<String> symbol,
      Value<DateTime> lastUpdated,
      Value<double> regularMarketPrice,
      Value<double> chartPreviousClose,
      Value<List<double>> intradayPrices,
      Value<List<int>> intradayTimestamps,
      Value<int?> regularMarketStart,
      Value<int?> regularMarketEnd,
      Value<int?> preMarketStart,
      Value<int?> preMarketEnd,
      Value<int?> postMarketStart,
      Value<int?> postMarketEnd,
      Value<int> tickerId,
    });

final class $$MarketDataCachesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MarketDataCachesTable,
          MarketDataCacheData
        > {
  $$MarketDataCachesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TickersTable _tickerIdTable(_$AppDatabase db) =>
      db.tickers.createAlias(
        $_aliasNameGenerator(db.marketDataCaches.tickerId, db.tickers.id),
      );

  $$TickersTableProcessedTableManager get tickerId {
    final $_column = $_itemColumn<int>('ticker_id')!;

    final manager = $$TickersTableTableManager(
      $_db,
      $_db.tickers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tickerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get regularMarketPrice => $composableBuilder(
    column: $table.regularMarketPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chartPreviousClose => $composableBuilder(
    column: $table.chartPreviousClose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<double>, List<double>, String>
  get intradayPrices => $composableBuilder(
    column: $table.intradayPrices,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<int>, List<int>, String>
  get intradayTimestamps => $composableBuilder(
    column: $table.intradayTimestamps,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get regularMarketStart => $composableBuilder(
    column: $table.regularMarketStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get regularMarketEnd => $composableBuilder(
    column: $table.regularMarketEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preMarketStart => $composableBuilder(
    column: $table.preMarketStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preMarketEnd => $composableBuilder(
    column: $table.preMarketEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get postMarketStart => $composableBuilder(
    column: $table.postMarketStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get postMarketEnd => $composableBuilder(
    column: $table.postMarketEnd,
    builder: (column) => ColumnFilters(column),
  );

  $$TickersTableFilterComposer get tickerId {
    final $$TickersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tickerId,
      referencedTable: $db.tickers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TickersTableFilterComposer(
            $db: $db,
            $table: $db.tickers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get regularMarketPrice => $composableBuilder(
    column: $table.regularMarketPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chartPreviousClose => $composableBuilder(
    column: $table.chartPreviousClose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intradayPrices => $composableBuilder(
    column: $table.intradayPrices,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intradayTimestamps => $composableBuilder(
    column: $table.intradayTimestamps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get regularMarketStart => $composableBuilder(
    column: $table.regularMarketStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get regularMarketEnd => $composableBuilder(
    column: $table.regularMarketEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preMarketStart => $composableBuilder(
    column: $table.preMarketStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preMarketEnd => $composableBuilder(
    column: $table.preMarketEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get postMarketStart => $composableBuilder(
    column: $table.postMarketStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get postMarketEnd => $composableBuilder(
    column: $table.postMarketEnd,
    builder: (column) => ColumnOrderings(column),
  );

  $$TickersTableOrderingComposer get tickerId {
    final $$TickersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tickerId,
      referencedTable: $db.tickers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TickersTableOrderingComposer(
            $db: $db,
            $table: $db.tickers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<double> get regularMarketPrice => $composableBuilder(
    column: $table.regularMarketPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get chartPreviousClose => $composableBuilder(
    column: $table.chartPreviousClose,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<double>, String> get intradayPrices =>
      $composableBuilder(
        column: $table.intradayPrices,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<int>, String> get intradayTimestamps =>
      $composableBuilder(
        column: $table.intradayTimestamps,
        builder: (column) => column,
      );

  GeneratedColumn<int> get regularMarketStart => $composableBuilder(
    column: $table.regularMarketStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get regularMarketEnd => $composableBuilder(
    column: $table.regularMarketEnd,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preMarketStart => $composableBuilder(
    column: $table.preMarketStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preMarketEnd => $composableBuilder(
    column: $table.preMarketEnd,
    builder: (column) => column,
  );

  GeneratedColumn<int> get postMarketStart => $composableBuilder(
    column: $table.postMarketStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get postMarketEnd => $composableBuilder(
    column: $table.postMarketEnd,
    builder: (column) => column,
  );

  $$TickersTableAnnotationComposer get tickerId {
    final $$TickersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tickerId,
      referencedTable: $db.tickers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TickersTableAnnotationComposer(
            $db: $db,
            $table: $db.tickers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MarketDataCachesTableTableManager
    extends
        RootTableManager<
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
          PrefetchHooks Function({bool tickerId})
        > {
  $$MarketDataCachesTableTableManager(
    _$AppDatabase db,
    $MarketDataCachesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarketDataCachesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarketDataCachesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarketDataCachesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<double> regularMarketPrice = const Value.absent(),
                Value<double> chartPreviousClose = const Value.absent(),
                Value<List<double>> intradayPrices = const Value.absent(),
                Value<List<int>> intradayTimestamps = const Value.absent(),
                Value<int?> regularMarketStart = const Value.absent(),
                Value<int?> regularMarketEnd = const Value.absent(),
                Value<int?> preMarketStart = const Value.absent(),
                Value<int?> preMarketEnd = const Value.absent(),
                Value<int?> postMarketStart = const Value.absent(),
                Value<int?> postMarketEnd = const Value.absent(),
                Value<int> tickerId = const Value.absent(),
              }) => MarketDataCachesCompanion(
                id: id,
                symbol: symbol,
                lastUpdated: lastUpdated,
                regularMarketPrice: regularMarketPrice,
                chartPreviousClose: chartPreviousClose,
                intradayPrices: intradayPrices,
                intradayTimestamps: intradayTimestamps,
                regularMarketStart: regularMarketStart,
                regularMarketEnd: regularMarketEnd,
                preMarketStart: preMarketStart,
                preMarketEnd: preMarketEnd,
                postMarketStart: postMarketStart,
                postMarketEnd: postMarketEnd,
                tickerId: tickerId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String symbol,
                required DateTime lastUpdated,
                Value<double> regularMarketPrice = const Value.absent(),
                Value<double> chartPreviousClose = const Value.absent(),
                Value<List<double>> intradayPrices = const Value.absent(),
                Value<List<int>> intradayTimestamps = const Value.absent(),
                Value<int?> regularMarketStart = const Value.absent(),
                Value<int?> regularMarketEnd = const Value.absent(),
                Value<int?> preMarketStart = const Value.absent(),
                Value<int?> preMarketEnd = const Value.absent(),
                Value<int?> postMarketStart = const Value.absent(),
                Value<int?> postMarketEnd = const Value.absent(),
                required int tickerId,
              }) => MarketDataCachesCompanion.insert(
                id: id,
                symbol: symbol,
                lastUpdated: lastUpdated,
                regularMarketPrice: regularMarketPrice,
                chartPreviousClose: chartPreviousClose,
                intradayPrices: intradayPrices,
                intradayTimestamps: intradayTimestamps,
                regularMarketStart: regularMarketStart,
                regularMarketEnd: regularMarketEnd,
                preMarketStart: preMarketStart,
                preMarketEnd: preMarketEnd,
                postMarketStart: postMarketStart,
                postMarketEnd: postMarketEnd,
                tickerId: tickerId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MarketDataCachesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tickerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (tickerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tickerId,
                                referencedTable:
                                    $$MarketDataCachesTableReferences
                                        ._tickerIdTable(db),
                                referencedColumn:
                                    $$MarketDataCachesTableReferences
                                        ._tickerIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MarketDataCachesTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function({bool tickerId})
    >;
typedef $$FeedNewsTableCreateCompanionBuilder =
    FeedNewsCompanion Function({
      Value<int> id,
      required int isinId,
      required String title,
      required String link,
      required String sourceUrl,
      required String sourceName,
      required DateTime pubDate,
      required int round,
      required int subround,
      Value<int?> relevanceScore,
    });
typedef $$FeedNewsTableUpdateCompanionBuilder =
    FeedNewsCompanion Function({
      Value<int> id,
      Value<int> isinId,
      Value<String> title,
      Value<String> link,
      Value<String> sourceUrl,
      Value<String> sourceName,
      Value<DateTime> pubDate,
      Value<int> round,
      Value<int> subround,
      Value<int?> relevanceScore,
    });

final class $$FeedNewsTableReferences
    extends BaseReferences<_$AppDatabase, $FeedNewsTable, FeedNewsData> {
  $$FeedNewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IsinsTable _isinIdTable(_$AppDatabase db) => db.isins.createAlias(
    $_aliasNameGenerator(db.feedNews.isinId, db.isins.id),
  );

  $$IsinsTableProcessedTableManager get isinId {
    final $_column = $_itemColumn<int>('isin_id')!;

    final manager = $$IsinsTableTableManager(
      $_db,
      $_db.isins,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_isinIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FeedNewsTableFilterComposer
    extends Composer<_$AppDatabase, $FeedNewsTable> {
  $$FeedNewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pubDate => $composableBuilder(
    column: $table.pubDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subround => $composableBuilder(
    column: $table.subround,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relevanceScore => $composableBuilder(
    column: $table.relevanceScore,
    builder: (column) => ColumnFilters(column),
  );

  $$IsinsTableFilterComposer get isinId {
    final $$IsinsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.isinId,
      referencedTable: $db.isins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IsinsTableFilterComposer(
            $db: $db,
            $table: $db.isins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedNewsTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedNewsTable> {
  $$FeedNewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pubDate => $composableBuilder(
    column: $table.pubDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subround => $composableBuilder(
    column: $table.subround,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relevanceScore => $composableBuilder(
    column: $table.relevanceScore,
    builder: (column) => ColumnOrderings(column),
  );

  $$IsinsTableOrderingComposer get isinId {
    final $$IsinsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.isinId,
      referencedTable: $db.isins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IsinsTableOrderingComposer(
            $db: $db,
            $table: $db.isins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedNewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedNewsTable> {
  $$FeedNewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pubDate =>
      $composableBuilder(column: $table.pubDate, builder: (column) => column);

  GeneratedColumn<int> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  GeneratedColumn<int> get subround =>
      $composableBuilder(column: $table.subround, builder: (column) => column);

  GeneratedColumn<int> get relevanceScore => $composableBuilder(
    column: $table.relevanceScore,
    builder: (column) => column,
  );

  $$IsinsTableAnnotationComposer get isinId {
    final $$IsinsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.isinId,
      referencedTable: $db.isins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IsinsTableAnnotationComposer(
            $db: $db,
            $table: $db.isins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedNewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedNewsTable,
          FeedNewsData,
          $$FeedNewsTableFilterComposer,
          $$FeedNewsTableOrderingComposer,
          $$FeedNewsTableAnnotationComposer,
          $$FeedNewsTableCreateCompanionBuilder,
          $$FeedNewsTableUpdateCompanionBuilder,
          (FeedNewsData, $$FeedNewsTableReferences),
          FeedNewsData,
          PrefetchHooks Function({bool isinId})
        > {
  $$FeedNewsTableTableManager(_$AppDatabase db, $FeedNewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedNewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedNewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedNewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> isinId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> link = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String> sourceName = const Value.absent(),
                Value<DateTime> pubDate = const Value.absent(),
                Value<int> round = const Value.absent(),
                Value<int> subround = const Value.absent(),
                Value<int?> relevanceScore = const Value.absent(),
              }) => FeedNewsCompanion(
                id: id,
                isinId: isinId,
                title: title,
                link: link,
                sourceUrl: sourceUrl,
                sourceName: sourceName,
                pubDate: pubDate,
                round: round,
                subround: subround,
                relevanceScore: relevanceScore,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int isinId,
                required String title,
                required String link,
                required String sourceUrl,
                required String sourceName,
                required DateTime pubDate,
                required int round,
                required int subround,
                Value<int?> relevanceScore = const Value.absent(),
              }) => FeedNewsCompanion.insert(
                id: id,
                isinId: isinId,
                title: title,
                link: link,
                sourceUrl: sourceUrl,
                sourceName: sourceName,
                pubDate: pubDate,
                round: round,
                subround: subround,
                relevanceScore: relevanceScore,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FeedNewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({isinId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (isinId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.isinId,
                                referencedTable: $$FeedNewsTableReferences
                                    ._isinIdTable(db),
                                referencedColumn: $$FeedNewsTableReferences
                                    ._isinIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FeedNewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedNewsTable,
      FeedNewsData,
      $$FeedNewsTableFilterComposer,
      $$FeedNewsTableOrderingComposer,
      $$FeedNewsTableAnnotationComposer,
      $$FeedNewsTableCreateCompanionBuilder,
      $$FeedNewsTableUpdateCompanionBuilder,
      (FeedNewsData, $$FeedNewsTableReferences),
      FeedNewsData,
      PrefetchHooks Function({bool isinId})
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      required String role,
      required String content,
      required DateTime timestamp,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      Value<String> role,
      Value<String> content,
      Value<DateTime> timestamp,
    });

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessageData,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (
            ChatMessageData,
            BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageData>,
          ),
          ChatMessageData,
          PrefetchHooks Function()
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ChatMessagesCompanion(
                id: id,
                role: role,
                content: content,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String role,
                required String content,
                required DateTime timestamp,
              }) => ChatMessagesCompanion.insert(
                id: id,
                role: role,
                content: content,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessageData,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (
        ChatMessageData,
        BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageData>,
      ),
      ChatMessageData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IsinsTableTableManager get isins =>
      $$IsinsTableTableManager(_db, _db.isins);
  $$TickersTableTableManager get tickers =>
      $$TickersTableTableManager(_db, _db.tickers);
  $$MarketDataCachesTableTableManager get marketDataCaches =>
      $$MarketDataCachesTableTableManager(_db, _db.marketDataCaches);
  $$FeedNewsTableTableManager get feedNews =>
      $$FeedNewsTableTableManager(_db, _db.feedNews);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
}
