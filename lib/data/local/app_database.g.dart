// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WatchlistTableTable extends WatchlistTable
    with TableInfo<$WatchlistTableTable, WatchlistTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WatchlistTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [symbol, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'watchlist_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WatchlistTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symbol};
  @override
  WatchlistTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WatchlistTableData(
      symbol:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}symbol'],
          )!,
      addedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}added_at'],
          )!,
    );
  }

  @override
  $WatchlistTableTable createAlias(String alias) {
    return $WatchlistTableTable(attachedDatabase, alias);
  }
}

class WatchlistTableData extends DataClass
    implements Insertable<WatchlistTableData> {
  final String symbol;
  final DateTime addedAt;
  const WatchlistTableData({required this.symbol, required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symbol'] = Variable<String>(symbol);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  WatchlistTableCompanion toCompanion(bool nullToAbsent) {
    return WatchlistTableCompanion(
      symbol: Value(symbol),
      addedAt: Value(addedAt),
    );
  }

  factory WatchlistTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WatchlistTableData(
      symbol: serializer.fromJson<String>(json['symbol']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symbol': serializer.toJson<String>(symbol),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  WatchlistTableData copyWith({String? symbol, DateTime? addedAt}) =>
      WatchlistTableData(
        symbol: symbol ?? this.symbol,
        addedAt: addedAt ?? this.addedAt,
      );
  WatchlistTableData copyWithCompanion(WatchlistTableCompanion data) {
    return WatchlistTableData(
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WatchlistTableData(')
          ..write('symbol: $symbol, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symbol, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WatchlistTableData &&
          other.symbol == this.symbol &&
          other.addedAt == this.addedAt);
}

class WatchlistTableCompanion extends UpdateCompanion<WatchlistTableData> {
  final Value<String> symbol;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const WatchlistTableCompanion({
    this.symbol = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WatchlistTableCompanion.insert({
    required String symbol,
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : symbol = Value(symbol),
       addedAt = Value(addedAt);
  static Insertable<WatchlistTableData> custom({
    Expression<String>? symbol,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symbol != null) 'symbol': symbol,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WatchlistTableCompanion copyWith({
    Value<String>? symbol,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return WatchlistTableCompanion(
      symbol: symbol ?? this.symbol,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WatchlistTableCompanion(')
          ..write('symbol: $symbol, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertTableTable extends AlertTable
    with TableInfo<$AlertTableTable, AlertTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertTableTable(this.attachedDatabase, [this._alias]);
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
  );
  static const VerificationMeta _targetPriceMeta = const VerificationMeta(
    'targetPrice',
  );
  @override
  late final GeneratedColumn<double> targetPrice = GeneratedColumn<double>(
    'target_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggeredAtMeta = const VerificationMeta(
    'triggeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> triggeredAt = GeneratedColumn<DateTime>(
    'triggered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    symbol,
    targetPrice,
    direction,
    isActive,
    createdAt,
    triggeredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alert_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlertTableData> instance, {
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
    if (data.containsKey('target_price')) {
      context.handle(
        _targetPriceMeta,
        targetPrice.isAcceptableOrUnknown(
          data['target_price']!,
          _targetPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetPriceMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('triggered_at')) {
      context.handle(
        _triggeredAtMeta,
        triggeredAt.isAcceptableOrUnknown(
          data['triggered_at']!,
          _triggeredAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlertTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      symbol:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}symbol'],
          )!,
      targetPrice:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}target_price'],
          )!,
      direction:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}direction'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      triggeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}triggered_at'],
      ),
    );
  }

  @override
  $AlertTableTable createAlias(String alias) {
    return $AlertTableTable(attachedDatabase, alias);
  }
}

class AlertTableData extends DataClass implements Insertable<AlertTableData> {
  final int id;
  final String symbol;
  final double targetPrice;
  final String direction;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? triggeredAt;
  const AlertTableData({
    required this.id,
    required this.symbol,
    required this.targetPrice,
    required this.direction,
    required this.isActive,
    required this.createdAt,
    this.triggeredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['target_price'] = Variable<double>(targetPrice);
    map['direction'] = Variable<String>(direction);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || triggeredAt != null) {
      map['triggered_at'] = Variable<DateTime>(triggeredAt);
    }
    return map;
  }

  AlertTableCompanion toCompanion(bool nullToAbsent) {
    return AlertTableCompanion(
      id: Value(id),
      symbol: Value(symbol),
      targetPrice: Value(targetPrice),
      direction: Value(direction),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      triggeredAt:
          triggeredAt == null && nullToAbsent
              ? const Value.absent()
              : Value(triggeredAt),
    );
  }

  factory AlertTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertTableData(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      targetPrice: serializer.fromJson<double>(json['targetPrice']),
      direction: serializer.fromJson<String>(json['direction']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      triggeredAt: serializer.fromJson<DateTime?>(json['triggeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'symbol': serializer.toJson<String>(symbol),
      'targetPrice': serializer.toJson<double>(targetPrice),
      'direction': serializer.toJson<String>(direction),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'triggeredAt': serializer.toJson<DateTime?>(triggeredAt),
    };
  }

  AlertTableData copyWith({
    int? id,
    String? symbol,
    double? targetPrice,
    String? direction,
    bool? isActive,
    DateTime? createdAt,
    Value<DateTime?> triggeredAt = const Value.absent(),
  }) => AlertTableData(
    id: id ?? this.id,
    symbol: symbol ?? this.symbol,
    targetPrice: targetPrice ?? this.targetPrice,
    direction: direction ?? this.direction,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    triggeredAt: triggeredAt.present ? triggeredAt.value : this.triggeredAt,
  );
  AlertTableData copyWithCompanion(AlertTableCompanion data) {
    return AlertTableData(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      targetPrice:
          data.targetPrice.present ? data.targetPrice.value : this.targetPrice,
      direction: data.direction.present ? data.direction.value : this.direction,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      triggeredAt:
          data.triggeredAt.present ? data.triggeredAt.value : this.triggeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertTableData(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('direction: $direction, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('triggeredAt: $triggeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    symbol,
    targetPrice,
    direction,
    isActive,
    createdAt,
    triggeredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertTableData &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.targetPrice == this.targetPrice &&
          other.direction == this.direction &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.triggeredAt == this.triggeredAt);
}

class AlertTableCompanion extends UpdateCompanion<AlertTableData> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<double> targetPrice;
  final Value<String> direction;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime?> triggeredAt;
  const AlertTableCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.targetPrice = const Value.absent(),
    this.direction = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.triggeredAt = const Value.absent(),
  });
  AlertTableCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required double targetPrice,
    required String direction,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.triggeredAt = const Value.absent(),
  }) : symbol = Value(symbol),
       targetPrice = Value(targetPrice),
       direction = Value(direction),
       createdAt = Value(createdAt);
  static Insertable<AlertTableData> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<double>? targetPrice,
    Expression<String>? direction,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? triggeredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (targetPrice != null) 'target_price': targetPrice,
      if (direction != null) 'direction': direction,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (triggeredAt != null) 'triggered_at': triggeredAt,
    });
  }

  AlertTableCompanion copyWith({
    Value<int>? id,
    Value<String>? symbol,
    Value<double>? targetPrice,
    Value<String>? direction,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime?>? triggeredAt,
  }) {
    return AlertTableCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      targetPrice: targetPrice ?? this.targetPrice,
      direction: direction ?? this.direction,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      triggeredAt: triggeredAt ?? this.triggeredAt,
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
    if (targetPrice.present) {
      map['target_price'] = Variable<double>(targetPrice.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (triggeredAt.present) {
      map['triggered_at'] = Variable<DateTime>(triggeredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertTableCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('direction: $direction, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('triggeredAt: $triggeredAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WatchlistTableTable watchlistTable = $WatchlistTableTable(this);
  late final $AlertTableTable alertTable = $AlertTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    watchlistTable,
    alertTable,
  ];
}

typedef $$WatchlistTableTableCreateCompanionBuilder =
    WatchlistTableCompanion Function({
      required String symbol,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$WatchlistTableTableUpdateCompanionBuilder =
    WatchlistTableCompanion Function({
      Value<String> symbol,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

class $$WatchlistTableTableFilterComposer
    extends Composer<_$AppDatabase, $WatchlistTableTable> {
  $$WatchlistTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WatchlistTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WatchlistTableTable> {
  $$WatchlistTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WatchlistTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WatchlistTableTable> {
  $$WatchlistTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$WatchlistTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WatchlistTableTable,
          WatchlistTableData,
          $$WatchlistTableTableFilterComposer,
          $$WatchlistTableTableOrderingComposer,
          $$WatchlistTableTableAnnotationComposer,
          $$WatchlistTableTableCreateCompanionBuilder,
          $$WatchlistTableTableUpdateCompanionBuilder,
          (
            WatchlistTableData,
            BaseReferences<
              _$AppDatabase,
              $WatchlistTableTable,
              WatchlistTableData
            >,
          ),
          WatchlistTableData,
          PrefetchHooks Function()
        > {
  $$WatchlistTableTableTableManager(
    _$AppDatabase db,
    $WatchlistTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WatchlistTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$WatchlistTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$WatchlistTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> symbol = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WatchlistTableCompanion(
                symbol: symbol,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symbol,
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => WatchlistTableCompanion.insert(
                symbol: symbol,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WatchlistTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WatchlistTableTable,
      WatchlistTableData,
      $$WatchlistTableTableFilterComposer,
      $$WatchlistTableTableOrderingComposer,
      $$WatchlistTableTableAnnotationComposer,
      $$WatchlistTableTableCreateCompanionBuilder,
      $$WatchlistTableTableUpdateCompanionBuilder,
      (
        WatchlistTableData,
        BaseReferences<_$AppDatabase, $WatchlistTableTable, WatchlistTableData>,
      ),
      WatchlistTableData,
      PrefetchHooks Function()
    >;
typedef $$AlertTableTableCreateCompanionBuilder =
    AlertTableCompanion Function({
      Value<int> id,
      required String symbol,
      required double targetPrice,
      required String direction,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<DateTime?> triggeredAt,
    });
typedef $$AlertTableTableUpdateCompanionBuilder =
    AlertTableCompanion Function({
      Value<int> id,
      Value<String> symbol,
      Value<double> targetPrice,
      Value<String> direction,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime?> triggeredAt,
    });

class $$AlertTableTableFilterComposer
    extends Composer<_$AppDatabase, $AlertTableTable> {
  $$AlertTableTableFilterComposer({
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

  ColumnFilters<double> get targetPrice => $composableBuilder(
    column: $table.targetPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlertTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertTableTable> {
  $$AlertTableTableOrderingComposer({
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

  ColumnOrderings<double> get targetPrice => $composableBuilder(
    column: $table.targetPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlertTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertTableTable> {
  $$AlertTableTableAnnotationComposer({
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

  GeneratedColumn<double> get targetPrice => $composableBuilder(
    column: $table.targetPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => column,
  );
}

class $$AlertTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlertTableTable,
          AlertTableData,
          $$AlertTableTableFilterComposer,
          $$AlertTableTableOrderingComposer,
          $$AlertTableTableAnnotationComposer,
          $$AlertTableTableCreateCompanionBuilder,
          $$AlertTableTableUpdateCompanionBuilder,
          (
            AlertTableData,
            BaseReferences<_$AppDatabase, $AlertTableTable, AlertTableData>,
          ),
          AlertTableData,
          PrefetchHooks Function()
        > {
  $$AlertTableTableTableManager(_$AppDatabase db, $AlertTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AlertTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AlertTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AlertTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<double> targetPrice = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> triggeredAt = const Value.absent(),
              }) => AlertTableCompanion(
                id: id,
                symbol: symbol,
                targetPrice: targetPrice,
                direction: direction,
                isActive: isActive,
                createdAt: createdAt,
                triggeredAt: triggeredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String symbol,
                required double targetPrice,
                required String direction,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> triggeredAt = const Value.absent(),
              }) => AlertTableCompanion.insert(
                id: id,
                symbol: symbol,
                targetPrice: targetPrice,
                direction: direction,
                isActive: isActive,
                createdAt: createdAt,
                triggeredAt: triggeredAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlertTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlertTableTable,
      AlertTableData,
      $$AlertTableTableFilterComposer,
      $$AlertTableTableOrderingComposer,
      $$AlertTableTableAnnotationComposer,
      $$AlertTableTableCreateCompanionBuilder,
      $$AlertTableTableUpdateCompanionBuilder,
      (
        AlertTableData,
        BaseReferences<_$AppDatabase, $AlertTableTable, AlertTableData>,
      ),
      AlertTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WatchlistTableTableTableManager get watchlistTable =>
      $$WatchlistTableTableTableManager(_db, _db.watchlistTable);
  $$AlertTableTableTableManager get alertTable =>
      $$AlertTableTableTableManager(_db, _db.alertTable);
}
