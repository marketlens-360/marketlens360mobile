import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_bars.dart';
import 'package:marketlens360mobile/features/auth/providers/auth_providers.dart';
import 'package:marketlens360mobile/features/profile/providers/profile_providers.dart';
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    final c        = AppColors.of(context);
    final authUser = ref.watch(authStateProvider).value;
    final profile  = ref.watch(profileProvider);

    if (authUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isEmailProvider = authUser.providerData.any((p) => p.providerId == 'password');
    final initials        = _initials(authUser);
    final version          = profile.packageInfo?.version;
    final build            = profile.packageInfo?.buildNumber;

    return Scaffold(
      backgroundColor: c.surfaceContainerLowest,
      appBar: AppDetailBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, size: 20, color: c.textSecondary),
            onPressed: () => _showEditNameSheet(context, authUser, c),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        children: [
          const SizedBox(height: AppSpacing.lg),

          // ── Hero card ─────────────────────────────────────────────────────
          _HeroCard(
            user: authUser,
            initials: initials,
            onEditTap: () => _showEditNameSheet(context, authUser, c),
          ),


          const SizedBox(height: AppSpacing.xl),

          // ── Security ──────────────────────────────────────────────────────
          const _SectionLabel('SECURITY'),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              if (isEmailProvider) ...[
                _NavRow(
                  icon: LucideIcons.lock,
                  iconBgColor: c.tertiary,
                  label: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () => _showChangePasswordSheet(context, authUser, c),
                ),
                const _RowDivider(),
                if (!authUser.emailVerified) ...[
                  _NavRow(
                    icon: LucideIcons.mail,
                    iconBgColor: c.tertiary,
                    label: 'Resend Verification Email',
                    subtitle: 'Check your inbox for the link',
                    onTap: () => _sendVerification(authUser),
                  ),
                  const _RowDivider(),
                ],
              ],
              _ToggleRow(
                icon: Icons.fingerprint,
                label: 'Biometric Login',
                subtitle: 'Face ID & Touch ID',
                value: profile.biometricLoginEnabled,
                onChanged: (v) =>
                    ref.read(profileProvider).setBiometricLogin(v),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Settings nav ──────────────────────────────────────────────────
          const _SectionLabel('PREFERENCES'),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              _NavRow(
                icon: LucideIcons.settings,
                label: 'App Settings',
                subtitle: 'Theme, notifications, data',
                onTap: () => context.push(AppRoutes.settings),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xxl),

          // ── Sign out ──────────────────────────────────────────────────────
          _SignOutCard(
            isLoading: _isSigningOut,
            onTap: () => _signOut(context),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Footer ────────────────────────────────────────────────────────
          _ProfileFooter(version: version, buildNumber: build),

          const SizedBox(height: AppSpacing.xxl * 2),
        ],
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _signOut(BuildContext context) async {
    setState(() => _isSigningOut = true);
    try {
      await ref.read(authServiceProvider).signOut();
      // ignore: use_build_context_synchronously
      if (mounted) context.go(AppRoutes.login);
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  Future<void> _sendVerification(User user) async {
    try {
      await user.sendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _showEditNameSheet(BuildContext context, User user, AppColorsData c) {
    final ctrl = TextEditingController(text: user.displayName ?? '');
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: c.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          top: AppSpacing.lg,
          left: AppSpacing.screenH,
          right: AppSpacing.screenH,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Display Name',
                style: AppTextStyles.labelLg.copyWith(color: c.textPrimary)),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: ctrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Your name'),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: c.primary),
                onPressed: () async {
                  if (ctrl.text.trim().isNotEmpty) {
                    await user.updateDisplayName(ctrl.text.trim());
                    if (ctx.mounted) Navigator.pop(ctx);
                    ref.invalidate(authStateProvider);
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordSheet(
      BuildContext context, User user, AppColorsData c) {
    final currentCtrl = TextEditingController();
    final newCtrl     = TextEditingController();
    String? error;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: c.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
            top: AppSpacing.lg,
            left: AppSpacing.screenH,
            right: AppSpacing.screenH,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Change Password',
                  style: AppTextStyles.labelLg
                      .copyWith(color: c.textPrimary)),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: currentCtrl,
                obscureText: true,
                decoration:
                    const InputDecoration(hintText: 'Current password'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: newCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'New password (min 6 chars)'),
              ),
              if (error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(error!,
                    style: AppTextStyles.labelSm
                        .copyWith(color: c.priceDown)),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style:
                      FilledButton.styleFrom(backgroundColor: c.primary),
                  onPressed: () async {
                    if (newCtrl.text.length < 6) {
                      setSheetState(() => error =
                          'Password must be at least 6 characters');
                      return;
                    }
                    try {
                      final cred = EmailAuthProvider.credential(
                        email: user.email!,
                        password: currentCtrl.text,
                      );
                      await user.reauthenticateWithCredential(cred);
                      await user.updatePassword(newCtrl.text);
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Password updated')),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      setSheetState(() =>
                          error = e.message ?? 'Authentication failed');
                    }
                  },
                  child: const Text('Update Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(User user) {
    final name = user.displayName;
    if (name != null && name.isNotEmpty) {
      final parts = name.trim().split(' ');
      if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      return parts[0][0].toUpperCase();
    }
    if (user.email?.isNotEmpty == true) return user.email![0].toUpperCase();
    return '?';
  }
}

// ── Hero card ──────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.user,
    required this.initials,
    required this.onEditTap,
  });

  final User user;
  final String initials;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

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
            right: -20,
            top: -20,
            child: Icon(
              LucideIcons.circle_user,
              size: 130,
              color: Colors.white.withAlpha(15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 32, horizontal: AppSpacing.xl),
            child: Row(
              children: [
              Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar with edit button
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(30),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: user.photoURL != null
                          ? ClipOval(
                              child: Image.network(
                                user.photoURL!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _HeroInitials(initials),
                              ),
                            )
                          : _HeroInitials(initials),
                    ),
                    // Edit button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: onEditTap,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(LucideIcons.pencil,
                              size: 13, color: c.primary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Name
                Text(
                  user.displayName?.isNotEmpty == true
                      ? user.displayName!
                      : 'Investor',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),

                // Email
                Text(
                  user.email ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withAlpha(200),
                  ),
                ),
                const SizedBox(height: 16),

                // PREMIUM INVESTOR badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(28),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusPill),
                    border:
                        Border.all(color: Colors.white.withAlpha(70)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.check_circle_2,
                          size: 13, color: Colors.white),
                      const SizedBox(width: 7),
                      const Text(
                        'PREMIUM INVESTOR',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),           // Expanded + Column
            ],            // Row children
          ),              // Row
          ),              // Padding
        ],
      ),
    );
  }
}

