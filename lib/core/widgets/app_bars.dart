import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/providers/scaffold_providers.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

// ── Shared shadow / divider decoration ────────────────────────────────────────
BoxShadow _appBarShadow(bool isDark) => BoxShadow(
      color: isDark
          ? Colors.black.withAlpha(60)
          : Colors.black.withAlpha(22),
      blurRadius: 12,
      offset: const Offset(0, 3),
    );

/// App bar used on the four main tab screens (Home, Stocks, Funds, AI Chat).
/// Shows the MarketLens360 logo, a drawer-open icon, notification bell and
/// avatar that navigates to Profile.
class AppShellBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppShellBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _ShadowedBar(
      isDark: isDark,
      child: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: c.border, height: 1),
        ),
        leading: IconButton(
          icon: Icon(IconService.menu, size: 22, color: c.primary),
          onPressed: () =>
              ref.read(shellScaffoldKeyProvider).currentState?.openDrawer(),
        ),
        titleSpacing: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'MarketLens',
                style: AppTextStyles.titleMd.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: '360',
                style: AppTextStyles.titleMd.copyWith(
                  color: c.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              IconService.notifications,
              size: 20,
              color: c.textSecondary,
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.profile),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: c.primaryDim,
                child: Icon(IconService.profile, size: 18, color: c.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// App bar used on detail / settings screens (Stock Detail, Profile, etc.).
/// Shows a back arrow, the screen title, and optional trailing actions.
class AppDetailBar extends StatelessWidget implements PreferredSizeWidget {
  const AppDetailBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _ShadowedBar(
      isDark: isDark,
      child: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: c.border, height: 1),
        ),
        leading: IconButton(
          icon: Icon(IconService.back, size: 22, color: c.textSecondary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        titleSpacing: 0,
        title: Text(
          title,
          style: AppTextStyles.screenTitle.copyWith(color: c.textPrimary),
        ),
        actions: actions,
      ),
    );
  }
}

// ── Internal: wraps an AppBar in a shadow container ───────────────────────────
class _ShadowedBar extends StatelessWidget {
  const _ShadowedBar({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [_appBarShadow(isDark)],
      ),
      child: child,
    );
  }
}
