import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/features/markets/providers/markets_providers.dart';

class SectorFilterChips extends ConsumerWidget {
  const SectorFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markets  = ref.watch(marketsProvider);
    final sectors  = markets.availableSectors;
    final selected = markets.selectedSector;

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        children: [
          _Chip(
            label: 'All',
            isSelected: selected == null,
            onTap: () => ref.read(marketsProvider).setSector(null),
          ),
          ...sectors.map(
            (s) => _Chip(
              label: s,
              isSelected: selected == s,
              onTap: () => ref.read(marketsProvider).setSector(s),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
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
