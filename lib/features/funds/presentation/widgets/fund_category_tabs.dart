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
      (null, 'ALL FUNDS'),
      (FundCategory.mmf, 'MONEY MARKET'),
      (FundCategory.fif, 'FIXED INCOME'),
      (FundCategory.bal, 'BALANCED'),
      (FundCategory.equity, 'EQUITY'),
      (FundCategory.spf, 'SPECIAL'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Row(
        children: categories
            .map((cat) => _CategoryChip(
                  label: cat.$2,
                  isSelected: selected == cat.$1,
                  onTap: () => ref.read(fundsProvider).setCategory(cat.$1),
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
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(
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
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.labelMd.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : c.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
