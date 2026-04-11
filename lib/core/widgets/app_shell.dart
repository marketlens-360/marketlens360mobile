import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    AppRoutes.home,
    AppRoutes.stocks,
    AppRoutes.funds,
    AppRoutes.aiChat,
  ];

  static const _icons = [
    IconService.home,
    IconService.stocks,
    IconService.funds,
    IconService.aiChat,
  ];

  static const _labels = ['Home', 'Stocks', 'Funds', 'AI Chat'];

  int _currentIndex(String location) {
    for (int i = _tabs.length - 1; i >= 0; i--) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location     = GoRouterState.of(context).matchedLocation;
    final currentIndex = _currentIndex(location);
    final c            = AppColors.of(context);
    final isDark       = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: _AppDrawer(),
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? c.surface : c.surfaceContainerLowest,
          border: Border(top: BorderSide(color: c.border, width: 1)),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final isActive = i == currentIndex;
                return Expanded(
                  child: _NavItem(
                    icon: _icons[i],
                    label: _labels[i],
                    isActive: isActive,
                    activeColor: c.primary,
                    inactiveColor: c.textMuted,
                    showTopIndicator: isActive,
                    onTap: () {
                      if (!isActive) context.go(_tabs[i]);
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Nav item ──────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
    this.showTopIndicator = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;
  final bool showTopIndicator;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        children: [
          // Top indicator line when active
          if (showTopIndicator)
            Positioned(
              top: 0,
              left: 12,
              right: 12,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(2),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: isActive
                      ? BoxDecoration(
                          color: activeColor.withAlpha(18),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                        )
                      : null,
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: color,
                    letterSpacing: 0.6,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Drawer ────────────────────────────────────────────────────────────────────
class _AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final location = GoRouterState.of(context).matchedLocation;

    return Drawer(
      backgroundColor: isDark ? c.surface : c.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── User header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: c.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: c.border),
                    ),
                    child: Icon(IconService.profile, size: 26, color: c.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Financial Architect',
                          style: AppTextStyles.titleSm.copyWith(color: c.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: c.primaryDim,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            border: Border.all(color: c.primary.withAlpha(40)),
                          ),
                          child: Text(
                            'PREMIUM TIER',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: c.primary,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Verified Account',
                          style: AppTextStyles.caption.copyWith(color: c.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Divider(color: c.border, height: 1),
            const SizedBox(height: 8),

            // ── Nav links ────────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                children: [
                  _DrawerItem(
                    icon: IconService.marketOverview,
                    label: 'Market Overview',
                    isActive: location == AppRoutes.home,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go(AppRoutes.home);
                    },
                  ),
                  _DrawerItem(
                    icon: IconService.watchlist,
                    label: 'Watchlist',
                    isActive: false,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _DrawerItem(
                    icon: IconService.education,
                    label: 'Investor Education',
                    isActive: false,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _DrawerItem(
                    icon: IconService.settings,
                    label: 'Settings',
                    isActive: location == AppRoutes.profile,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go(AppRoutes.profile);
                    },
                  ),
                  _DrawerItem(
                    icon: IconService.help,
                    label: 'Help',
                    isActive: false,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // ── Footer ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Platform strength bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: c.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: c.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PLATFORM STRENGTH',
                          style: AppTextStyles.sectionLabel.copyWith(
                            color: c.textMuted,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.85,
                            backgroundColor: c.border,
                            color: c.primary,
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'MarketLens360',
                    style: AppTextStyles.titleSm.copyWith(color: c.primary),
                  ),
                  Text(
                    'Precision Financial Observation',
                    style: AppTextStyles.caption.copyWith(color: c.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'v2.4.0 • Enterprise Edition',
                    style: AppTextStyles.caption.copyWith(
                      color: c.textDisabled, fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? c.primaryDim : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: isActive
                ? Border.all(color: c.primary.withAlpha(30))
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? c.primary : c.textSecondary,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: AppTextStyles.labelMd.copyWith(
                  color: isActive ? c.primary : c.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
