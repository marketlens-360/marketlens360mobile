import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_bars.dart';
import 'package:marketlens360mobile/core/widgets/app_empty_view.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/core/widgets/shimmer_list.dart';
import 'package:marketlens360mobile/features/markets/providers/markets_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';
import 'widgets/security_list_tile.dart';

class MarketsScreen extends ConsumerWidget {
  const MarketsScreen({super.key});

  bool _isMarketOpen() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 3)); // EAT
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      return false;
    }
    final hour = now.hour;
    return hour >= 9 && hour < 15;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markets = ref.watch(marketsProvider);
    final c = AppColors.of(context);
    final marketOpen = _isMarketOpen();
    final securities = markets.filteredSecurities;

    return Scaffold(
      backgroundColor: c.background,
      appBar: const AppShellBar(),
      body: RefreshIndicator(
        onRefresh: () => ref.read(marketsProvider).refresh(),
        child: CustomScrollView(
          slivers: [
            // ── Search bar (scrolls away) ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenH,
                  AppSpacing.md,
                  AppSpacing.screenH,
                  AppSpacing.sm,
                ),
                child: TextField(
                  onChanged: (v) => ref.read(marketsProvider).setSearchQuery(v),
                  decoration: InputDecoration(
                    hintText: 'Search NSE Equities (e.g. SCOM)',
                    prefixIcon:
                        Icon(IconService.search, size: 18, color: c.textMuted),
                    filled: true,
                    fillColor: c.surfaceContainerLowest,
                  ),
                  style: AppTextStyles.labelMd.copyWith(
                    color: c.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ),
            ),

            // ── Filter chips (pinned) ────────────────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _PinnedDelegate(
                minH: 52,
                maxH: 52,
                builder: (ctx) => ColoredBox(
                  color: c.background,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenH,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        _FilterChip(label: 'ALL', isSelected: true, onTap: () {}),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChip(
                            label: 'GAINERS', isSelected: false, onTap: () {}),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChip(
                            label: 'LOSERS', isSelected: false, onTap: () {}),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChip(
                            label: 'VOLUME', isSelected: false, onTap: () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── NSE 20 Index + Market State cards (scrolls away) ─────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenH,
                  AppSpacing.sm,
                  AppSpacing.screenH,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    // NSE 20 Index card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: c.surfaceContainerLow,
                          borderRadius: AppSpacing.cardRadius,
                          border: Border.all(color: c.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NSE 20 INDEX',
                              style: AppTextStyles.sectionLabel.copyWith(
                                color: c.textMuted,
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '1,542.12',
                                  style: AppTextStyles.priceMedium.copyWith(
                                    color: c.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '+0.42%',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: c.priceUp,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Market State card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: c.primaryContainer,
                          borderRadius: AppSpacing.cardRadius,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MARKET STATE',
                              style: AppTextStyles.sectionLabel.copyWith(
                                color: Colors.white.withAlpha(180),
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  marketOpen ? 'OPEN' : 'CLOSED',
                                  style: AppTextStyles.labelLg.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: marketOpen
                                        ? const Color(0xFF4ADE80)
                                        : const Color(0xFFF87171),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Column headers (pinned) ──────────────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _PinnedDelegate(
                minH: 22,
                maxH: 22,
                builder: (ctx) => ColoredBox(
                  color: c.background,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenH,
                          vertical: AppSpacing.xs,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'EQUITY / SYMBOL',
                                style: AppTextStyles.sectionLabel.copyWith(
                                  color: c.textMuted,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 90,
                              child: Text(
                                'PRICE (KES)',
                                style: AppTextStyles.sectionLabel.copyWith(
                                  color: c.textMuted,
                                  fontSize: 9,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              width: 72,
                              child: Text(
                                '24H CHG',
                                style: AppTextStyles.sectionLabel.copyWith(
                                  color: c.textMuted,
                                  fontSize: 9,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: c.border, height: 1),
                    ],
                  ),
                ),
              ),
            ),

            // ── Securities list ──────────────────────────────────────────
            if (markets.isLoading && securities.isEmpty)
              const SliverFillRemaining(
                child: ShimmerList(itemCount: 12),
              )
            else if (markets.error != null && securities.isEmpty)
              SliverFillRemaining(
                child: AppErrorView(
                  error: markets.error!,
                  onRetry: () => ref.read(marketsProvider).refresh(),
                ),
              )
            else if (securities.isEmpty)
              SliverFillRemaining(
                child: AppEmptyView(
                  message: markets.searchQuery.isEmpty
                      ? 'No securities available'
                      : 'No results for "${markets.searchQuery}"',
                ),
              )
            else
              SliverList.separated(
                itemCount: securities.length,
                separatorBuilder: (_, __) =>
                    Divider(color: c.border, height: 1),
                itemBuilder: (_, i) =>
                    SecurityListTile(security: securities[i]),
              ),
          ],
        ),
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

// ── Filter chip ────────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? c.primary : c.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: c.primary.withAlpha(55),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTextStyles.sectionLabel.fontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : c.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}
