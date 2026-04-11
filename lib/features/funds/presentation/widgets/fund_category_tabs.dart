import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/data/models/fund.dart';
import 'package:marketlens360mobile/features/funds/providers/funds_providers.dart';

class FundCategoryTabs extends ConsumerWidget {
  const FundCategoryTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(fundsProvider).selectedCategory;

    const categories = [
      (null, 'All'),
      (FundCategory.mmf, 'MMF'),
      (FundCategory.equity, 'Equity'),
      (FundCategory.fif, 'Fixed Income'),
      (FundCategory.bal, 'Balanced'),
      (FundCategory.spf, 'Special'),
    ];

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        children: categories
            .map((c) => _CategoryChip(
                  label: c.$2,
                  isSelected: selected == c.$1,
                  onTap: () => ref.read(fundsProvider).setCategory(c.$1),
                ))
            .toList(),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentDim : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.borderMedium,
              width: 0.5,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelMd.copyWith(
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
