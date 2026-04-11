# MarketLens360 Mobile — State Management Guide

## Pattern: ChangeNotifier + ChangeNotifierProvider

All feature state is managed with `ChangeNotifier` classes exposed via Riverpod's
`ChangeNotifierProvider`. This gives explicit, synchronous state reads and eliminates
the need for `.when()` / `AsyncValue` throughout the UI.

---

## 1. Notifier Template

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // required for ChangeNotifierProvider

final xProvider = ChangeNotifierProvider<XNotifier>((ref) {
  final notifier = XNotifier(ref.read(someDependencyProvider));
  Future.microtask(notifier.load); // deferred so notifyListeners() doesn't fire during build
  return notifier;
});

class XNotifier extends ChangeNotifier {
  XNotifier(this._dep);

  final SomeDependency _dep;

  // ── State fields ──────────────────────────────────────────────────────────
  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  MyData? _data;

  // ── Public getters ────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  String? get error => _error;
  MyData? get data => _data;

  // ── Load ──────────────────────────────────────────────────────────────────
  Future<void> load() async {
    if (_isLoading) return;          // loading guard
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      _data = await _dep.fetchData();
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
    _isLoading = false;   // reset guard so load() proceeds
    await load();
  }

  // ── Safe notify ───────────────────────────────────────────────────────────
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
```

### Key rules

| Rule | Rationale |
|------|-----------|
| `if (_isLoading) return;` at top of `load()` | Prevents concurrent duplicate loads |
| Check `if (_disposed) return;` after every `await` | Guards against post-dispose state mutation |
| `_notifyListeners()` wrapper (not direct `notifyListeners()`) | Always safe to call; silently skips after dispose |
| `..load()` in the provider factory | Triggers initial data fetch immediately |

---

## 2. Family Providers (keyed state)

Use `ChangeNotifierProvider.family` when the notifier is keyed by a parameter
(e.g., a fund ID or stock symbol):

```dart
final fundDetailProvider =
    ChangeNotifierProvider.family<FundDetailNotifier, int>((ref, fundId) {
  final notifier = FundDetailNotifier(ref.read(fundRepositoryProvider), fundId);
  Future.microtask(notifier.load);
  return notifier;
});
```

Access in UI:

```dart
final detail = ref.watch(fundDetailProvider(fundId));
ref.read(fundDetailProvider(fundId)).refresh();
```

---

## 3. UI Consumption Pattern

All screens use `ConsumerWidget` or `ConsumerStatefulWidget` (never plain
`StatelessWidget` / `StatefulWidget` for screens that read providers).

### ConsumerWidget (read-only screens)

```dart
class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(xProvider);
    // ...
  }
}
```

### ConsumerStatefulWidget (screens with local mutable state)

```dart
class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(xProvider);
    // ...
  }
}
```

---

## 4. Loading / Error / Success in UI

Replace `.when(loading:, error:, data:)` with explicit `if` checks:

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final notifier = ref.watch(xProvider);

  if (notifier.isLoading && notifier.data == null) {
    return const ShimmerList(itemCount: 8);
  }

  if (notifier.error != null && notifier.data == null) {
    return AppErrorView(
      error: notifier.error!,
      onRetry: () => ref.read(xProvider).refresh(),
    );
  }

  final data = notifier.data;
  if (data == null) return const SizedBox.shrink();

  return _buildContent(data);
}
```

> **Tip:** Show stale data with a loading overlay rather than replacing the whole
> screen. Check `notifier.isLoading && notifier.data != null` to detect a
> background refresh.

---

## 5. Triggering Actions

Always use `ref.read(...)` (not `ref.watch(...)`) inside callbacks:

```dart
// Correct
onPressed: () => ref.read(marketsProvider).setSearchQuery(value),
onRefresh: () => ref.read(fundsProvider).refresh(),

// Wrong — causes unnecessary rebuilds
onPressed: () => ref.watch(marketsProvider).setSearchQuery(value),
```

---

## 6. Database Stream Integration (Watchlist pattern)

When a notifier must react to a local database stream (Drift), subscribe inside
`initialize()` and cancel in `dispose()`:

```dart
class WatchlistNotifier extends ChangeNotifier {
  StreamSubscription<List<WatchlistTableData>>? _sub;

  void initialize() {
    _sub = _db.getWatchlist().listen((rows) {
      _loadSecurities(rows.map((r) => r.symbol).toList());
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _sub?.cancel();
    super.dispose();
  }
}
```

For one-shot stream reads in the UI (e.g., `isInWatchlist`), use `StreamBuilder`:

```dart
StreamBuilder<bool>(
  stream: ref.read(stockDetailProvider(symbol)).isInWatchlistStream(symbol),
  builder: (context, snapshot) {
    final isIn = snapshot.data ?? false;
    return IconButton(
      icon: Icon(isIn ? Icons.bookmark : Icons.bookmark_border),
      onPressed: () { /* ... */ },
    );
  },
)
```

---

## 7. Providers to Keep as-is

These providers are **not** part of the ChangeNotifier refactor and must remain
unchanged:

| Provider | File | Reason |
|----------|------|--------|
| `authStateProvider` | `services/auth_service.dart` | `StreamProvider<User?>` — drives router redirect |
| `authServiceProvider` | `services/auth_service.dart` | Plain `Provider<AuthService>` |
| `appDatabaseProvider` | `data/local/app_database.dart` | Plain `Provider<AppDatabase>` |
| `securityRepositoryProvider` | `data/providers/repository_providers.dart` | Plain `Provider<SecurityRepository>` |
| `fundRepositoryProvider` | `data/providers/repository_providers.dart` | Plain `Provider<FundRepository>` |

---

## 8. File Map

| Feature | Provider file | Notifier class(es) |
|---------|---------------|--------------------|
| Auth | `features/auth/providers/auth_providers.dart` | `AuthNotifier` |
| Home | `features/home/providers/home_providers.dart` | `HomeNotifier` |
| Markets | `features/markets/providers/markets_providers.dart` | `MarketsNotifier` |
| Funds | `features/funds/providers/funds_providers.dart` | `FundsNotifier`, `FundDetailNotifier` |
| Stock detail | `features/stock_detail/providers/stock_detail_providers.dart` | `StockDetailNotifier` |
| Watchlist | `features/watchlist/providers/watchlist_providers.dart` | `WatchlistNotifier` |
| Profile | `features/profile/providers/profile_providers.dart` | `ProfileNotifier` |
