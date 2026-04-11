import 'package:drift/drift.dart';

class WatchlistTable extends Table {
  TextColumn get symbol => text()();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {symbol};
}
