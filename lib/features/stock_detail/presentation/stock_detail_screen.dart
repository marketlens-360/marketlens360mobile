import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/app_bars.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/core/widgets/shimmer_list.dart';
import 'package:marketlens360mobile/data/models/price_history.dart';
import 'package:marketlens360mobile/data/models/security.dart';
import 'package:marketlens360mobile/features/stock_detail/providers/stock_detail_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';
import 'widgets/ohlc_summary_row.dart';
import 'widgets/ohlcv_chart.dart';
import 'widgets/period_selector.dart';
import 'widgets/price_header.dart';

class StockDetailScreen extends ConsumerWidget {
  const StockDetailScreen({super.key, required this.symbol, this.initialSector});

  final String symbol;
  final String? initialSector;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stock = ref.watch(stockDetailProvider(symbol));
    final metricsAsync = ref.watch(stockMetricsProvider(symbol));
    final earningsAsync = ref.watch(earningsProvider(symbol));
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppDetailBar(
        title: symbol,
        subtitle: initialSector ?? stock.summary?.sector,
        actions: [
          StreamBuilder<bool>(
            stream: ref.read(stockDetailProvider(symbol)).isInWatchlistStream(symbol),
            builder: (context, snapshot) {
              final isIn  = snapshot.data ?? false;
              final color = AppColors.of(context);
              return IconButton(
                icon: Icon(
                  IconService.watchlist,
                  color: isIn ? color.primary : color.textSecondary,
                  size: 20,
                ),
                onPressed: () async {
                  final notifier = ref.read(stockDetailProvider(symbol));
                  if (isIn) {
                    await notifier.removeFromWatchlist(symbol);
                  } else {
                    await notifier.addToWatchlist(symbol);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: () {
        if (stock.isLoading && stock.summary == null) {
          return const ShimmerList(itemCount: 8);
        }
        if (stock.error != null && stock.summary == null) {
          return AppErrorView(
            error: stock.error!,
            onRetry: () => ref.read(stockDetailProvider(symbol)).refresh(),
          );
        }
        final summary = stock.summary;
        if (summary == null) return const SizedBox.shrink();

        final peRatio = summary.peRatio ?? metricsAsync.value?.peRatio;
        final latestEps = earningsAsync.value?.isNotEmpty == true
            ? earningsAsync.value!.first.eps
            : null;

        return RefreshIndicator(
          onRefresh: () => ref.read(stockDetailProvider(symbol)).refresh(),
          child: CustomScrollView(
            slivers: [
              // ── Asset identity + price ─────────────────────────────────────
              SliverToBoxAdapter(child: PriceHeader(summary: summary)),

              // ── Period selector ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.md,
                    bottom: AppSpacing.sm,
                  ),
                  child: PeriodSelector(
                    selected: stock.period,
                    onPeriodChanged: (p) =>
                        ref.read(stockDetailProvider(symbol)).setPeriod(p),
                  ),
                ),
              ),

              // ── Chart card ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                  decoration: BoxDecoration(
                    color: c.surfaceContainerLowest,
                    borderRadius: AppSpacing.cardRadius,
                    border: Border.all(color: c.border),
                  ),
                  child: stock.isHistoryLoading
                      ? const SizedBox(
                          height: 280,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : stock.priceHistory.isEmpty
                          ? const SizedBox(height: 280)
                          : OhlcvChart(data: stock.priceHistory),
                ),
              ),

              // ── OHLC summary ───────────────────────────────────────────────
              if (stock.priceHistory.isNotEmpty)
                SliverToBoxAdapter(
                  child: OhlcSummaryRow(history: stock.priceHistory),
                ),

              // ── Key metrics grid ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: _MetricsGrid(
                  summary: summary,
                  peRatio: peRatio,
                  eps: latestEps,
                ),
              ),

              // ── AI Intelligence card ───────────────────────────────────────
              SliverToBoxAdapter(child: _AiCard(summary: summary)),

              // ── Company Overview card ──────────────────────────────────────
              SliverToBoxAdapter(child: _CompanyOverviewCard(summary: summary)),

              // ── Volume Analysis card ───────────────────────────────────────
              if (stock.priceHistory.isNotEmpty)
                SliverToBoxAdapter(
                  child: _VolumeCard(
                    history: stock.priceHistory,
                    summary: summary,
                  ),
                ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
            ],
          ),
        );
      }(),
    );
  }
}

