import 'dart:ui';

abstract final class FontService {
  /// Headline font — large titles, display text, section labels.
  static const String headline = 'PlusJakartaSans';

  /// UI text font — labels, body copy, row titles/subtitles.
  static const String primary = 'PlusJakartaSans';

  /// Financial/numeric display font — prices, returns, table figures.
  /// IBM Plex Sans has first-class tabular figure support.
  static const String numeric = 'IBMPlexSans';

  /// Font features applied to all numeric/financial displays.
  static const List<FontFeature> numericFeatures = [
    FontFeature.tabularFigures(),
  ];

  static const double bodyHeight    = 1.5;
  static const double compactHeight = 1.3;
  static const double displayHeight = 1.1;
}
