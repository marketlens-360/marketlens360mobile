import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:marketlens360mobile/data/models/market_index.dart';
import 'package:marketlens360mobile/data/models/market_overview.dart';
import 'package:marketlens360mobile/data/models/security.dart';
import 'package:marketlens360mobile/data/providers/repository_providers.dart';
import 'package:marketlens360mobile/data/repositories/security_repository.dart';

final homeProvider = ChangeNotifierProvider<HomeNotifier>((ref) {
  final notifier = HomeNotifier(ref.read(securityRepositoryProvider));
  Future.microtask(notifier.load);
  return notifier;
});

class HomeNotifier extends ChangeNotifier {
  HomeNotifier(this._repo);

  final SecurityRepository _repo;

  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  MarketOverview? _overview;
  List<MarketIndex> _indices = [];
  List<Security> _gainers = [];
  List<Security> _losers = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  MarketOverview? get overview => _overview;
  List<MarketIndex> get indices => _indices;
  List<Security> get gainers => _gainers;
  List<Security> get losers => _losers;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      final results = await Future.wait([
        _repo.getMarketOverview(),
        _repo.getIndices(),
        _repo.getTopGainers(limit: 5),
        _repo.getTopLosers(limit: 5),
      ]);
      if (_disposed) return;
      _overview = results[0] as MarketOverview;
      _indices  = results[1] as List<MarketIndex>;
      _gainers  = results[2] as List<Security>;
      _losers   = results[3] as List<Security>;
      _error    = null;
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