// ── Key Metrics Grid ───────────────────────────────────────────────────────────

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({
    required this.summary,
    this.peRatio,
    this.eps,
  });

  final SecuritySummary summary;
  final double? peRatio;
  final double? eps;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final items = [
      _MetricItem('Market Cap', Fmt.kesCompact(summary.marketCap)),
      _MetricItem('P/E Ratio', peRatio != null ? Fmt.price(peRatio) : '—'),
      _MetricItem('Dividend Yield', Fmt.pctAbs(summary.dividendYield)),
      _MetricItem('EPS', eps != null ? Fmt.price(eps) : '—'),
      _MetricItem(
        '52W High',
        summary.week52High != null ? 'KES ${Fmt.price(summary.week52High)}' : '—',
      ),
      _MetricItem(
        '52W Low',
        summary.week52Low != null ? 'KES ${Fmt.price(summary.week52Low)}' : '—',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH, AppSpacing.lg, AppSpacing.screenH, 0,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 2.3,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          return Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: c.surfaceContainerLowest,
              borderRadius: AppSpacing.cardRadius,
              border: Border.all(color: c.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.label.toUpperCase(),
                  style: AppTextStyles.sectionLabel.copyWith(
                    color: c.textMuted,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  style: AppTextStyles.priceMedium.copyWith(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetricItem {
  const _MetricItem(this.label, this.value);
  final String label;
  final String value;
}

// ── AI Intelligence Card ───────────────────────────────────────────────────────

class _AiCard extends StatelessWidget {
  const _AiCard({required this.summary});

  final SecuritySummary summary;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.screenH, AppSpacing.lg, AppSpacing.screenH, 0,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: c.aiGradient,
        borderRadius: AppSpacing.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'AI Intelligence',
                style: AppTextStyles.titleSm.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${summary.name ?? summary.symbol} is listed on the NSE. '
            'Monitor price trends, volume patterns, and key financial '
            'metrics for informed trading decisions.',
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withAlpha(220),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withAlpha(30), height: 1),
          _AiRow('SENTIMENT SCORE', '—', isBadge: true),
          Divider(color: Colors.white.withAlpha(30), height: 1),
          _AiRow('VOLATILITY RISK', 'MODERATE'),
          Divider(color: Colors.white.withAlpha(30), height: 1),
          _AiRow('REC. POSITION', 'WATCH'),
        ],
      ),
    );
  }
}

class _AiRow extends StatelessWidget {
  const _AiRow(this.label, this.value, {this.isBadge = false});

  final String label;
  final String value;
  final bool isBadge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.sectionLabel.copyWith(
              color: Colors.white.withAlpha(160),
              fontSize: 10,
            ),
          ),
          const Spacer(),
          if (isBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              child: Text(
                value,
                style: AppTextStyles.sectionLabel.copyWith(
                  color: AppColors.of(context).primary,
                  fontSize: 10,
                ),
              ),
            )
          else
            Text(
              value,
              style: AppTextStyles.labelMd.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Company Overview Card ──────────────────────────────────────────────────────

class _CompanyOverviewCard extends StatelessWidget {
  const _CompanyOverviewCard({required this.summary});

  final SecuritySummary summary;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.screenH, AppSpacing.lg, AppSpacing.screenH, 0,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.surfaceContainerLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Company Overview',
            style: AppTextStyles.titleSm.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            '${summary.name ?? summary.symbol} is listed on the '
            '${summary.exchange ?? 'Nairobi Securities Exchange (NSE)'}'
            '${summary.sector != null ? ' in the ${summary.sector} sector' : ''}.',
            style: AppTextStyles.body.copyWith(
              color: c.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _OverviewRow(
            icon: Icons.account_balance,
            label: 'Listed Exchange',
            value: summary.exchange ?? 'Nairobi Securities Exchange (NSE)',
            c: c,
          ),
          if (summary.sector != null) ...[
            const SizedBox(height: 12),
            _OverviewRow(
              icon: Icons.category_outlined,
              label: 'Sector',
              value: summary.sector!,
              c: c,
            ),
          ],
          const SizedBox(height: 12),
          _OverviewRow(
            icon: Icons.bar_chart,
            label: 'Volume',
            value: Fmt.compact(summary.volume),
            c: c,
          ),
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  const _OverviewRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.c,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppColorsData c;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: c.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelMd.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.caption.copyWith(color: c.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Volume Analysis Card ───────────────────────────────────────────────────────

class _VolumeCard extends StatelessWidget {
  const _VolumeCard({required this.history, required this.summary});

  final List<PriceHistory> history;
  final SecuritySummary summary;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    final samples = history.length > 10
        ? history.sublist(history.length - 10)
        : history;
    final maxVol = samples
        .map((h) => h.volume ?? 0)
        .fold(0.0, (a, b) => a > b ? a : b);
    final avgVol = samples.isEmpty
        ? 0.0
        : samples.map((h) => h.volume ?? 0).fold(0.0, (a, b) => a + b) /
            samples.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.screenH, AppSpacing.lg, AppSpacing.screenH, 0,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.surfaceContainerLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VOLUME ANALYSIS',
            style: AppTextStyles.sectionLabel.copyWith(color: c.textMuted),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: samples.map((h) {
                final vol = h.volume ?? 0;
                final ratio = maxVol > 0 ? vol / maxVol : 0.05;
                final isAboveAvg = vol > avgVol;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: FractionallySizedBox(
                      alignment: Alignment.bottomCenter,
                      heightFactor: ratio.clamp(0.05, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isAboveAvg
                              ? c.primary.withAlpha(100)
                              : c.surfaceContainerHigh,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: c.border, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'AVG VOL (10D)',
                style: AppTextStyles.sectionLabel.copyWith(color: c.textMuted),
              ),
              const Spacer(),
              Text(
                Fmt.compact(avgVol),
                style: AppTextStyles.priceMedium.copyWith(color: c.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
