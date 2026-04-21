import 'package:flutter/material.dart';

// ── Resolved color set (light or dark) ────────────────────────────────────────
class AppColorsData {
  const AppColorsData({
    required this.isDark,
    required this.background,
    required this.backgroundSection,
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerLow,
    required this.surfaceContainerHigh,
    required this.surfaceContainerLowest,
    required this.surfaceVariant,
    required this.primary,
    required this.primaryDim,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.secondaryDim,
    required this.tertiary,
    required this.tertiaryDim,
    required this.priceUp,
    required this.priceUpDim,
    required this.priceDown,
    required this.priceDownDim,
    required this.warning,
    required this.warningDim,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.border,
    required this.borderMedium,
    required this.outline,
    required this.outlineVariant,
    required this.inverseSurface,
    required this.inverseOnSurface,
  });

  final bool isDark;
  final Color background;
  final Color backgroundSection;
  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerLow;
  final Color surfaceContainerHigh;
  final Color surfaceContainerLowest;
  final Color surfaceVariant;
  final Color primary;
  final Color primaryDim;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color secondaryDim;
  final Color tertiary;
  final Color tertiaryDim;
  final Color priceUp;
  final Color priceUpDim;
  final Color priceDown;
  final Color priceDownDim;
  final Color warning;
  final Color warningDim;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;
  final Color border;
  final Color borderMedium;
  final Color outline;
  final Color outlineVariant;
  final Color inverseSurface;
  final Color inverseOnSurface;

  // ── Gradient helpers ─────────────────────────────────────────────────────────
  LinearGradient get heroGradient => isDark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1d3578), Color(0xFF162a62), Color(0xFF101d47)],
          stops: [0.0, 0.5, 1.0],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
        );

  LinearGradient get aiGradient => isDark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1d3578), Color(0xFF101d47)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
        );

  // ── Dark palette ──────────────────────────────────────────────────────────────
  static const dark = AppColorsData(
    isDark:                  true,
    background:              Color(0xFF0A0E1A),
    backgroundSection:       Color(0xFF141927),
    surface:                 Color(0xFF141927),
    surfaceContainer:        Color(0xFF0D1424),
    surfaceContainerLow:     Color(0xFF141927),
    surfaceContainerHigh:    Color(0xFF1E2D3D),
    surfaceContainerLowest:  Color(0xFF0D1424),  // input fill
    surfaceVariant:          Color(0x0DFFFFFF),
    primary:                 Color(0xFF3D7EFF),
    primaryDim:              Color(0x1F3D7EFF),  // rgba(61,126,255,0.12)
    primaryContainer:        Color(0xFF1d3578),  // hero gradient start
    onPrimaryContainer:      Color(0xFFEEEFFF),
    secondary:               Color(0xFF22C55E),
    secondaryDim:            Color(0x1F22C55E),  // rgba(34,197,94,0.12)
    tertiary:                Color(0xFFF59E0B),
    tertiaryDim:             Color(0x1FF59E0B),
    priceUp:                 Color(0xFF22C55E),
    priceUpDim:              Color(0x1F22C55E),
    priceDown:               Color(0xFFEF4444),
    priceDownDim:            Color(0x1FEF4444),  // rgba(239,68,68,0.12)
    warning:                 Color(0xFFF59E0B),
    warningDim:              Color(0x1FF59E0B),  // rgba(245,158,11,0.12)
    textPrimary:             Color(0xFFF1F5F9),
    textSecondary:           Color(0xFF94A3B8),
    textMuted:               Color(0xFF64748B),
    textDisabled:            Color(0xFF334155),
    border:                  Color(0xFF1E2D3D),
    borderMedium:            Color(0xFF2A3F57),
    outline:                 Color(0xFF475569),
    outlineVariant:          Color(0xFF334155),
    inverseSurface:          Color(0xFFE2E8F0),
    inverseOnSurface:        Color(0xFF1E293B),
  );

  // ── Light palette ─────────────────────────────────────────────────────────────
  static const light = AppColorsData(
    isDark:                  false,
    background:              Color(0xFFFFFFFF),
    backgroundSection:       Color(0xFFF8FAFC),
    surface:                 Color(0xFFFFFFFF),
    surfaceContainer:        Color(0xFFF1F5F9),
    surfaceContainerLow:     Color(0xFFF8FAFC),
    surfaceContainerHigh:    Color(0xFFE2E8F0),
    surfaceContainerLowest:  Color(0xFFF1F5F9),  // input fill (bg-tertiary)
    surfaceVariant:          Color(0xFFE2E8F0),
    primary:                 Color(0xFF2563EB),
    primaryDim:              Color(0xFFDBEAFE),  // accent-subtle
    primaryContainer:        Color(0xFF1E40AF),  // hero gradient end
    onPrimaryContainer:      Color(0xFFEEEFFF),
    secondary:               Color(0xFF15803D),
    secondaryDim:            Color(0xFFDCFCE7),  // success-bg
    tertiary:                Color(0xFFB45309),
    tertiaryDim:             Color(0xFFFEF3C7),  // warning-bg
    priceUp:                 Color(0xFF15803D),
    priceUpDim:              Color(0xFFDCFCE7),  // success-bg
    priceDown:               Color(0xFFB91C1C),
    priceDownDim:            Color(0xFFFEE2E2),  // danger-bg
    warning:                 Color(0xFFB45309),
    warningDim:              Color(0xFFFEF3C7),
    textPrimary:             Color(0xFF0F172A),
    textSecondary:           Color(0xFF475569),
    textMuted:               Color(0xFF64748B),
    textDisabled:            Color(0xFF94A3B8),
    border:                  Color(0xFFE2E8F0),
    borderMedium:            Color(0xFFCBD5E1),
    outline:                 Color(0xFF64748B),
    outlineVariant:          Color(0xFFCBD5E1),
    inverseSurface:          Color(0xFF2D3133),
    inverseOnSurface:        Color(0xFFEFF1F3),
  );
}

