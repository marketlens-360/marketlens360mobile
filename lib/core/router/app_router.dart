import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/widgets/app_shell.dart';
import 'package:marketlens360mobile/features/auth/presentation/login_screen.dart';
import 'package:marketlens360mobile/features/auth/presentation/forgot_password_screen.dart';
import 'package:marketlens360mobile/features/auth/presentation/register_screen.dart';
import 'package:marketlens360mobile/features/funds/presentation/fund_detail_screen.dart';
import 'package:marketlens360mobile/features/funds/presentation/funds_screen.dart';
import 'package:marketlens360mobile/features/home/presentation/home_screen.dart';
import 'package:marketlens360mobile/features/ai_chat/presentation/ai_chat_screen.dart';
import 'package:marketlens360mobile/features/markets/presentation/markets_screen.dart';
import 'package:marketlens360mobile/features/profile/presentation/profile_screen.dart';
import 'package:marketlens360mobile/features/profile/presentation/settings_screen.dart';
import 'package:marketlens360mobile/features/stock_detail/presentation/stock_detail_screen.dart';
import 'package:marketlens360mobile/services/auth_service.dart';
import 'app_routes.dart';

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(Stream<User?> stream) {
    _sub = stream.listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _sub;
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authService  = ref.watch(authServiceProvider);
  final authNotifier = _AuthNotifier(authService.authStateChanges);
  ref.onDispose(authNotifier.dispose);

  final router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      if (authNotifier.isLoading) return null;

      final isLoggedIn  = authNotifier.user != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.forgotPassword;
      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      if (isLoggedIn && isAuthRoute) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.login,          builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.register,       builder: (_, __) => const RegisterScreen()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.stocks,
            builder: (_, __) => const MarketsScreen(),
            routes: [
              GoRoute(
                path: ':symbol',
                builder: (_, state) => StockDetailScreen(
                  symbol: state.pathParameters['symbol']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.funds,
            builder: (_, __) => const FundsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) => FundDetailScreen(
                  fundId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.aiChat,
            builder: (_, __) => const AiChatScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => const SettingsScreen(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
