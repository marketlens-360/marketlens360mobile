import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';

// Placeholder — real portfolio data in Phase 2
class PortfolioSummaryCard extends StatelessWidget {
  const PortfolioSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: c.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'PORTFOLIO VALUE',
                style: AppTextStyles.sectionLabel.copyWith(color: c.textMuted),
              ),
              const Spacer(),
              _LiveIndicator(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('KES —', style: AppTextStyles.priceLarge.copyWith(color: c.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _StatPill(label: "Today's Return", value: '—'),
              const SizedBox(width: AppSpacing.sm),
              _StatPill(label: 'Total Return', value: '—'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveIndicator extends StatefulWidget {
  @override
  State<_LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<_LiveIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _opacity,
          builder: (_, __) => Opacity(
            opacity: _opacity.value,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: c.priceUp, shape: BoxShape.circle),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text('Live', style: AppTextStyles.sectionLabel.copyWith(color: c.priceUp)),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: c.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.sectionLabel.copyWith(color: c.textMuted)),
            const SizedBox(height: 3),
            Text(value, style: AppTextStyles.returnMedium.copyWith(color: c.textPrimary)),
          ],
        ),
      ),
    );
  }
}
