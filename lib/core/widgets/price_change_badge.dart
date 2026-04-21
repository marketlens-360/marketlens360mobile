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
    final text = showSign ? Fmt.pct(value) : Fmt.pctAbs(value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: fontSize + 3,
            color: fg,
          ),
          Text(
            text,
            style: TextStyle(
              fontFamily: FontService.numeric,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fg,
              fontFeatures: FontService.numericFeatures,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
