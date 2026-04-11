import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_empty_view.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/core/widgets/shimmer_list.dart';
import 'package:marketlens360mobile/features/markets/providers/markets_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';
import 'widgets/security_list_tile.dart';

class MarketsScreen extends ConsumerWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markets = ref.watch(marketsProvider);
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenH, vertical: AppSpacing.sm,
            ),
            child: TextField(
              onChanged: (v) => ref.read(marketsProvider).setSearchQuery(v),
              decoration: InputDecoration(
                hintText: 'Search NSE Equities (e.g. SCOM)',
                prefixIcon: Icon(IconService.search, size: 18, color: c.textMuted),
                filled: true,
                fillColor: isDark ? c.surfaceContainerLowest : c.surfaceContainerLowest,
              ),
              style: AppTextStyles.labelMd.copyWith(color: c.textPrimary, fontSize: 13),
            ),
          ),

          // ── Filter chips ─────────────────────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH, vertical: 4,
              ),
              children: [
                _FilterChip(label: 'ALL', isSelected: true, onTap: () {}),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(label: 'GAINERS', isSelected: false, onTap: () {}),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(label: 'LOSERS', isSelected: false, onTap: () {}),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(label: 'VOLUME', isSelected: false, onTap: () {}),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Column headers ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenH, vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'EQUITY / SYMBOL',
                    style: AppTextStyles.sectionLabel.copyWith(
                      color: c.textMuted, fontSize: 9,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    'PRICE (KES)',
                    style: AppTextStyles.sectionLabel.copyWith(
                      color: c.textMuted, fontSize: 9,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: Text(
                    '24H CHG',
                    style: AppTextStyles.sectionLabel.copyWith(
                      color: c.textMuted, fontSize: 9,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: c.border, height: 1),

          // ── List ─────────────────────────────────────────────────────────────
          Expanded(
            child: () {
              if (markets.isLoading && markets.filteredSecurities.isEmpty) {
                return const ShimmerList(itemCount: 12);
              }
              if (markets.error != null && markets.filteredSecurities.isEmpty) {
                return AppErrorView(
                  error: markets.error!,
                  onRetry: () => ref.read(marketsProvider).refresh(),
                );
              }
              final securities = markets.filteredSecurities;
              if (securities.isEmpty) {
                final query = ref.read(marketsProvider).searchQuery;
                return AppEmptyView(
                  message: query.isEmpty
                      ? 'No securities available'
                      : 'No results for "$query"',
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.read(marketsProvider).refresh(),
                child: ListView.separated(
                  itemCount: securities.length,
                  separatorBuilder: (_, __) => Divider(color: c.border, height: 1),
                  itemBuilder: (_, i) => SecurityListTile(security: securities[i]),
                ),
              );
            }(),
          ),
        ],
      ),
    );
  }
}

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? c.primary : c.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? c.primary : c.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.sectionLabel.copyWith(
            color: isSelected ? Colors.white : c.textMuted,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
