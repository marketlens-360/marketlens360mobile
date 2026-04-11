import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/models/price_history.dart';

class OhlcSummaryRow extends StatelessWidget {
  const OhlcSummaryRow({super.key, required this.history});

  final List<PriceHistory> history;

  PriceHistory? get _latest => history.isNotEmpty ? history.last : null;

  double? get _high => history.isNotEmpty
      ? history.map((h) => h.high ?? 0).reduce((a, b) => a > b ? a : b)
      : null;

  double? get _low => history.isNotEmpty
      ? history.map((h) => h.low ?? 0).reduce((a, b) => a < b ? a : b)
      : null;

  double? get _vol {
    if (history.isEmpty) return null;
    double total = 0;
    for (final h in history) { total += h.volume ?? 0; }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            _OhlcCell(label: 'Open',  value: Fmt.price(_latest?.open)),
            _OhlcCell(label: 'High',  value: Fmt.price(_high)),
            _OhlcCell(label: 'Low',   value: Fmt.price(_low)),
            _OhlcCell(label: 'Vol',   value: Fmt.compact(_vol)),
          ],
        ),
      ),
    );
  }
}

class _OhlcCell extends StatelessWidget {
  const _OhlcCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: AppTextStyles.columnHeader),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.priceSmall),
        ],
      ),
    );
  }
}
