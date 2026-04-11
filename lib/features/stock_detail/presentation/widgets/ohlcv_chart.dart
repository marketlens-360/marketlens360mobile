import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/models/price_history.dart';

class OhlcvChart extends StatelessWidget {
  const OhlcvChart({super.key, required this.data});

  final List<PriceHistory> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No chart data available',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    final spots = data.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.close ?? 0))
        .toList();

    final minY = data.map((d) => d.low ?? d.close ?? 0).reduce((a, b) => a < b ? a : b);
    final maxY = data.map((d) => d.high ?? d.close ?? 0).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.05;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY - padding,
          maxY: maxY + padding,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => const FlLine(
              color: AppColors.border,
              strokeWidth: 0.5,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (v, _) => Text(
                  Fmt.price(v),
                  style: AppTextStyles.columnHeader,
                ),
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  if (i >= 0 && i < data.length && i % (data.length ~/ 4).clamp(1, data.length) == 0) {
                    return Text(
                      Fmt.dateShort(data[i].date),
                      style: AppTextStyles.columnHeader,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: AppColors.accent,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.accent.withAlpha(20),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((s) {
                final i = s.x.toInt();
                final label = i >= 0 && i < data.length
                    ? Fmt.dateShort(data[i].date)
                    : '';
                return LineTooltipItem(
                  '${Fmt.price(s.y)}\n$label',
                  AppTextStyles.priceSmall,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
