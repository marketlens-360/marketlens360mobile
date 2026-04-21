import 'package:flutter/material.dart';

abstract final class AppSpacing {
  // Spacing scale (4pt grid)
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 20;
  static const double xxl = 24;

  // Layout
  static const double screenH   = 16;  // horizontal screen padding
  static const double listItemV = 10;  // list item vertical padding

  // Card internal padding
  static const EdgeInsets cardPadding = EdgeInsets.all(16);

  // Border radii
  static const double radiusSm   = 6;   // badges, chips
  static const double radiusMd   = 12;  // buttons, inputs
  static const double radiusLg   = 12;  // buttons, inputs (kept as alias for radiusMd)
  static const double radiusCard = 14;  // cards
  static const double radiusXl   = 16;
  static const double radiusPill = 20;  // filter chips, pill badges

  static BorderRadius get cardRadius => BorderRadius.circular(radiusCard);
  static BorderRadius get buttonRadius => BorderRadius.circular(radiusMd);
}