class _HeroInitials extends StatelessWidget {
  const _HeroInitials(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Row types ──────────────────────────────────────────────────────────────────

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.iconBgColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color? iconBgColor;
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
            _IconBox(icon: icon, bgColor: iconBgColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.labelMd.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600)),
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

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.subtitleColor,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? subtitleColor;

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
                        .copyWith(color: subtitleColor ?? c.textMuted)),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

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
                Text(value,
                    style: AppTextStyles.labelSm
                        .copyWith(color: c.textMuted)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ── Sign out card ──────────────────────────────────────────────────────────────

class _SignOutCard extends StatelessWidget {
  const _SignOutCard({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isDark ? c.surface : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.log_out, size: 18, color: c.textPrimary),
                  const SizedBox(width: 10),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Footer ─────────────────────────────────────────────────────────────────────

class _ProfileFooter extends StatelessWidget {
  const _ProfileFooter({this.version, this.buildNumber});

  final String? version;
  final String? buildNumber;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    if (version == null) return const SizedBox.shrink();
    return Column(
      children: [
        Text(
          'VERSION $version${buildNumber != null && buildNumber!.isNotEmpty ? ' (BUILD $buildNumber)' : ''}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: c.textDisabled,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'MARKETLENS 360',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: c.primary,
          ),
        ),
      ],
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

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

class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.priceUpDim,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: c.priceUp.withAlpha(51)),
      ),
      child: Text(
        '✓ Verified',
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w600, color: c.priceUp),
      ),
    );
  }
}

class _UnverifiedBadge extends StatelessWidget {
  const _UnverifiedBadge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: c.priceDownDim,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(color: c.priceDown.withAlpha(51)),
        ),
        child: Text(
          'Verify →',
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w600, color: c.priceDown),
        ),
      ),
    );
  }
}
