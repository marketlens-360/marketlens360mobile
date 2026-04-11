import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/models/fund.dart';

class PerformanceSummaryCard extends StatelessWidget {
  const PerformanceSummaryCard({super.key, required this.fund});

  final Fund fund;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          _PeriodReturn(label: '1M',  value: fund.return1m),
          _PeriodReturn(label: '3M',  value: fund.return3m),
          _PeriodReturn(label: '6M',  value: fund.return6m),
          _PeriodReturn(label: '1Y',  value: fund.return1y),
        ],
      ),
    );
  }
}

class _PeriodReturn extends StatelessWidget {
  const _PeriodReturn({required this.label, required this.value});

  final String label;
  final double? value;

  @override
  Widget build(BuildContext context) {
    final color = (value ?? 0) >= 0 ? AppColors.priceUp : AppColors.priceDown;
    return Expanded(
      child: Column(
        children: [
          Text(label, style: AppTextStyles.sectionLabel),
          const SizedBox(height: 4),
          Text(
            Fmt.pct(value),
            style: AppTextStyles.returnMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
