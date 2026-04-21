import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

// ── Badge for gradient header (white tint) ────────────────────────────────────
class GradientBadge extends StatelessWidget {
  const GradientBadge({required this.label, this.tintColor});

  final String label;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    final color = tintColor ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
