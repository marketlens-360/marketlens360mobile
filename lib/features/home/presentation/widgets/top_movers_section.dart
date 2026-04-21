import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/core/widgets/price_change_badge.dart';
import 'package:marketlens360mobile/core/widgets/shimmer_list.dart';
import 'package:marketlens360mobile/features/home/providers/home_providers.dart';

class TopMoversSection extends ConsumerStatefulWidget {
  const TopMoversSection({super.key});

  @override
  ConsumerState<TopMoversSection> createState() => _TopMoversSectionState();
}

class _TopMoversSectionState extends ConsumerState<TopMoversSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c    = AppColors.of(context);
    final home = ref.watch(homeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header + custom tab bar ────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          child: Row(
            children: [
              Text('Top Movers', style: AppTextStyles.labelLg.copyWith(color: c.textPrimary)),
              const Spacer(),
              _TabPill(
                tabs: const ['Gainers', 'Losers'],
                controller: _tabs,
                gainColor: c.priceUp,
                lossColor: c.priceDown,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── List ────────────────────────────────────────────────────────────────
        SizedBox(
          height: 248,
          child: TabBarView(
            controller: _tabs,
            children: [
              // Gainers tab
              home.isLoading && home.gainers.isEmpty
                  ? const ShimmerRow()
                  : home.error != null && home.gainers.isEmpty
                      ? AppErrorView(
                          error: home.error!,
                          onRetry: () => ref.read(homeProvider).refresh(),
                        )
                      : _MoverList(securities: home.gainers, isGainers: true, sectorFor: home.sectorFor),
              // Losers tab
              home.isLoading && home.losers.isEmpty
                  ? const ShimmerRow()
                  : home.error != null && home.losers.isEmpty
                      ? AppErrorView(
                          error: home.error!,
                          onRetry: () => ref.read(homeProvider).refresh(),
                        )
                      : _MoverList(securities: home.losers, isGainers: false, sectorFor: home.sectorFor),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Pill-style tab selector ────────────────────────────────────────────────────
class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.tabs,
    required this.controller,
    required this.gainColor,
    required this.lossColor,
  });

  final List<String> tabs;
  final TabController controller;
  final Color gainColor;
  final Color lossColor;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: c.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (i) {
          final selected = controller.index == i;
          final activeColor = i == 0 ? gainColor : lossColor;
          return GestureDetector(
            onTap: () => controller.animateTo(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: selected ? activeColor.withAlpha(26) : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                border: selected
                    ? Border.all(color: activeColor.withAlpha(51))
                    : null,
              ),
              child: Text(
                tabs[i],
                style: AppTextStyles.labelSm.copyWith(
                  color: selected ? activeColor : c.textMuted,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Mover list ─────────────────────────────────────────────────────────────────
class _MoverList extends StatelessWidget {
  const _MoverList({
    required this.securities,
    required this.isGainers,
    required this.sectorFor,
  });

  final List securities;
  final bool isGainers;
  final String? Function(String) sectorFor;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    if (securities.isEmpty) {
      return Center(
        child: Text('No data', style: AppTextStyles.body.copyWith(color: c.textMuted)),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: securities.length,
      itemBuilder: (context, i) {
        final s = securities[i];
        final isLast = i == securities.length - 1;
        return _MoverRow(security: s, isLast: isLast, sectorFor: sectorFor);
      },
    );
  }
}

class _MoverRow extends StatelessWidget {
  const _MoverRow({
    required this.security,
    required this.isLast,
    required this.sectorFor,
  });

  final dynamic security;
  final bool isLast;
  final String? Function(String) sectorFor;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: () => context.push(AppRoutes.stockDetailPath(security.symbol), extra: sectorFor(security.symbol)),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenH,
          vertical: AppSpacing.listItemV,
        ),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: c.border, width: 0.5),
                ),
              ),
        child: Row(
          children: [
            // Symbol + name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(security.symbol, style: AppTextStyles.labelLg.copyWith(color: c.textPrimary)),
                  const SizedBox(height: 2),
                  Text(
                    security.name ?? '',
                    style: AppTextStyles.labelSm.copyWith(color: c.textMuted, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Price + badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Fmt.price(security.closePrice),
                  style: AppTextStyles.priceMedium.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 3),
                if (security.changePercent != null)
                  PriceChangeBadge(value: security.changePercent!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
