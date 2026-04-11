import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/features/auth/providers/auth_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

// ── Password strength ─────────────────────────────────────────────────────────

enum _PasswordStrength { empty, weak, fair, strong }

_PasswordStrength _evaluate(String password) {
  if (password.isEmpty) return _PasswordStrength.empty;
  int score = 0;
  if (password.length >= 8) score += 2;
  if (RegExp(r'[A-Z]').hasMatch(password)) score++;
  if (RegExp(r'[0-9]').hasMatch(password)) score++;
  if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
  if (score <= 1) return _PasswordStrength.weak;
  if (score <= 3) return _PasswordStrength.fair;
  return _PasswordStrength.strong;
}

extension _PasswordStrengthX on _PasswordStrength {
  String get label {
    switch (this) {
      case _PasswordStrength.empty:  return '';
      case _PasswordStrength.weak:   return 'Weak';
      case _PasswordStrength.fair:   return 'Fair';
      case _PasswordStrength.strong: return 'Strong';
    }
  }

  Color get color {
    switch (this) {
      case _PasswordStrength.empty:  return Colors.transparent;
      case _PasswordStrength.weak:   return AppColors.priceDown;
      case _PasswordStrength.fair:   return AppColors.warning;
      case _PasswordStrength.strong: return AppColors.priceUp;
    }
  }

  int get filledBars {
    switch (this) {
      case _PasswordStrength.empty:  return 0;
      case _PasswordStrength.weak:   return 1;
      case _PasswordStrength.fair:   return 2;
      case _PasswordStrength.strong: return 3;
    }
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameCtrl            = TextEditingController();
  final _emailCtrl           = TextEditingController();
  final _passwordCtrl        = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword        = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading              = false;
  String? _error;

  _PasswordStrength _strength = _PasswordStrength.empty;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_onChanged);
    _emailCtrl.addListener(_onChanged);
    _passwordCtrl.addListener(_onPasswordChanged);
    _confirmPasswordCtrl.addListener(_onChanged);
  }

  void _onPasswordChanged() {
    setState(() {
      _strength = _evaluate(_passwordCtrl.text);
    });
  }

  void _onChanged() => setState(() {});

  bool get _isFormValid {
    final pw = _passwordCtrl.text;
    return _nameCtrl.text.trim().isNotEmpty &&
        _emailCtrl.text.trim().isNotEmpty &&
        pw.length >= 6 &&
        pw == _confirmPasswordCtrl.text;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name     = _nameCtrl.text.trim();
    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (password != _confirmPasswordCtrl.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error     = null;
    });

    try {
      await ref.read(authServiceProvider).signUpWithEmail(
            email: email,
            password: password,
            displayName: name,
          );
      // Router redirect handles navigation on auth state change
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _isFormValid && !_isLoading;

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
                  'Create your account',
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
                  "Start tracking Kenya's markets for free",
                  style: AppTextStyles.body,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Full name ────────────────────────────────────────────────
              _FieldLabel('FULL NAME'),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _nameCtrl,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Jane Doe'),
                style: AppTextStyles.labelMd,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Email ────────────────────────────────────────────────────
              _FieldLabel('EMAIL'),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: 'you@example.com'),
                style: AppTextStyles.labelMd,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Password ─────────────────────────────────────────────────
              _FieldLabel('PASSWORD'),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'At least 6 characters',
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

              // ── Password strength indicator ──────────────────────────────
              if (_strength != _PasswordStrength.empty) ...[
                const SizedBox(height: AppSpacing.sm),
                _PasswordStrengthBar(strength: _strength),
              ],
              const SizedBox(height: AppSpacing.lg),

              // ── Confirm password ─────────────────────────────────────────
              _FieldLabel('CONFIRM PASSWORD'),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _confirmPasswordCtrl,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Repeat your password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? IconService.eye
                          : IconService.eyeOff,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                    onPressed: () => setState(
                      () =>
                          _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                  ),
                ),
                style: AppTextStyles.labelMd,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Error message ────────────────────────────────────────────
              if (_error != null) ...[
                Text(
                  _error!,
                  style: AppTextStyles.labelSm
                      .copyWith(color: AppColors.priceDown),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // ── Create account button ────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: canSubmit
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
                  onPressed: canSubmit ? _register : null,
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
                          'Create free account',
                          style: AppTextStyles.labelLg.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Back to sign in ──────────────────────────────────────────
              Text(
                'Already have an account?',
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
                  onPressed: () => context.pop(),
                  child: Text(
                    'Sign in instead',
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

// ── Password strength bar widget ──────────────────────────────────────────────

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.strength});
  final _PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(3, (i) {
          final filled = i < strength.filledBars;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? AppSpacing.xs : 0),
              height: 3,
              decoration: BoxDecoration(
                color: filled ? strength.color : AppColors.borderMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
        const SizedBox(width: AppSpacing.sm),
        Text(
          strength.label,
          style: AppTextStyles.labelSm.copyWith(
            color: strength.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Field label ───────────────────────────────────────────────────────────────

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
