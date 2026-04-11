import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/models/dividend.dart';

class CorporateActionTile extends StatelessWidget {
  const CorporateActionTile({super.key, required this.dividend});

  final Dividend dividend;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.warning.withAlpha(30),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(
          Fmt.dateShort(dividend.exDate),
          style: AppTextStyles.labelSm.copyWith(color: AppColors.warning),
        ),
      ),
      title: Text(dividend.symbol ?? '', style: AppTextStyles.labelLg),
      subtitle: Text(dividend.type ?? 'Dividend', style: AppTextStyles.labelSm),
      trailing: Text(
        'KES ${Fmt.price(dividend.amount)}',
        style: AppTextStyles.priceMedium,
      ),
    );
  }
}
