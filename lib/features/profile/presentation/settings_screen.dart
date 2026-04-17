import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/providers/theme_providers.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_bars.dart';
import 'package:marketlens360mobile/features/auth/providers/auth_providers.dart';
import 'package:marketlens360mobile/features/profile/providers/profile_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isTerminating = false;

  @override
  Widget build(BuildContext context) {
    final c         = AppColors.of(context);
    final profile   = ref.watch(profileProvider);
    final authUser  = ref.watch(authStateProvider).value;
    final themeMode = ref.watch(themeModeProvider);
    final isDark    = themeMode.isDark ||
        (themeMode.mode == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      backgroundColor: c.surfaceContainerLowest,
      appBar: const AppDetailBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        children: [
          const SizedBox(height: AppSpacing.lg),

          // ── System header card ────────────────────────────────────────────
          _HeaderCard(packageInfo: profile.packageInfo),

          const SizedBox(height: AppSpacing.xl),

          // ── Visual environment ────────────────────────────────────────────
          const _SectionLabel('VISUAL ENVIRONMENT'),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              // Theme toggle — kept as switch tile per requirement
              _ToggleRow(
                icon: isDark ? LucideIcons.moon : Icons.light_mode_outlined,
                label: 'Appearance',
                subtitle: isDark ? 'Dark mode active' : 'Light mode active',
                value: isDark,
                onChanged: (v) => ref
                    .read(themeModeProvider)
                    .setMode(v ? ThemeMode.dark : ThemeMode.light),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Alert intelligence ────────────────────────────────────────────
          const _SectionLabel('ALERT INTELLIGENCE'),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              _ToggleRow(
                icon: LucideIcons.bell,
                label: 'Market Health',
                subtitle: 'Volatility and trend triggers',
                value: profile.pushNotificationsEnabled,
                onChanged: (v) =>
                    ref.read(profileProvider).setPushNotifications(v),
              ),
              const _RowDivider(),
              _ToggleRow(
                icon: LucideIcons.clock,
                label: 'Data Delay Disclaimer',
                subtitle: 'Show "Delayed 15 min" on prices',
                value: profile.delayedDataDisclaimer,
                onChanged: (v) =>
                    ref.read(profileProvider).setDelayedDataDisclaimer(v),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Vault & security ──────────────────────────────────────────────
          const _SectionLabel('VAULT & SECURITY'),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              _ToggleRow(
                icon: Icons.fingerprint,
                label: 'Biometric Authentication',
                subtitle: 'FaceID or TouchID enabled',
                value: profile.biometricLoginEnabled,
                onChanged: (v) =>
                    ref.read(profileProvider).setBiometricLogin(v),
              ),
              const _RowDivider(),
              _NavRow(
                icon: LucideIcons.shield,
                label: 'Privacy Guard',
                subtitle: 'Manage data permissions',
              ),
            ],
          ),

          if (authUser != null) ...[
            const SizedBox(height: AppSpacing.xl),

            // ── App info ──────────────────────────────────────────────────
            const _SectionLabel('APP'),
            const SizedBox(height: AppSpacing.sm),
            _SectionCard(
              children: [
                _ActionTileRow(
                  icon: LucideIcons.hash,
                  label: 'Account ID',
                  subtitle: '${authUser.uid.substring(0, 8)}…',
                  trailingLabel: 'COPY',
                  trailingColor: c.primary,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: authUser.uid));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('UID copied',
                            style: TextStyle(color: c.textPrimary)),
                        backgroundColor: c.surface,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],

          const SizedBox(height: AppSpacing.xxl),

          // ── Terminate session ─────────────────────────────────────────────
          _TerminateButton(
            isLoading: _isTerminating,
            onTap: () => _signOut(context),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Footer ────────────────────────────────────────────────────────
          const _Footer(),

          const SizedBox(height: AppSpacing.xxl * 2),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    setState(() => _isTerminating = true);
    try {
      await ref.read(authServiceProvider).signOut();
      // ignore: use_build_context_synchronously
      if (mounted) context.go(AppRoutes.login);
    } finally {
      if (mounted) setState(() => _isTerminating = false);
    }
  }
}

// ── Header card ────────────────────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({this.packageInfo});

  final dynamic packageInfo; // PackageInfo?

  @override
  Widget build(BuildContext context) {
    final c       = AppColors.of(context);
    final version = packageInfo?.version as String? ?? '2.4.8';
    final build   = packageInfo?.buildNumber as String? ?? '';

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Stack(
        children: [
          // Decorative watermark
          Positioned(
            right: -18,
            top: -18,
            child: Icon(
              LucideIcons.landmark,
              size: 120,
              color: Colors.white.withAlpha(18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SYSTEM PREFERENCES',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: Colors.white.withAlpha(160),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'MarketLens 360',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Build v$version${build.isNotEmpty ? ' ($build)' : ''} • Global Protocol',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withAlpha(180),
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

// ── Row types ──────────────────────────────────────────────────────────────────

/// Toggle row — icon box + label/subtitle + Switch (kept as switch tile)
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          _IconBox(icon: icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.labelMd.copyWith(
                        color: c.textPrimary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: AppTextStyles.labelSm
                        .copyWith(color: c.textMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: c.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

/// Navigation row — icon box + label/subtitle + chevron
class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            _IconBox(icon: icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.labelMd.copyWith(
                          color: c.textPrimary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: AppTextStyles.labelSm
                          .copyWith(color: c.textMuted)),
                ],
              ),
            ),
            Icon(LucideIcons.chevron_right, size: 16, color: c.textMuted),
          ],
        ),
      ),
    );
  }
}

/// Action row — icon box + label/subtitle + labelled action button
class _ActionTileRow extends StatelessWidget {
  const _ActionTileRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.trailingLabel,
    required this.trailingColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final String trailingLabel;
  final Color trailingColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            _IconBox(icon: icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.labelMd.copyWith(
                          color: c.textPrimary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: AppTextStyles.labelSm
                          .copyWith(color: c.textMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: trailingColor.withAlpha(18),
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: trailingColor.withAlpha(60)),
              ),
              child: Text(
                trailingLabel,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: trailingColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared layout widgets ──────────────────────────────────────────────────────

/// Rounded square icon container (primary blue bg, white icon)
class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, this.bgColor, this.iconColor});

  final IconData icon;
  final Color? bgColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor ?? c.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Icon(icon, size: 20, color: iconColor ?? Colors.white),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? c.surface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: c.border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Text(
      label,
      style: AppTextStyles.sectionLabel.copyWith(
        color: c.textMuted,
        letterSpacing: 1.0,
        fontSize: 10,
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.of(context).border,
      height: 1,
      indent: AppSpacing.lg + 40 + 14,
    );
  }
}

// ── Terminate button ───────────────────────────────────────────────────────────

class _TerminateButton extends StatelessWidget {
  const _TerminateButton({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: c.priceDownDim,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: c.priceDown.withAlpha(80)),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: c.priceDown),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.log_out, size: 16, color: c.priceDown),
                  const SizedBox(width: 10),
                  Text(
                    'Terminate Session',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: c.priceDown,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Footer ─────────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Column(
      children: [
        Text(
          'MARKETLENS 360 • SECURED BY KINETIC PROTOCOL',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            color: c.textDisabled,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'COPYRIGHT © 2024 • ALL RIGHTS RESERVED',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            color: c.textDisabled,
          ),
        ),
      ],
    );
  }
}
