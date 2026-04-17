import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';

class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
    required this.selected,
    required this.onPeriodChanged,
  });

  final String selected;
  final ValueChanged<String> onPeriodChanged;

  static const _periods = ['1D', '1W', '1M', '1Y', 'ALL'];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: c.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Row(
                children: _periods
                    .map((p) => Expanded(
                          child: _PeriodBtn(
                            period: p,
                            isSelected: p == selected,
                            onTap: () => onPeriodChanged(p),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _IconBtn(icon: Icons.candlestick_chart_outlined, c: c),
          const SizedBox(width: 6),
          _IconBtn(icon: Icons.settings_ethernet, c: c),
        ],
      ),
    );
  }
}

class _PeriodBtn extends StatelessWidget {
  const _PeriodBtn({
    required this.period,
    required this.isSelected,
    required this.onTap,
  });

  final String period;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? c.surfaceContainerLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(18),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            period,
            style: AppTextStyles.labelMd.copyWith(
              color: isSelected ? c.primary : c.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.c});

  final IconData icon;
  final AppColorsData c;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Icon(icon, size: 18, color: c.textSecondary),
    );
  }
}
