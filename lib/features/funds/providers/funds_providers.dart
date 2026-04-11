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
  String _sort = 'return_1y';

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Fund> get funds => _funds;
  FundMarketStats? get marketStats => _marketStats;
  FundCategory? get selectedCategory => _selectedCategory;
  String get sort => _sort;

  void setCategory(FundCategory? category) {
    if (_disposed) return;
    _selectedCategory = category;
    _isLoading = false;
    _notifyListeners();
    load();
  }

  void setSort(String sort) {
    if (_disposed) return;
    _sort = sort;
    _isLoading = false;
    _notifyListeners();
    load();
  }

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      final results = await Future.wait([
        _repo.getFunds(category: _selectedCategory, sort: _sort),
        _repo.getFundMarketStats(),
      ]);
      if (_disposed) return;
      _funds       = results[0] as List<Fund>;
      _marketStats = results[1] as FundMarketStats;
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

  bool _isLoading = false;
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
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      final results = await Future.wait([
        _repo.getFundById(_fundId),
        _repo.getMonthlyPerformance(_fundId, months: 12),
        _repo.getYearlyPerformance(_fundId),
        _repo.getPortfolioHoldings(_fundId),
        _repo.getFundRank(_fundId),
      ]);
      if (_disposed) return;
      _fund        = results[0] as Fund;
      _monthlyPerf = results[1] as List<MonthlyPerformance>;
      _yearlyPerf  = results[2] as List<YearlyPerformance>;
      _holdings    = results[3] as List<PortfolioHolding>;
      _rank        = results[4] as FundRankingDetail;
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
