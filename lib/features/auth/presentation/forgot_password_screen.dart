import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/features/auth/providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _isLoading  = false;
  bool _emailSent  = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _emailCtrl.text.trim().isNotEmpty && !_isLoading && !_emailSent;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _error     = null;
    });
    try {
      await ref
          .read(authServiceProvider)
          .sendPasswordResetEmail(_emailCtrl.text.trim());
      setState(() => _emailSent = true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                'MarketLens360',
                style: AppTextStyles.screenTitle.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Kenya's market intelligence platform",
                style: AppTextStyles.labelSm,
              ),
              const SizedBox(height: AppSpacing.xxl + AppSpacing.lg),

              // ── Heading ──────────────────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reset your password',
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
                  "Enter your email and we'll send you a reset link.",
                  style: AppTextStyles.body,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Success state ────────────────────────────────────────────
              if (_emailSent) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.priceUpDim,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.priceUp, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email sent',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.priceUp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Check your inbox at ${_emailCtrl.text.trim()} and follow the link to reset your password.',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.priceUp,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ] else ...[
                // ── Email field ────────────────────────────────────────────
                _FieldLabel('EMAIL'),
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() {}),
                  decoration:
                      const InputDecoration(hintText: 'you@example.com'),
                  style: AppTextStyles.labelMd,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Error ──────────────────────────────────────────────────
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: AppTextStyles.labelSm
                        .copyWith(color: AppColors.priceDown),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // ── Send button ────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _canSubmit
                          ? AppColors.accent
                          : AppColors.surfaceVariant,
                      foregroundColor: AppColors.textPrimary,
                      disabledBackgroundColor: AppColors.surfaceVariant,
                      disabledForegroundColor: AppColors.textMuted,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                    onPressed: _canSubmit ? _submit : null,
                    child: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Send reset link',
                            style: AppTextStyles.labelLg.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],

              // ── Back to sign in ──────────────────────────────────────────
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
                  onPressed: () => context.pop(),
                  child: Text(
                    'Back to sign in',
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
