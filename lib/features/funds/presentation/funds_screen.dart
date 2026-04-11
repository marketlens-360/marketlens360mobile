import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
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
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(IconService.menu, size: 22, color: c.primary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'MarketLens360',
          style: AppTextStyles.titleSm.copyWith(color: c.primary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: c.surfaceContainer,
              child: Icon(IconService.profile, size: 16, color: c.primary),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.lg,
              AppSpacing.screenH,
              AppSpacing.xxl * 2,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Page title ────────────────────────────────────────────────
                Text(
                  'Discover Unit Trusts',
                  style: AppTextStyles.displayMd.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Maximize your wealth with curated Kenyan investment funds selected for performance.',
                  style: AppTextStyles.body.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: 20),

                // ── Category chips ────────────────────────────────────────────
                _CategoryChips(
                  selectedCategory: funds.selectedCategory,
                  onSelected: (cat) => ref.read(fundsProvider).setCategory(cat),
                ),
                const SizedBox(height: 20),

                // ── Comparison CTA ────────────────────────────────────────────
                const _ComparisonCta(),
                const SizedBox(height: 24),

                // ── Fund list ─────────────────────────────────────────────────
                if (funds.isLoading && funds.funds.isEmpty)
                  const ShimmerList(itemCount: 5)
                else if (funds.error != null && funds.funds.isEmpty)
                  AppErrorView(
                    error: funds.error!,
                    onRetry: () => ref.read(fundsProvider).refresh(),
                  )
                else
                  ...funds.funds.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: FundListTile(fund: f),
                      )),

                const SizedBox(height: 16),

                // ── Market Sentiment ──────────────────────────────────────────
                const _MarketSentimentModule(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
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
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (label, cat) = _items[i];
          final isSelected = selectedCategory == cat;
          return GestureDetector(
            onTap: () => onSelected(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? c.primary : c.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: isSelected ? c.primary : c.border,
                ),
              ),
              child: Text(
                label.toUpperCase(),
                style: AppTextStyles.sectionLabel.copyWith(
                  color: isSelected ? Colors.white : c.textMuted,
                  fontSize: 10,
                ),
              ),
            ),
          );
        },
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
        color: c.primaryContainer,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
