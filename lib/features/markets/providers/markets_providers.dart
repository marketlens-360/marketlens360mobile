import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:marketlens360mobile/data/models/security.dart';
import 'package:marketlens360mobile/data/providers/repository_providers.dart';
import 'package:marketlens360mobile/data/repositories/security_repository.dart';

final marketsProvider = ChangeNotifierProvider<MarketsNotifier>((ref) {
  final notifier = MarketsNotifier(ref.read(securityRepositoryProvider));
  Future.microtask(notifier.load);
  return notifier;
});

class MarketsNotifier extends ChangeNotifier {
  MarketsNotifier(this._repo);

  final SecurityRepository _repo;

  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  List<Security> _securities = [];
  String _searchQuery = '';
  String? _selectedSector;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedSector => _selectedSector;

  List<String> get availableSectors {
    return _securities
        .map((s) => s.sector)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
  }

  List<Security> get filteredSecurities {
    var result = _securities;
    if (_selectedSector != null) {
      result = result.where((s) => s.sector == _selectedSector).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((s) {
        return s.symbol.toLowerCase().contains(q) ||
            (s.name?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    return result;
  }

  void setSearchQuery(String q) {
    if (_disposed) return;
    _searchQuery = q;
    _notifyListeners();
  }

  void setSector(String? sector) {
    if (_disposed) return;
    _selectedSector = sector;
    _notifyListeners();
  }

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      _securities = await _repo.getSecurities();
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
