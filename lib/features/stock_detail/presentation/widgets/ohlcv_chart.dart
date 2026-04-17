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
    final c = AppColors.of(context);

    if (data.isEmpty) {
      return SizedBox(
        height: 280,
        child: Center(
          child: Text(
            'No chart data available',
            style: AppTextStyles.body.copyWith(color: c.textMuted),
          ),
        ),
      );
    }

    final spots = data.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.close ?? 0))
        .toList();

    final minY = data.map((d) => d.low ?? d.close ?? 0).reduce((a, b) => a < b ? a : b);
    final maxY = data.map((d) => d.high ?? d.close ?? 0).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.08;

    return SizedBox(
      height: 280,
      child: LineChart(
        LineChartData(
          minY: minY - padding,
          maxY: maxY + padding,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: c.border,
              strokeWidth: 0.5,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (v, _) => Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    Fmt.price(v),
                    style: AppTextStyles.columnHeader.copyWith(color: c.textMuted),
                  ),
                ),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  final step = (data.length ~/ 4).clamp(1, data.length);
                  if (i >= 0 && i < data.length && i % step == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        Fmt.dateShort(data[i].date),
                        style: AppTextStyles.columnHeader.copyWith(color: c.textMuted),
                      ),
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
              isCurved: true,
              curveSmoothness: 0.3,
              color: c.primary,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    c.primary.withAlpha(80),
                    c.primary.withAlpha(5),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => c.surfaceContainer,
              getTooltipItems: (spots) => spots.map((s) {
                final i = s.x.toInt();
                final label = i >= 0 && i < data.length
                    ? Fmt.dateShort(data[i].date)
                    : '';
                return LineTooltipItem(
                  '${Fmt.price(s.y)}\n$label',
                  AppTextStyles.priceSmall.copyWith(color: c.textPrimary),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
