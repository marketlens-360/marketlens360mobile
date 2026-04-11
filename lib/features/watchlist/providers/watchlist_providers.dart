import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:marketlens360mobile/data/local/app_database.dart';
import 'package:marketlens360mobile/data/models/security.dart';
import 'package:marketlens360mobile/data/providers/repository_providers.dart';
import 'package:marketlens360mobile/data/repositories/security_repository.dart';

final watchlistProvider = ChangeNotifierProvider<WatchlistNotifier>((ref) {
  final db   = ref.watch(appDatabaseProvider);
  final repo = ref.read(securityRepositoryProvider);
  final notifier = WatchlistNotifier(db, repo);
  Future.microtask(notifier.initialize);
  return notifier;
});

class WatchlistNotifier extends ChangeNotifier {
  WatchlistNotifier(this._db, this._repo);

  final AppDatabase _db;
  final SecurityRepository _repo;

  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  List<SecuritySummary> _securities = [];
  List<AlertTableData> _alerts = [];

  StreamSubscription<List<WatchlistTableData>>? _watchlistSub;
  StreamSubscription<List<AlertTableData>>? _alertsSub;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<SecuritySummary> get securities => _securities;
  List<AlertTableData> get alerts => _alerts;

  void initialize() {
    _watchlistSub = _db.getWatchlist().listen(
      (rows) {
        final symbols = rows.map((r) => r.symbol).toList();
        _loadSecurities(symbols);
      },
      onError: (Object e) {
        if (_disposed) return;
        _error = e.toString();
        _notifyListeners();
      },
    );

    _alertsSub = _db.getActiveAlerts().listen(
      (alerts) {
        if (_disposed) return;
        _alerts = alerts;
        _notifyListeners();
      },
      onError: (Object e) {
        if (_disposed) return;
        _error = e.toString();
        _notifyListeners();
      },
    );
  }

  Future<void> _loadSecurities(List<String> symbols) async {
    if (_disposed) return;
    if (symbols.isEmpty) {
      _securities = [];
      _notifyListeners();
      return;
    }
    _isLoading = true;
    _notifyListeners();
    try {
      _securities = await Future.wait(symbols.map(_repo.getSecuritySummary));
      if (_disposed) return;
      _error = null;
    } catch (e) {
      if (_disposed) return;
      _error = e.toString();
    } finally {
      if (!_disposed) {
        _isLoading = false;
        _notifyListeners();
      }
    }
  }

  Future<void> addToWatchlist(String symbol) => _db.addToWatchlist(symbol);
  Future<void> removeFromWatchlist(String symbol) =>
      _db.removeFromWatchlist(symbol);

  Stream<bool> isInWatchlist(String symbol) => _db.isInWatchlist(symbol);

  Future<void> addAlert({
    required String symbol,
    required double targetPrice,
    required String direction,
  }) =>
      _db.addAlert(
        symbol: symbol,
        targetPrice: targetPrice,
        direction: direction,
      );

  Future<void> deleteAlert(int id) => _db.deleteAlert(id);

  void _notifyListeners() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _watchlistSub?.cancel();
    _alertsSub?.cancel();
    super.dispose();
  }
}
