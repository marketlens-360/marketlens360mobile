import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/local/app_database.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

class AlertTile extends ConsumerWidget {
  const AlertTile({super.key, required this.alert});

  final AlertTableData alert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(appDatabaseProvider);
    final isAbove = alert.direction == 'above';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.xs,
      ),
      leading: Icon(
        isAbove ? IconService.arrowUp : IconService.arrowDown,
        color: isAbove ? AppColors.priceUp : AppColors.priceDown,
        size: 20,
      ),
      title: Text(alert.symbol, style: AppTextStyles.labelLg),
      subtitle: Text(
        '${isAbove ? 'Above' : 'Below'} ${Fmt.price(alert.targetPrice)}',
        style: AppTextStyles.labelSm,
      ),
      trailing: IconButton(
        icon: const Icon(IconService.delete, size: 20),
        color: AppColors.textMuted,
        onPressed: () => db.deleteAlert(alert.id),
      ),
    );
  }
}
