import 'package:drift/drift.dart';

class AlertTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text()();
  RealColumn get targetPrice => real()();
  TextColumn get direction => text()(); // 'above' or 'below'
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get triggeredAt => dateTime().nullable()();
}
