import 'package:flutter/material.dart';

// ── Resolved color set (light or dark) ────────────────────────────────────────
class AppColorsData {
  const AppColorsData({
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

  // ── Dark palette ──────────────────────────────────────────────────────────────
  static const dark = AppColorsData(
    background:              Color(0xFF02060F),  // near-black
    backgroundSection:       Color(0xFF0D1117),
    surface:                 Color(0xFF0D1421),  // dark navy card
    surfaceContainer:        Color(0xFF111D2E),
    surfaceContainerLow:     Color(0xFF0A1020),
    surfaceContainerHigh:    Color(0xFF1A2540),
    surfaceContainerLowest:  Color(0xFF070E1A),
    surfaceVariant:          Color(0x0DFFFFFF),  // white/5
    primary:                 Color(0xFF4D8BF5),  // lightened blue for dark bg
    primaryDim:              Color(0x1A4D8BF5),
    primaryContainer:        Color(0xFF2563EB),
    onPrimaryContainer:      Color(0xFFEEEFFF),
    secondary:               Color(0xFF34D399),  // green 400
    secondaryDim:            Color(0x1A34D399),
    tertiary:                Color(0xFFFBBF24),  // amber
    tertiaryDim:             Color(0x1AFBBF24),
    priceUp:                 Color(0xFF34D399),  // green 400
    priceUpDim:              Color(0x1A34D399),
    priceDown:               Color(0xFFF87171),  // red 400
    priceDownDim:            Color(0x1AF87171),
    warning:                 Color(0xFFFBBF24),
    textPrimary:             Color(0xFFF1F5F9),  // slate-100
    textSecondary:           Color(0xFF94A3B8),  // slate-400
    textMuted:               Color(0xFF64748B),  // slate-500
    textDisabled:            Color(0xFF334155),  // slate-700
    border:                  Color(0x14FFFFFF),  // white/8
    borderMedium:            Color(0x1FFFFFFF),  // white/12
    outline:                 Color(0xFF475569),  // slate-600
    outlineVariant:          Color(0x33FFFFFF),  // white/20
    inverseSurface:          Color(0xFFE2E8F0),
    inverseOnSurface:        Color(0xFF1E293B),
  );

  // ── Light palette ─────────────────────────────────────────────────────────────
  static const light = AppColorsData(
    background:              Color(0xFFF7F9FB),
    backgroundSection:       Color(0xFFF2F4F6),
    surface:                 Color(0xFFF7F9FB),
    surfaceContainer:        Color(0xFFECEEF0),
    surfaceContainerLow:     Color(0xFFF2F4F6),
    surfaceContainerHigh:    Color(0xFFE6E8EA),
    surfaceContainerLowest:  Color(0xFFFFFFFF),
    surfaceVariant:          Color(0xFFE0E3E5),
    primary:                 Color(0xFF004AC6),  // brand blue
    primaryDim:              Color(0x1A004AC6),
    primaryContainer:        Color(0xFF2563EB),
    onPrimaryContainer:      Color(0xFFEEEFFF),
    secondary:               Color(0xFF006C4A),  // green (profit)
    secondaryDim:            Color(0x1A006C4A),
    tertiary:                Color(0xFF943700),  // orange (warning)
    tertiaryDim:             Color(0x1A943700),
    priceUp:                 Color(0xFF059669),  // green 600
    priceUpDim:              Color(0x1A059669),
    priceDown:               Color(0xFFBA1A1A),  // red
    priceDownDim:            Color(0x1ABA1A1A),
    warning:                 Color(0xFFD97706),  // amber 600
    textPrimary:             Color(0xFF191C1E),
    textSecondary:           Color(0xFF434655),
    textMuted:               Color(0xFF737686),
    textDisabled:            Color(0xFFC3C6D7),
    border:                  Color(0xFFE5E7EB),
    borderMedium:            Color(0xFFC3C6D7),
    outline:                 Color(0xFF737686),
    outlineVariant:          Color(0xFFC3C6D7),
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
  static const Color background        = Color(0xFF02060F);
  static const Color surface           = Color(0xFF0D1421);
  static const Color surfaceVariant    = Color(0x0DFFFFFF);
  static const Color overlay           = Color(0xFF02060F);
  static const Color accent            = Color(0xFF4D8BF5);
  static const Color accentDim         = Color(0x1A4D8BF5);
  static const Color priceUp           = Color(0xFF34D399);
  static const Color priceUpDim        = Color(0x1A34D399);
  static const Color priceDown         = Color(0xFFF87171);
  static const Color priceDownDim      = Color(0x1AF87171);
  static const Color textPrimary       = Color(0xFFF1F5F9);
  static const Color textSecondary     = Color(0xFF94A3B8);
  static const Color textMuted         = Color(0xFF64748B);
  static const Color textDisabled      = Color(0xFF334155);
  static const Color border            = Color(0x14FFFFFF);
  static const Color borderMedium      = Color(0x1FFFFFFF);
  static const Color warning           = Color(0xFFFBBF24);

  // Context-aware accessor
  static AppColorsData of(BuildContext context) => AppColorsTheme.of(context);
}
