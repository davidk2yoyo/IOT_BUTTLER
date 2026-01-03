/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class SensorReading
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SensorReading._({
    this.id,
    required this.deviceId,
    required this.type,
    required this.value,
    required this.timestamp,
    required this.alertTriggered,
  });

  factory SensorReading({
    int? id,
    required int deviceId,
    required String type,
    required double value,
    required DateTime timestamp,
    required bool alertTriggered,
  }) = _SensorReadingImpl;

  factory SensorReading.fromJson(Map<String, dynamic> jsonSerialization) {
    return SensorReading(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      type: jsonSerialization['type'] as String,
      value: (jsonSerialization['value'] as num).toDouble(),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      alertTriggered: jsonSerialization['alertTriggered'] as bool,
    );
  }

  static final t = SensorReadingTable();

  static const db = SensorReadingRepository._();

  @override
  int? id;

  /// The ID of the device that sent this reading
  int deviceId;

  /// The type of sensor reading (temperature, humidity, voltage, custom)
  String type;

  /// The sensor value
  double value;

  /// When the reading was received
  DateTime timestamp;

  /// Whether this reading triggered an alert
  bool alertTriggered;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SensorReading]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SensorReading copyWith({
    int? id,
    int? deviceId,
    String? type,
    double? value,
    DateTime? timestamp,
    bool? alertTriggered,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SensorReading',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      'type': type,
      'value': value,
      'timestamp': timestamp.toJson(),
      'alertTriggered': alertTriggered,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SensorReading',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      'type': type,
      'value': value,
      'timestamp': timestamp.toJson(),
      'alertTriggered': alertTriggered,
    };
  }

  static SensorReadingInclude include() {
    return SensorReadingInclude._();
  }

  static SensorReadingIncludeList includeList({
    _i1.WhereExpressionBuilder<SensorReadingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SensorReadingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SensorReadingTable>? orderByList,
    SensorReadingInclude? include,
  }) {
    return SensorReadingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SensorReading.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SensorReading.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SensorReadingImpl extends SensorReading {
  _SensorReadingImpl({
    int? id,
    required int deviceId,
    required String type,
    required double value,
    required DateTime timestamp,
    required bool alertTriggered,
  }) : super._(
         id: id,
         deviceId: deviceId,
         type: type,
         value: value,
         timestamp: timestamp,
         alertTriggered: alertTriggered,
       );

  /// Returns a shallow copy of this [SensorReading]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SensorReading copyWith({
    Object? id = _Undefined,
    int? deviceId,
    String? type,
    double? value,
    DateTime? timestamp,
    bool? alertTriggered,
  }) {
    return SensorReading(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      alertTriggered: alertTriggered ?? this.alertTriggered,
    );
  }
}

class SensorReadingUpdateTable extends _i1.UpdateTable<SensorReadingTable> {
  SensorReadingUpdateTable(super.table);

  _i1.ColumnValue<int, int> deviceId(int value) => _i1.ColumnValue(
    table.deviceId,
    value,
  );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<double, double> value(double value) => _i1.ColumnValue(
    table.value,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _i1.ColumnValue(
        table.timestamp,
        value,
      );

  _i1.ColumnValue<bool, bool> alertTriggered(bool value) => _i1.ColumnValue(
    table.alertTriggered,
    value,
  );
}

class SensorReadingTable extends _i1.Table<int?> {
  SensorReadingTable({super.tableRelation})
    : super(tableName: 'sensor_reading') {
    updateTable = SensorReadingUpdateTable(this);
    deviceId = _i1.ColumnInt(
      'deviceId',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    value = _i1.ColumnDouble(
      'value',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    alertTriggered = _i1.ColumnBool(
      'alertTriggered',
      this,
    );
  }

  late final SensorReadingUpdateTable updateTable;

  /// The ID of the device that sent this reading
  late final _i1.ColumnInt deviceId;

  /// The type of sensor reading (temperature, humidity, voltage, custom)
  late final _i1.ColumnString type;

  /// The sensor value
  late final _i1.ColumnDouble value;

  /// When the reading was received
  late final _i1.ColumnDateTime timestamp;

  /// Whether this reading triggered an alert
  late final _i1.ColumnBool alertTriggered;

  @override
  List<_i1.Column> get columns => [
    id,
    deviceId,
    type,
    value,
    timestamp,
    alertTriggered,
  ];
}

class SensorReadingInclude extends _i1.IncludeObject {
  SensorReadingInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SensorReading.t;
}

class SensorReadingIncludeList extends _i1.IncludeList {
  SensorReadingIncludeList._({
    _i1.WhereExpressionBuilder<SensorReadingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SensorReading.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SensorReading.t;
}

class SensorReadingRepository {
  const SensorReadingRepository._();

  /// Returns a list of [SensorReading]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<SensorReading>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SensorReadingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SensorReadingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SensorReadingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SensorReading>(
      where: where?.call(SensorReading.t),
      orderBy: orderBy?.call(SensorReading.t),
      orderByList: orderByList?.call(SensorReading.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SensorReading] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<SensorReading?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SensorReadingTable>? where,
    int? offset,
    _i1.OrderByBuilder<SensorReadingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SensorReadingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SensorReading>(
      where: where?.call(SensorReading.t),
      orderBy: orderBy?.call(SensorReading.t),
      orderByList: orderByList?.call(SensorReading.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SensorReading] by its [id] or null if no such row exists.
  Future<SensorReading?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SensorReading>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SensorReading]s in the list and returns the inserted rows.
  ///
  /// The returned [SensorReading]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SensorReading>> insert(
    _i1.Session session,
    List<SensorReading> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SensorReading>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SensorReading] and returns the inserted row.
  ///
  /// The returned [SensorReading] will have its `id` field set.
  Future<SensorReading> insertRow(
    _i1.Session session,
    SensorReading row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SensorReading>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SensorReading]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SensorReading>> update(
    _i1.Session session,
    List<SensorReading> rows, {
    _i1.ColumnSelections<SensorReadingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SensorReading>(
      rows,
      columns: columns?.call(SensorReading.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SensorReading]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SensorReading> updateRow(
    _i1.Session session,
    SensorReading row, {
    _i1.ColumnSelections<SensorReadingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SensorReading>(
      row,
      columns: columns?.call(SensorReading.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SensorReading] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SensorReading?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SensorReadingUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SensorReading>(
      id,
      columnValues: columnValues(SensorReading.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SensorReading]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SensorReading>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SensorReadingUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SensorReadingTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SensorReadingTable>? orderBy,
    _i1.OrderByListBuilder<SensorReadingTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SensorReading>(
      columnValues: columnValues(SensorReading.t.updateTable),
      where: where(SensorReading.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SensorReading.t),
      orderByList: orderByList?.call(SensorReading.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SensorReading]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SensorReading>> delete(
    _i1.Session session,
    List<SensorReading> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SensorReading>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SensorReading].
  Future<SensorReading> deleteRow(
    _i1.Session session,
    SensorReading row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SensorReading>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SensorReading>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SensorReadingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SensorReading>(
      where: where(SensorReading.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SensorReadingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SensorReading>(
      where: where?.call(SensorReading.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
