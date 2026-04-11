import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/features/auth/providers/auth_providers.dart';
import 'package:marketlens360mobile/features/profile/providers/profile_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

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

    final isEmailProvider = authUser.providerData
        .any((p) => p.providerId == 'password');
    final isGoogleProvider = authUser.providerData
        .any((p) => p.providerId == 'google.com');

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        title: Text('Profile', style: AppTextStyles.screenTitle.copyWith(color: c.textPrimary)),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: c.border, height: 1),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── User header ─────────────────────────────────────────────────────
          _ProfileHeader(user: authUser),

          const SizedBox(height: AppSpacing.xl),

          // ── Account info ────────────────────────────────────────────────────
          _SectionLabel('ACCOUNT'),
          _InfoCard(
            children: [
              _InfoRow(
                icon: IconService.profile,
                label: 'Display Name',
                value: authUser.displayName?.isNotEmpty == true
                    ? authUser.displayName!
                    : '—',
                trailing: IconButton(
                  icon: Icon(_kEditIcon, size: 16, color: c.primary),
                  onPressed: () => _showEditNameSheet(context, authUser, c),
                ),
              ),
              _Divider(),
              _InfoRow(
                icon: IconService.bell,
                label: 'Email',
                value: authUser.email ?? '—',
                valueColor: c.textPrimary,
                trailing: authUser.emailVerified
                    ? _VerifiedBadge()
                    : _UnverifiedBadge(
                        onTap: () => _sendVerification(authUser),
                      ),
              ),
              if (authUser.metadata.creationTime != null) ...[
                _Divider(),
                _InfoRow(
                  icon: IconService.inbox,
                  label: 'Member Since',
                  value: _formatDate(authUser.metadata.creationTime!),
                ),
              ],
              _Divider(),
              _InfoRow(
                icon: isGoogleProvider
                    ? IconService.search  // placeholder; Google icon not in lucide
                    : IconService.bell,
                label: 'Sign-in Method',
                value: isGoogleProvider ? 'Google' : 'Email & Password',
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Security (email users only) ─────────────────────────────────────
          if (isEmailProvider) ...[
            _SectionLabel('SECURITY'),
            _InfoCard(
              children: [
                _ActionRow(
                  icon: IconService.eyeOff,
                  label: 'Change Password',
                  onTap: () => _showChangePasswordSheet(context, authUser, c),
                ),
                if (!authUser.emailVerified) ...[
                  _Divider(),
                  _ActionRow(
                    icon: IconService.bell,
                    label: 'Resend Verification Email',
                    onTap: () => _sendVerification(authUser),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ── Preferences ─────────────────────────────────────────────────────
          _SectionLabel('PREFERENCES'),
          _InfoCard(
            children: [
              _PreferenceTile(
                icon: IconService.bell,
                label: 'Push Notifications',
                value: profile.pushNotificationsEnabled,
                onChanged: (v) =>
                    ref.read(profileProvider).setPushNotifications(v),
              ),
              _Divider(),
              _PreferenceTile(
                icon: IconService.eyeOff,
                label: 'Biometric Login',
                subtitle: 'Face ID or fingerprint',
                value: profile.biometricLoginEnabled,
                onChanged: (v) =>
                    ref.read(profileProvider).setBiometricLogin(v),
              ),
              _Divider(),
              _PreferenceTile(
                icon: IconService.error,
                label: 'Data Delay Disclaimer',
                subtitle: 'Show "Delayed 15 min" on prices',
                value: profile.delayedDataDisclaimer,
                onChanged: (v) =>
                    ref.read(profileProvider).setDelayedDataDisclaimer(v),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── App ─────────────────────────────────────────────────────────────
          _SectionLabel('APP'),
          _InfoCard(
            children: [
              profile.packageInfo != null
                  ? _InfoRow(
                      icon: IconService.inbox,
                      label: 'Version',
                      value: '${profile.packageInfo!.version} (${profile.packageInfo!.buildNumber})',
                    )
                  : const SizedBox(height: 48),
              _Divider(),
              _ActionRow(
                icon: IconService.inbox,
                label: 'Account ID',
                trailing: GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: authUser.uid));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('UID copied', style: TextStyle(color: c.textPrimary)),
                        backgroundColor: c.surface,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    '${authUser.uid.substring(0, 8)}…',
                    style: AppTextStyles.labelSm.copyWith(
                      color: c.primary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Sign out ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: c.priceDown.withAlpha(80)),
                  foregroundColor: c.priceDown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  textStyle: AppTextStyles.labelLg,
                ),
                onPressed: _isSigningOut ? null : () => _signOut(context),
                child: _isSigningOut
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: c.priceDown,
                        ),
                      )
                    : const Text('Sign Out'),
              ),
            ),
          ),

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
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
            Text('Edit Display Name', style: AppTextStyles.labelLg.copyWith(color: c.textPrimary)),
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

  void _showChangePasswordSheet(BuildContext context, User user, AppColorsData c) {
    final currentCtrl = TextEditingController();
    final newCtrl     = TextEditingController();
    String? error;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: c.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
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
              Text('Change Password', style: AppTextStyles.labelLg.copyWith(color: c.textPrimary)),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: currentCtrl,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Current password'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: newCtrl,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'New password (min 6 chars)'),
              ),
              if (error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(error!, style: AppTextStyles.labelSm.copyWith(color: c.priceDown)),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: c.primary),
                  onPressed: () async {
                    if (newCtrl.text.length < 6) {
                      setState(() => error = 'Password must be at least 6 characters');
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
                          const SnackBar(content: Text('Password updated')),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      setState(() => error = e.message ?? 'Authentication failed');
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

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.year}';
  }
}

// Lucide doesn't have a distinct 'pencil' in 0.0.1 — use profile as edit fallback
const _kEditIcon = IconService.profile;

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final initials = _initials(user);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      decoration: BoxDecoration(
        color: c.background,
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.primaryDim,
              border: Border.all(color: c.primary.withAlpha(60), width: 2),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: c.primary.withAlpha(40),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: user.photoURL != null
                ? ClipOval(
                    child: Image.network(
                      user.photoURL!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _InitialsText(initials, c),
                    ),
                  )
                : _InitialsText(initials, c),
          ),
          const SizedBox(height: AppSpacing.md),

          // Display name
          Text(
            user.displayName?.isNotEmpty == true ? user.displayName! : 'Investor',
            style: AppTextStyles.screenTitle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            user.email ?? '',
            style: AppTextStyles.labelSm.copyWith(color: c.textMuted),
          ),
          const SizedBox(height: AppSpacing.sm),

          // PRO + verification row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Badge(label: 'PRO', bg: c.primaryDim, border: c.primary.withAlpha(51), fg: c.primary),
              const SizedBox(width: AppSpacing.sm),
              if (user.emailVerified)
                _Badge(
                  label: 'Verified',
                  bg: c.priceUpDim,
                  border: c.priceUp.withAlpha(51),
                  fg: c.priceUp,
                )
              else
                _Badge(
                  label: 'Unverified',
                  bg: c.priceDownDim,
                  border: c.priceDown.withAlpha(51),
                  fg: c.priceDown,
                ),
            ],
          ),
        ],
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

class _InitialsText extends StatelessWidget {
  const _InitialsText(this.text, this.c);

  final String text;
  final AppColorsData c;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: c.primary,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.bg, required this.border, required this.fg});

  final String label;
  final Color bg, border, fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.sm),
      child: Text(
        label,
        style: AppTextStyles.sectionLabel.copyWith(
          color: c.textMuted,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: c.border, width: 1),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 16, color: c.textMuted),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.labelMd.copyWith(color: c.textSecondary),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.labelMd.copyWith(color: valueColor ?? c.textPrimary),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 4), trailing!],
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.label, this.onTap, this.trailing});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 16, color: c.textMuted),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(label, style: AppTextStyles.labelMd.copyWith(color: c.textPrimary)),
            ),
            trailing ??
                Icon(IconService.arrowDown, size: 14, color: c.textMuted),
          ],
        ),
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: c.textMuted),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelMd.copyWith(color: c.textPrimary)),
                if (subtitle != null)
                  Text(subtitle!, style: AppTextStyles.labelSm.copyWith(color: c.textMuted)),
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

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.of(context).border,
      height: 1,
      indent: AppSpacing.screenH + 16 + AppSpacing.md,
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
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: c.priceUp),
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
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: c.priceDown),
        ),
      ),
    );
  }
}
