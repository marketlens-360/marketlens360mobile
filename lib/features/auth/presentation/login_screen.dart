import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';

import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_card.dart';
import 'package:marketlens360mobile/features/auth/providers/auth_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';
import 'widgets/google_sign_in_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c         = AppColors.of(context);
    final auth      = ref.watch(authProvider);
    final isLoading = auth.isLoading;
    final error     = auth.error;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg + AppSpacing.sm,
            vertical: AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Logo + app name ──────────────────────────────────────────
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: c.primaryDim,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(
                    color: c.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Image.asset(
                  'assets/images/marketlens_logo_no_background.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'MarketLens360',
                style: AppTextStyles.screenTitle.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Kenya's market intelligence platform",
                style: AppTextStyles.labelSm.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl + AppSpacing.lg),

              // ── Welcome heading ──────────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome back',
                  style: AppTextStyles.titleLg.copyWith(color: c.textPrimary),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign in to your account to continue',
                  style: AppTextStyles.body.copyWith(color: c.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Email field ──────────────────────────────────────────────
              _FieldLabel('EMAIL'),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
                ),
                style: AppTextStyles.labelMd,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Password field ───────────────────────────────────────────
              _FieldLabel('PASSWORD'),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? IconService.eye : IconService.eyeOff,
                      size: 18,
                      color: c.textMuted,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                style: AppTextStyles.labelMd,
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Forgot password ──────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(AppRoutes.forgotPassword),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: AppTextStyles.labelSm.copyWith(color: c.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Error message ────────────────────────────────────────────
              if (error != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: c.priceDownDim,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: c.priceDown.withOpacity(0.3)),
                  ),
                  child: Text(
                    error,
                    style: AppTextStyles.labelSm.copyWith(color: c.priceDown),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // ── Sign In button ───────────────────────────────────────────
              AppPrimaryButton(
                label: 'Sign in',
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () => ref.read(authProvider).signInWithEmail(
                          _emailCtrl.text.trim(),
                          _passwordCtrl.text,
                        ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Divider ──────────────────────────────────────────────────
              const _OrDivider(),
              const SizedBox(height: AppSpacing.xl),

              // ── Google Sign-In ───────────────────────────────────────────
              const GoogleSignInButton(),
              const SizedBox(height: AppSpacing.xxl),

              // ── Create account ───────────────────────────────────────────
              Text(
                'New to MarketLens360?',
                style: AppTextStyles.labelSm.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              _TonalButton(
                label: 'Create a free account',
                onPressed: () => context.push(AppRoutes.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared private widgets ────────────────────────────────────────────────────

/// A secondary button with a blue border and blue text — no fill.
class _TonalButton extends StatelessWidget {
  const _TonalButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.primary,
          side: BorderSide(color: c.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.cardRadius),
          overlayColor: c.primaryDim,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.primary,
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: AppTextStyles.sectionLabel.copyWith(
          letterSpacing: 0.8,
          color: AppColors.of(context).textMuted,
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Row(
      children: [
        Expanded(child: Divider(color: c.borderMedium)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'or',
            style: AppTextStyles.labelSm.copyWith(color: c.textMuted),
          ),
        ),
        Expanded(child: Divider(color: c.borderMedium)),
      ],
    );
  }
}
