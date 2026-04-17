import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/app_empty_view.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/features/stock_detail/providers/stock_detail_providers.dart';

class FinancialsTab extends ConsumerWidget {
  const FinancialsTab({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningsAsync = ref.watch(earningsProvider(symbol));
    final metricsAsync  = ref.watch(stockMetricsProvider(symbol));

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.md,
      ),
      children: [
        Text('Earnings', style: AppTextStyles.labelLg),
        const SizedBox(height: AppSpacing.sm),
        earningsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => AppErrorView(
            error: e,
            onRetry: () => ref.invalidate(earningsProvider(symbol)),
          ),
          data: (earnings) {
            if (earnings.isEmpty) {
              return const AppEmptyView(message: 'No earnings data');
            }
            return Column(
              children: earnings.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(child: Text('FY${e.fiscalYear ?? '—'}', style: AppTextStyles.labelMd)),
                      Expanded(child: Text(Fmt.kesCompact(e.revenue), style: AppTextStyles.priceSmall, textAlign: TextAlign.right)),
                      Expanded(child: Text(Fmt.kesCompact(e.netIncome), style: AppTextStyles.priceSmall, textAlign: TextAlign.right)),
                      Expanded(child: Text(Fmt.price(e.eps), style: AppTextStyles.priceSmall, textAlign: TextAlign.right)),
                    ],

                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Key Metrics', style: AppTextStyles.labelLg),
        const SizedBox(height: AppSpacing.sm),
        metricsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => AppErrorView(
            error: e,
            onRetry: () => ref.invalidate(stockMetricsProvider(symbol)),
          ),
          data: (m) => Column(
            children: [
              _MetricRow('ROE',           Fmt.pctAbs(m.roe)),
              _MetricRow('ROA',           Fmt.pctAbs(m.roa)),
              _MetricRow('Profit Margin', Fmt.pctAbs(m.profitMargin)),
              _MetricRow('Debt/Equity',   Fmt.price(m.debtToEquity)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Text(label, style: AppTextStyles.body),
              const Spacer(),
              Text(value, style: AppTextStyles.priceSmall),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
