import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_bars.dart';
import 'package:marketlens360mobile/core/widgets/app_card.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/core/widgets/shimmer_list.dart';
import 'package:marketlens360mobile/data/models/fund.dart';
import 'package:marketlens360mobile/features/funds/providers/funds_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';
import 'widgets/fund_list_tile.dart';

class FundsScreen extends ConsumerWidget {
  const FundsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final funds = ref.watch(fundsProvider);
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.background,
      appBar: const AppShellBar(),
      body: CustomScrollView(
        slivers: [
          // ── Page title + description (scrolls away) ──────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.lg,
              AppSpacing.screenH,
              AppSpacing.md,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Discover Unit Trusts',
                  style:
                      AppTextStyles.displayMd.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Maximize your wealth with curated Kenyan investment funds selected for performance.',
                  style:
                      AppTextStyles.body.copyWith(color: c.textSecondary),
                ),
              ]),
            ),
          ),

          // ── Category chips (pinned) ──────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedDelegate(
              minH: 52,
              maxH: 52,
              builder: (ctx) => ColoredBox(
                color: c.background,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                  ),
                  child: _CategoryChips(
                    selectedCategory: funds.selectedCategory,
                    onSelected: (cat) =>
                        ref.read(fundsProvider).setCategory(cat),
                  ),
                ),
              ),
            ),
          ),

          // ── Comparison CTA + fund list + market sentiment ────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.xl,
              AppSpacing.screenH,
              AppSpacing.xxl * 2,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _ComparisonCta(),
                const SizedBox(height: 24),

                if (funds.isLoading && funds.funds.isEmpty)
                  const ShimmerList(itemCount: 5)
                else if (funds.error != null && funds.funds.isEmpty)
                  AppErrorView(
                    error: funds.error!,
                    onRetry: () => ref.read(fundsProvider).refresh(),
                  )
                else
                  ...funds.funds.map((f) => FundListTile(fund: f)),

                const SizedBox(height: 16),
                const _MarketSentimentModule(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pinned sliver header delegate ──────────────────────────────────────────────
class _PinnedDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedDelegate({
    required this.minH,
    required this.maxH,
    required this.builder,
  });

  final double minH;
  final double maxH;
  final Widget Function(BuildContext context) builder;

  @override
  double get minExtent => minH;

  @override
  double get maxExtent => maxH;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      builder(context);

  @override
  bool shouldRebuild(_PinnedDelegate old) => true;
}

// ── Category chips ─────────────────────────────────────────────────────────────
class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.selectedCategory,
    required this.onSelected,
  });

  final FundCategory? selectedCategory;
  final ValueChanged<FundCategory?> onSelected;

  static const _items = <(String, FundCategory?)>[
    ('All Funds', null),
    ('Money Market', FundCategory.mmf),
    ('Fixed Income', FundCategory.fif),
    ('Balanced', FundCategory.bal),
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Row(
        children: _items.map((item) {
          final (label, cat) = item;
          final isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => onSelected(cat),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected ? c.primary : c.surfaceContainerHigh,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontFamily: AppTextStyles.sectionLabel.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : c.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Comparison CTA ─────────────────────────────────────────────────────────────
class _ComparisonCta extends StatelessWidget {
  const _ComparisonCta();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: c.aiGradient,
        borderRadius: AppSpacing.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unsure which fund fits?',
            style: AppTextStyles.titleMd.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'Compare risk, returns, and management fees side-by-side.',
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withAlpha(210),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(IconService.compare, size: 16, color: c.primary),
            label: const Text('START COMPARISON'),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: c.primary,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              minimumSize: const Size(0, 40),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Market Sentiment module ────────────────────────────────────────────────────
class _MarketSentimentModule extends StatelessWidget {
  const _MarketSentimentModule();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(IconService.stocks, size: 20, color: c.primary),
          const SizedBox(height: 8),
          Text(
            'MARKET SENTIMENT',
            style: AppTextStyles.sectionLabel.copyWith(
              color: c.textPrimary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Bullish',
            style: AppTextStyles.displayMd.copyWith(color: c.primary),
          ),
          const SizedBox(height: 8),
          Text(
            'Treasury bills maintain double-digit yields, favoring money market funds across the Kenyan sector.',
            style: AppTextStyles.body.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}
