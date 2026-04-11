import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/price_change_badge.dart';
import 'package:marketlens360mobile/data/models/security.dart';

class PriceHeader extends StatelessWidget {
  const PriceHeader({super.key, required this.summary});

  final SecuritySummary summary;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Fmt.price(summary.closePrice),
            style: AppTextStyles.priceLarge.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              if (summary.changeAmount != null)
                Text(
                  Fmt.pct(summary.changeAmount),
                  style: AppTextStyles.priceMedium.copyWith(
                    color: (summary.changeAmount ?? 0) >= 0
                        ? c.priceUp
                        : c.priceDown,
                  ),
                ),
              const SizedBox(width: AppSpacing.sm),
              if (summary.changePercent != null)
                PriceChangeBadge(value: summary.changePercent!),
              const Spacer(),
              Text(
                'Market Open',
                style: AppTextStyles.labelSm.copyWith(color: c.priceUp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