// ── ThemeExtension — context-aware access ─────────────────────────────────────
class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  const AppColorsTheme(this.colors);

  final AppColorsData colors;

  static AppColorsData of(BuildContext context) =>
      Theme.of(context).extension<AppColorsTheme>()?.colors ??
      AppColorsData.dark;

  @override
  AppColorsTheme copyWith({AppColorsData? colors}) =>
      AppColorsTheme(colors ?? this.colors);

  @override
  AppColorsTheme lerp(AppColorsTheme other, double t) => t < 0.5 ? this : other;
}

// ── Static dark constants — backward compat ────────────────────────────────────
abstract final class AppColors {
  static const Color background        = Color(0xFF0A0E1A);
  static const Color surface           = Color(0xFF141927);
  static const Color surfaceVariant    = Color(0x0DFFFFFF);
  static const Color overlay           = Color(0xFF0A0E1A);
  static const Color accent            = Color(0xFF3D7EFF);
  static const Color accentDim         = Color(0x1F3D7EFF);
  static const Color priceUp           = Color(0xFF22C55E);
  static const Color priceUpDim        = Color(0x1F22C55E);
  static const Color priceDown         = Color(0xFFEF4444);
  static const Color priceDownDim      = Color(0x1FEF4444);
  static const Color textPrimary       = Color(0xFFF1F5F9);
  static const Color textSecondary     = Color(0xFF94A3B8);
  static const Color textMuted         = Color(0xFF64748B);
  static const Color textDisabled      = Color(0xFF334155);
  static const Color border            = Color(0xFF1E2D3D);
  static const Color borderMedium      = Color(0xFF2A3F57);
  static const Color warning           = Color(0xFFF59E0B);

  // Context-aware accessor
  static AppColorsData of(BuildContext context) => AppColorsTheme.of(context);
}
