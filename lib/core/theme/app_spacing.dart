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

  // Border radii — 12px is the primary card radius per design
  static const double radiusSm   = 6;
  static const double radiusMd   = 8;
  static const double radiusLg   = 12;   // ← primary card radius
  static const double radiusXl   = 16;
  static const double radiusPill = 20;

  static BorderRadius get cardRadius => BorderRadius.circular(radiusLg);
}
