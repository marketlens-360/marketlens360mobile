import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/icon_service.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/gradient_badge.dart';
import '../widgets/initials_avatar.dart';


// ── Drawer ────────────────────────────────────────────────────────────────────
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c        = AppColors.of(context);
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final location = GoRouterState.of(context).matchedLocation;
    final userAsync = ref.watch(authStateProvider);

    final user        = userAsync.value;
    final displayName = user?.displayName ?? 'MarketLens User';
    final email       = user?.email ?? '';
    final photoUrl    = user?.photoURL;
    final initials    = _initials(displayName);

    return Drawer(
      backgroundColor: isDark ? c.surface : c.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // ── Gradient header (tappable → profile) ─────────────────────────
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              context.push(AppRoutes.profile);
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: c.heroGradient,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Identity row ────────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(25),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withAlpha(90),
                                width: 1.5,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: photoUrl != null
                                ? Image.network(
                                    photoUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        InitialsAvatar(initials: initials),
                                  )
                                : InitialsAvatar(initials: initials),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: AppTextStyles.titleSm.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (email.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    email,
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white.withAlpha(170),
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GradientBadge(label: 'PRO'),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── Nav links ────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 8),
                  child: Divider(color: c.border, height: 1),
                ),

                _DrawerItem(
                  icon: IconService.profile,
                  label: 'Profile',
                  isActive: location.startsWith(AppRoutes.profile),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(AppRoutes.profile);
                  },
                ),
                _DrawerItem(
                  icon: IconService.settings,
                  label: 'Settings',
                  isActive: location.startsWith(AppRoutes.settings),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(AppRoutes.settings);
                  },
                ),
                _DrawerItem(
                  icon: IconService.help,
                  label: 'Help & Support',
                  isActive: false,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // ── Footer ───────────────────────────────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/marketlens_logo_no_background.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'MarketLens',
                          style: AppTextStyles.titleSm.copyWith(
                            color: c.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: -0.3,
                          ),
                        ),
                        TextSpan(
                          text: '360',
                          style: AppTextStyles.titleSm.copyWith(
                            color: c.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'v1.0.0',
                    style: AppTextStyles.caption.copyWith(
                      color: c.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ── Drawer item ───────────────────────────────────────────────────────────────
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
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: isActive ? c.primary.withAlpha(18) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(
              color: isActive ? c.primary.withAlpha(40) : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // Icon box
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: c.primary.withAlpha(isActive ? 35 : 18),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(icon, size: 17, color: c.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.labelMd.copyWith(
                    color: isActive ? c.primary : c.textPrimary,
                    fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              if (isActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: c.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
