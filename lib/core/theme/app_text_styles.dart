import 'package:flutter/material.dart';
import 'package:marketlens360mobile/services/font_service.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle _headline({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      TextStyle(
        fontFamily: FontService.headline,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height ?? FontService.displayHeight,
      );

  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    List<FontFeature>? fontFeatures,
  }) =>
      TextStyle(
        fontFamily: FontService.primary,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        fontFeatures: fontFeatures,
      );

  static TextStyle _numeric({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      TextStyle(
        fontFamily: FontService.numeric,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        fontFeatures: FontService.numericFeatures,
      );

  // ── Headline / Display styles (Manrope) ──────────────────────────────────────
  static final TextStyle displayLg = _headline(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static final TextStyle displayMd = _headline(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
  );

  static final TextStyle titleLg = _headline(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static final TextStyle titleMd = _headline(
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle titleSm = _headline(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // ── Price & financial numeric styles ─────────────────────────────────────────
  static final TextStyle priceLarge = _numeric(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
    height: FontService.compactHeight,
  );

  static final TextStyle priceMedium = _numeric(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: FontService.compactHeight,
  );

  static final TextStyle priceSmall = _numeric(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: FontService.compactHeight,
  );

  static final TextStyle returnLarge = _numeric(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: FontService.compactHeight,
  );

  static final TextStyle returnMedium = _numeric(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: FontService.compactHeight,
  );

  static final TextStyle columnHeader = _numeric(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // ── UI labels (Inter/PlusJakartaSans) ────────────────────────────────────────
  static final TextStyle screenTitle = _base(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle labelLg = _base(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle labelMd = _base(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle labelSm = _base(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static final TextStyle sectionLabel = _base(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textDisabled,
    letterSpacing: 0.8,
  );

  static final TextStyle body = _base(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: FontService.bodyHeight,
  );

  static final TextStyle caption = _base(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: FontService.bodyHeight,
  );
}
