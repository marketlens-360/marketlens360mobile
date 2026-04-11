import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:marketlens360mobile/data/local/app_database.dart';
import 'package:marketlens360mobile/data/models/dividend.dart';
import 'package:marketlens360mobile/data/models/earnings.dart';
import 'package:marketlens360mobile/data/models/price_history.dart';
import 'package:marketlens360mobile/data/models/security.dart';
import 'package:marketlens360mobile/data/models/security_metrics.dart';
import 'package:marketlens360mobile/data/providers/repository_providers.dart';
import 'package:marketlens360mobile/data/repositories/security_repository.dart';

final stockDetailProvider =
    ChangeNotifierProvider.family<StockDetailNotifier, String>((ref, symbol) {
  final notifier = StockDetailNotifier(
    ref.read(securityRepositoryProvider),
    ref.read(appDatabaseProvider),
    symbol,
  );
  Future.microtask(notifier.load);
  return notifier;
});

class StockDetailNotifier extends ChangeNotifier {
  StockDetailNotifier(this._repo, this._db, this._symbol);

  final SecurityRepository _repo;
  final AppDatabase _db;
  final String _symbol;

  bool _isLoading = false;
  bool _isHistoryLoading = false;
  String? _error;
  bool _disposed = false;

  SecuritySummary? _summary;
  List<PriceHistory> _priceHistory = [];
  String _period = '1M';

  bool get isLoading => _isLoading;
  bool get isHistoryLoading => _isHistoryLoading;
  String? get error => _error;
  SecuritySummary? get summary => _summary;
  List<PriceHistory> get priceHistory => _priceHistory;
  String get period => _period;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      final results = await Future.wait([
        _repo.getSecuritySummary(_symbol),
        _repo.getPriceHistory(_symbol, period: _period),
      ]);
      if (_disposed) return;
      _summary      = results[0] as SecuritySummary;
      _priceHistory = results[1] as List<PriceHistory>;
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

  Future<void> setPeriod(String period) async {
    if (_disposed || _period == period) return;
    _period = period;
    _isHistoryLoading = true;
    _notifyListeners();
    try {
      _priceHistory = await _repo.getPriceHistory(_symbol, period: period);
      if (_disposed) return;
    } catch (_) {
      // Silently fail history load; keep existing data
    } finally {
      if (!_disposed) {
        _isHistoryLoading = false;
        _notifyListeners();
      }
    }
  }

  Future<void> refresh() async {
    _summary = null;
    _priceHistory = [];
    _isLoading = false;
    await load();
  }

  // ── Watchlist helpers ──────────────────────────────────────────────────────

  Stream<bool> isInWatchlistStream(String symbol) =>
      _db.isInWatchlist(symbol);

  Future<void> addToWatchlist(String symbol) =>
      _db.addToWatchlist(symbol);

  Future<void> removeFromWatchlist(String symbol) =>
      _db.removeFromWatchlist(symbol);

  void _notifyListeners() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

// ── Secondary providers for sub-tabs (FutureProvider.family) ──────────────────
// These are simple, read-only providers used by OverviewTab, FinancialsTab,
// and DividendsTab. They remain as FutureProvider.family since they have no
// mutation and can be refreshed via ref.invalidate().

final stockMetricsProvider =
    FutureProvider.family<SecurityMetrics, String>((ref, symbol) {
  return ref.watch(securityRepositoryProvider).getMetrics(symbol);
});

final earningsProvider =
    FutureProvider.family<List<Earnings>, String>((ref, symbol) {
  return ref.watch(securityRepositoryProvider).getEarnings(symbol);
});

final dividendsProvider =
    FutureProvider.family<List<Dividend>, String>((ref, symbol) {
  return ref.watch(securityRepositoryProvider).getDividends(symbol);
});
