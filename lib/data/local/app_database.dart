import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tables/watchlist_table.dart';
import 'tables/alert_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [WatchlistTable, AlertTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'marketlens.db'));

  @override
  int get schemaVersion => 1;

  // ── Watchlist ─────────────────────────────────────────────────────────────

  Stream<List<WatchlistTableData>> getWatchlist() {
    return (select(watchlistTable)
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .watch();
  }

  Future<void> addToWatchlist(String symbol) async {
    await into(watchlistTable).insertOnConflictUpdate(
      WatchlistTableCompanion.insert(
        symbol: symbol,
        addedAt: DateTime.now(),
      ),
    );
  }

  Future<void> removeFromWatchlist(String symbol) async {
    await (delete(watchlistTable)
          ..where((t) => t.symbol.equals(symbol)))
        .go();
  }

  Stream<bool> isInWatchlist(String symbol) {
    return (select(watchlistTable)..where((t) => t.symbol.equals(symbol)))
        .watch()
        .map((rows) => rows.isNotEmpty);
  }

  // ── Alerts ────────────────────────────────────────────────────────────────

  Stream<List<AlertTableData>> getAlerts() {
    return (select(alertTable)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<AlertTableData>> getActiveAlerts() {
    return (select(alertTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> addAlert({
    required String symbol,
    required double targetPrice,
    required String direction,
  }) async {
    await into(alertTable).insert(
      AlertTableCompanion.insert(
        symbol: symbol,
        targetPrice: targetPrice,
        direction: direction,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> deleteAlert(int id) async {
    await (delete(alertTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markAlertTriggered(int id) async {
    await (update(alertTable)..where((t) => t.id.equals(id))).write(
      AlertTableCompanion(
        isActive: const Value(false),
        triggeredAt: Value(DateTime.now()),
      ),
    );
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
