import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/core/widgets/shimmer_list.dart';
import 'package:marketlens360mobile/features/stock_detail/providers/stock_detail_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';
import 'widgets/dividends_tab.dart';
import 'widgets/financials_tab.dart';
import 'widgets/news_tab.dart';
import 'widgets/ohlc_summary_row.dart';
import 'widgets/ohlcv_chart.dart';
import 'widgets/overview_tab.dart';
import 'widgets/period_selector.dart';
import 'widgets/price_header.dart';

class StockDetailScreen extends ConsumerWidget {
  const StockDetailScreen({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stock = ref.watch(stockDetailProvider(symbol));
    final c = AppColors.of(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(
          backgroundColor: c.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 20, color: c.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                symbol,
                style: AppTextStyles.titleMd.copyWith(color: c.textPrimary),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: c.primaryDim,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  'NSE',
                  style: AppTextStyles.sectionLabel.copyWith(
                    color: c.primary,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            StreamBuilder<bool>(
              stream: ref.read(stockDetailProvider(symbol)).isInWatchlistStream(symbol),
              builder: (context, snapshot) {
                final isIn = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(
                    IconService.watchlist,
                    color: isIn ? c.primary : c.textSecondary,
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

          return NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(child: PriceHeader(summary: summary)),
              SliverToBoxAdapter(
                child: PeriodSelector(
                  selected: stock.period,
                  onPeriodChanged: (p) =>
                      ref.read(stockDetailProvider(symbol)).setPeriod(p),
                ),
              ),
              SliverToBoxAdapter(
                child: stock.isHistoryLoading
                    ? const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : stock.priceHistory.isEmpty
                        ? const SizedBox(height: 200)
                        : OhlcvChart(data: stock.priceHistory),
              ),
              SliverToBoxAdapter(
                child: stock.priceHistory.isNotEmpty
                    ? OhlcSummaryRow(history: stock.priceHistory)
                    : const SizedBox.shrink(),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: c.border, width: 1),
                    ),
                  ),
                  child: const TabBar(
                    tabs: [
                      Tab(text: 'Overview'),
                      Tab(text: 'Financials'),
                      Tab(text: 'Dividends'),
                      Tab(text: 'News'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              children: [
                OverviewTab(symbol: symbol, summary: summary),
                FinancialsTab(symbol: symbol),
                DividendsTab(symbol: symbol),
                NewsTab(symbol: symbol),
              ],
            ),
          );
        }(),
      ),
    );
  }
}
