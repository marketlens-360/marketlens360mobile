import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketlens360mobile/services/font_service.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get dark  => _build(AppColorsData.dark,  Brightness.dark,  SystemUiOverlayStyle.light);
  static ThemeData get light => _build(AppColorsData.light, Brightness.light, SystemUiOverlayStyle.dark);

  static ThemeData _build(
    AppColorsData c,
    Brightness brightness,
    SystemUiOverlayStyle systemOverlay,
  ) =>
      ThemeData(
        useMaterial3: true,
        brightness: brightness,
        fontFamily: FontService.primary,
        scaffoldBackgroundColor: c.background,
        extensions: [AppColorsTheme(c)],
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: c.primary,
          onPrimary: Colors.white,
          secondary: c.secondary,
          onSecondary: Colors.white,
          tertiary: c.tertiary,
          onTertiary: Colors.white,
          surface: c.surface,
          onSurface: c.textPrimary,
          error: c.priceDown,
          onError: Colors.white,
          surfaceContainerLowest: c.surfaceContainerLowest,
          surfaceContainerLow: c.surfaceContainerLow,
          surfaceContainer: c.surfaceContainer,
          surfaceContainerHigh: c.surfaceContainerHigh,
          outline: c.outline,
          outlineVariant: c.outlineVariant,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: c.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: AppTextStyles.screenTitle.copyWith(color: c.textPrimary),
          systemOverlayStyle: systemOverlay,
          iconTheme: IconThemeData(color: c.textSecondary, size: 20),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: c.surface,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontFamily: FontService.primary, fontSize: 10, fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: FontService.primary, fontSize: 10, fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          selectedItemColor: c.primary,
          unselectedItemColor: c.textMuted,
        ),
        dividerTheme: DividerThemeData(
          color: c.border,
          thickness: 0.5,
          space: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: c.surfaceContainerLowest,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: BorderSide(color: c.borderMedium, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: BorderSide(color: c.borderMedium, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: BorderSide(color: c.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: BorderSide(color: c.priceDown, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            borderSide: BorderSide(color: c.priceDown, width: 2),
          ),
          hintStyle: TextStyle(
            fontFamily: FontService.primary, fontSize: 13, color: c.textMuted,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.transparent,
          selectedColor: c.primaryDim,
          side: BorderSide(color: c.borderMedium, width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          labelStyle: TextStyle(
            fontFamily: FontService.primary, fontSize: 12, color: c.textSecondary,
          ),
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: c.primary,
          unselectedLabelColor: c.textMuted,
          dividerColor: c.border,
          indicatorColor: c.primary,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: c.primary, width: 2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(2),
            ),
          ),
          labelStyle: TextStyle(
            fontFamily: FontService.primary, fontSize: 13, fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: FontService.primary, fontSize: 13,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: c.primary,
            foregroundColor: Colors.white,
            textStyle: TextStyle(
              fontFamily: FontService.primary, fontSize: 13, fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: c.textPrimary,
            side: BorderSide(color: c.borderMedium),
            textStyle: TextStyle(
              fontFamily: FontService.primary, fontSize: 13, fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        textTheme: TextTheme(
          displayLarge:  AppTextStyles.displayLg,
          displayMedium: AppTextStyles.displayMd,
          headlineMedium: AppTextStyles.titleLg,
          titleLarge:  AppTextStyles.titleMd.copyWith(color: c.textPrimary),
          titleMedium: AppTextStyles.titleSm.copyWith(color: c.textPrimary),
          bodyLarge:   TextStyle(fontFamily: FontService.primary, fontSize: 16, color: c.textPrimary),
          bodyMedium:  TextStyle(fontFamily: FontService.primary, fontSize: 13, color: c.textPrimary),
          bodySmall:   TextStyle(fontFamily: FontService.primary, fontSize: 11, color: c.textSecondary),
          labelLarge:  TextStyle(fontFamily: FontService.primary, fontSize: 13, fontWeight: FontWeight.w500, color: c.textPrimary),
          labelMedium: TextStyle(fontFamily: FontService.primary, fontSize: 12, color: c.textPrimary),
          labelSmall:  TextStyle(fontFamily: FontService.primary, fontSize: 10, letterSpacing: 0.8, color: c.textMuted),
        ),
        cardTheme: CardThemeData(
          color: c.surfaceContainerLowest,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            side: BorderSide(color: c.border, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH, vertical: AppSpacing.xs,
          ),
        ),
      );
}
