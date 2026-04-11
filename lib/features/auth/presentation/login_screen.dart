import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';

import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
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
    final auth      = ref.watch(authProvider);
    final isLoading = auth.isLoading;
    final error     = auth.error;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Image.asset(
                  'assets/images/marketlens_logo_no_background.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('MarketLens360',
                  style: AppTextStyles.screenTitle.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Kenya's market intelligence platform",
                style: AppTextStyles.labelSm,
              ),
              const SizedBox(height: AppSpacing.xxl + AppSpacing.lg),

              // ── Welcome heading ──────────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome back',
                  style: AppTextStyles.priceLarge.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign in to your account to continue',
                  style: AppTextStyles.body,
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
                      _obscurePassword
                          ? IconService.eye
                          : IconService.eyeOff,
                      size: 18,
                      color: AppColors.textMuted,
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
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Error message ────────────────────────────────────────────
              if (error != null) ...[
                Text(error,
                    style: AppTextStyles.labelSm
                        .copyWith(color: AppColors.priceDown)),
                const SizedBox(height: AppSpacing.md),
              ],

              // ── Sign In button ───────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.surfaceVariant,
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () => ref.read(authProvider).signInWithEmail(
                            _emailCtrl.text.trim(),
                            _passwordCtrl.text,
                          ),
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text('Sign in',
                          style: AppTextStyles.labelLg.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
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
                style: AppTextStyles.labelSm,
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    foregroundColor: AppColors.textPrimary,
                  ),
                  onPressed: () => context.push(AppRoutes.register),
                  child: Text(
                    'Create a free account',
                    style: AppTextStyles.labelLg.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
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
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderMedium)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('or', style: AppTextStyles.labelSm),
        ),
        const Expanded(child: Divider(color: AppColors.borderMedium)),
      ],
    );
  }
}
