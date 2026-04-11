import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/features/home/providers/home_providers.dart';

class MarketIndicesRow extends ConsumerWidget {
  const MarketIndicesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);

    if (home.isLoading && home.overview == null) return _Skeleton();
    if (home.overview == null) return const SizedBox.shrink();

    final data = home.overview!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Row(
        children: [
          _IndexCard(label: 'NASI', value: data.nasiValue, change: data.nasiChange),
          const SizedBox(width: AppSpacing.sm),
          _IndexCard(label: 'NSE 20', value: data.nse20Value, change: data.nse20Change),
          const SizedBox(width: AppSpacing.sm),
          _IndexCard(label: 'TURNOVER', value: data.totalTurnover, change: null, isCompact: true),
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Row(
        children: List.generate(
          3,
          (i) => Expanded(
            child: Container(
              margin: i < 2 ? const EdgeInsets.only(right: AppSpacing.sm) : EdgeInsets.zero,
              height: 68,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: c.border),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IndexCard extends StatelessWidget {
  const _IndexCard({
    required this.label,
    required this.value,
    required this.change,
    this.isCompact = false,
  });

  final String label;
  final double? value;
  final double? change;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isPositive = (change ?? 0) >= 0;
    final changeColor = change == null
        ? c.textMuted
        : (isPositive ? c.priceUp : c.priceDown);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: c.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.sectionLabel.copyWith(color: c.textMuted)),
            const SizedBox(height: 4),
            Text(
              isCompact ? Fmt.kesCompact(value) : Fmt.price(value),
              style: AppTextStyles.priceSmall.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (change != null) ...[
              const SizedBox(height: 2),
              Text(Fmt.pct(change), style: AppTextStyles.labelSm.copyWith(color: changeColor, fontSize: 10)),
            ],
          ],
        ),
      ),
    );
  }
}
