import 'dart:ui';

abstract final class FontService {
  // TODO: Update primary to 'Manrope' and numeric to 'Inter' once Google Fonts package is added
  /// Headline font — used for large titles and display text.
  static const String headline = 'PlusJakartaSans';

  /// UI text font — labels, body copy.
  static const String primary = 'PlusJakartaSans';

  /// Financial/numeric display font — prices, returns, table figures.
  static const String numeric = 'IBMPlexSans';

  /// Font features applied to all numeric/financial displays.
  static const List<FontFeature> numericFeatures = [
    FontFeature.tabularFigures(),
  ];

  static const double bodyHeight    = 1.5;
  static const double compactHeight = 1.3;
  static const double displayHeight = 1.1;
}
