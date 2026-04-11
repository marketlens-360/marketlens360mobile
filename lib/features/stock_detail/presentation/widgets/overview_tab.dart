import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/models/security.dart';
import 'package:marketlens360mobile/features/stock_detail/providers/stock_detail_providers.dart';

class OverviewTab extends ConsumerWidget {
  const OverviewTab({super.key, required this.symbol, required this.summary});

  final String symbol;
  final SecuritySummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(stockMetricsProvider(symbol));

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.md,
      ),
      children: [
        _KeyValueRow('P/E Ratio',   metricsAsync.value?.peRatio != null
            ? Fmt.price(metricsAsync.value?.peRatio)
            : '—'),
        const Divider(),
        _KeyValueRow('Market Cap',  Fmt.kesCompact(summary.marketCap)),
        const Divider(),
        _KeyValueRow('Div. Yield',  Fmt.pctAbs(summary.dividendYield)),
        const Divider(),
        _KeyValueRow('52W High',    Fmt.price(summary.week52High)),
        const Divider(),
        _KeyValueRow('52W Low',     Fmt.price(summary.week52Low)),
        const Divider(),
        _KeyValueRow('Volume',      Fmt.compact(summary.volume)),
      ],
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.body),
          const Spacer(),
          Text(value, style: AppTextStyles.priceSmall),
        ],
      ),
    );
  }
}
