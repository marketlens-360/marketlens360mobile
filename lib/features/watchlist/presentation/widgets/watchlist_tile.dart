import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/price_change_badge.dart';
import 'package:marketlens360mobile/data/models/security.dart';

class WatchlistTile extends StatelessWidget {
  const WatchlistTile({super.key, required this.summary});

  final SecuritySummary summary;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.xs,
      ),
      title: Text(summary.symbol, style: AppTextStyles.labelLg),
      subtitle: Text(
        summary.name ?? '',
        style: AppTextStyles.labelSm,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(Fmt.price(summary.closePrice), style: AppTextStyles.priceMedium),
          const SizedBox(height: 4),
          if (summary.changePercent != null)
            PriceChangeBadge(value: summary.changePercent!),
        ],
      ),
      onTap: () => context.push(AppRoutes.stockDetailPath(summary.symbol), extra: summary.sector),
    );
  }
}
