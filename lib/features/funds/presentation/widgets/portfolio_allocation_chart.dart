import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/models/fund_performance.dart';

class PortfolioAllocationChart extends StatelessWidget {
  const PortfolioAllocationChart({super.key, required this.holdings});

  final List<PortfolioHolding> holdings;

  static const _colors = [
    AppColors.accent,
    AppColors.priceUp,
    AppColors.warning,
    AppColors.priceDown,
    Color(0xFF7C3AED),
    Color(0xFF0D9488),
  ];

  @override
  Widget build(BuildContext context) {
    if (holdings.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('No data', style: TextStyle(color: AppColors.textMuted)),
        ),
      );
    }

    // Group by instrument type
    final grouped = <String, double>{};
    for (final h in holdings) {
      final type = h.instrumentType ?? 'Other';
      grouped[type] = (grouped[type] ?? 0) + (h.allocationPercent ?? 0);
    }

    final sections = grouped.entries.toList().asMap().entries.map((e) {
      final color = _colors[e.key % _colors.length];
      return PieChartSectionData(
        value: e.value.value,
        color: color,
        title: Fmt.pctAbs(e.value.value),
        titleStyle: AppTextStyles.sectionLabel.copyWith(color: Colors.white),
        radius: 60,
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: grouped.entries.toList().asMap().entries.map((e) {
              final color = _colors[e.key % _colors.length];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8, color: color),
                  const SizedBox(width: 4),
                  Text(e.value.key, style: AppTextStyles.labelSm),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
