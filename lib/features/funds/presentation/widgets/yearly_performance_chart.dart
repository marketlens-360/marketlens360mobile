import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/models/fund_performance.dart';

class YearlyPerformanceChart extends StatelessWidget {
  const YearlyPerformanceChart({super.key, required this.data});

  final List<YearlyPerformance> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text('No data', style: TextStyle(color: AppColors.textMuted)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            barGroups: data.asMap().entries.map((e) {
              final d = e.value;
              final isPos = (d.netReturn ?? 0) >= 0;
              return BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: d.netReturn ?? 0,
                    color: isPos ? AppColors.priceUp : AppColors.priceDown,
                    width: 16,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              );
            }).toList(),
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(
                color: AppColors.border,
                strokeWidth: 0.5,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (v, _) => Text(
                    Fmt.pctAbs(v),
                    style: AppTextStyles.columnHeader,
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    final i = v.toInt();
                    if (i >= 0 && i < data.length) {
                      return Text(
                        '${data[i].year ?? ''}',
                        style: AppTextStyles.columnHeader,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
