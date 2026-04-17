import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:marketlens360mobile/data/models/fund.dart';
import 'package:marketlens360mobile/data/models/fund_performance.dart';
import 'package:marketlens360mobile/data/models/fund_ranking.dart';
import 'package:marketlens360mobile/data/providers/repository_providers.dart';
import 'package:marketlens360mobile/data/repositories/fund_repository.dart';

// ── Funds list + market stats ─────────────────────────────────────────────────

final fundsProvider = ChangeNotifierProvider<FundsNotifier>((ref) {
  final notifier = FundsNotifier(ref.read(fundRepositoryProvider));
  Future.microtask(notifier.load);
  return notifier;
});

class FundsNotifier extends ChangeNotifier {
  FundsNotifier(this._repo);

  final FundRepository _repo;

  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  List<Fund> _funds = [];
  FundMarketStats? _marketStats;
  FundCategory? _selectedCategory;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Fund> get funds => _funds;
  FundMarketStats? get marketStats => _marketStats;
  FundCategory? get selectedCategory => _selectedCategory;

  void setCategory(FundCategory? category) {
    if (_disposed) return;
    _selectedCategory = category;
    _funds = [];        // clear stale list so shimmer shows
    _isLoading = false; // reset guard so load() proceeds
    load();             // sets _isLoading=true + notifies → shimmer
  }

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      _funds = await _repo.getFunds(category: _selectedCategory);
      if (_disposed) return;
      _error = null;
      // Market stats are supplementary — a failure should not block the list.
      try {
        _marketStats = await _repo.getFundMarketStats();
      } catch (_) {
        // Non-critical; UI degrades gracefully without it.
      }
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

  Future<void> refresh() async {
    _isLoading = false;
    await load();
  }

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

// ── Fund detail (keyed by fundId) ─────────────────────────────────────────────

final fundDetailProvider =
    ChangeNotifierProvider.family<FundDetailNotifier, int>((ref, fundId) {
  final notifier = FundDetailNotifier(ref.read(fundRepositoryProvider), fundId);
  Future.microtask(notifier.load);
  return notifier;
});

class FundDetailNotifier extends ChangeNotifier {
  FundDetailNotifier(this._repo, this._fundId);

  final FundRepository _repo;
  final int _fundId;

  // Start as true so the first render immediately shows the shimmer.
  // _firstLoad lets the scheduled microtask bypass the concurrent-load guard.
  bool _isLoading = true;
  bool _firstLoad = true;
  String? _error;
  bool _disposed = false;

  Fund? _fund;
  List<MonthlyPerformance> _monthlyPerf = [];
  List<YearlyPerformance> _yearlyPerf = [];
  List<PortfolioHolding> _holdings = [];
  FundRankingDetail? _rank;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Fund? get fund => _fund;
  List<MonthlyPerformance> get monthlyPerf => _monthlyPerf;
  List<YearlyPerformance> get yearlyPerf => _yearlyPerf;
  List<PortfolioHolding> get holdings => _holdings;
  FundRankingDetail? get rank => _rank;

  Future<void> load() async {
    // Allow the initial microtask call through (_firstLoad=true), but block
    // any concurrent duplicate call that arrives while already loading.
    if (_isLoading && !_firstLoad) return;
    _firstLoad = false;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      // Only the fund itself is required — everything else is supplementary.
      _fund = await _repo.getFundById(_fundId);
      if (_disposed) return;
      _error = null;
      // Fire supplementary calls in parallel; individual failures are swallowed.
      await Future.wait([
        _repo.getMonthlyPerformance(_fundId, months: 12)
            .then((v) { if (!_disposed) _monthlyPerf = v; })
            .catchError((_) {}),
        _repo.getYearlyPerformance(_fundId)
            .then((v) { if (!_disposed) _yearlyPerf = v; })
            .catchError((_) {}),
        _repo.getPortfolioHoldings(_fundId)
            .then((v) { if (!_disposed) _holdings = v; })
            .catchError((_) {}),
        _repo.getFundRank(_fundId)
            .then((v) { if (!_disposed) _rank = v; })
            .catchError((_) {}),
      ]);
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

  Future<void> refresh() async {
    _fund = null;
    _isLoading = false;
    await load();
  }

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
