import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/services/font_service.dart';

class PriceChangeBadge extends StatelessWidget {
  const PriceChangeBadge({
    super.key,
    required this.value,
    this.showSign = true,
    this.fontSize = 11,
  });

  final double value;
  final bool showSign;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isPositive = value >= 0;
    final bg     = isPositive ? c.priceUpDim  : c.priceDownDim;
    final fg     = isPositive ? c.priceUp     : c.priceDown;
    final border = isPositive
        ? c.priceUp.withAlpha(51)   // ~20%
        : c.priceDown.withAlpha(51);
    final text = showSign ? Fmt.pct(value) : Fmt.pctAbs(value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: FontService.numeric,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: fg,
          fontFeatures: FontService.numericFeatures,
          height: 1.2,
        ),
      ),
    );
  }
}
