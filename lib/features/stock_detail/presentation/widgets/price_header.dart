import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/models/security.dart';

class PriceHeader extends StatelessWidget {
  const PriceHeader({super.key, required this.summary});

  final SecuritySummary summary;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isUp = (summary.changePercent ?? 0) >= 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH, AppSpacing.md, AppSpacing.screenH, AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NSE badge + sector
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'NSE: ${summary.symbol}',
                  style: AppTextStyles.sectionLabel.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (summary.sector != null)
                Flexible(
                  child: Text(
                    summary.sector!.toUpperCase(),
                    style: AppTextStyles.sectionLabel.copyWith(
                      color: c.textMuted,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Company name
          Text(
            summary.name ?? summary.symbol,
            style: AppTextStyles.displayLg.copyWith(
              color: c.textPrimary,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 12),
          // Current price label + price
          Text(
            'Current Price',
            style: AppTextStyles.labelSm.copyWith(color: c.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            'KES ${Fmt.price(summary.closePrice)}',
            style: AppTextStyles.priceLarge.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          // Change row
          Row(
            children: [
              Icon(
                isUp ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: isUp ? c.priceUp : c.priceDown,
              ),
              const SizedBox(width: 4),
              Text(
                '${Fmt.pct(summary.changePercent)} (${isUp && summary.changeAmount != null ? '+' : ''}${Fmt.price(summary.changeAmount)})',
                style: AppTextStyles.labelMd.copyWith(
                  color: isUp ? c.priceUp : c.priceDown,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Market Open',
                style: AppTextStyles.labelSm.copyWith(color: c.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
