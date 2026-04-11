import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/models/fund_ranking.dart';

class FundRankingsList extends StatelessWidget {
  const FundRankingsList({super.key, required this.rankings});

  final List<FundRanking> rankings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rankings.asMap().entries.map((e) {
        final r = e.value;
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH,
            vertical: AppSpacing.xs,
          ),
          leading: CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.accentDim,
            child: Text(
              '${r.rank ?? e.key + 1}',
              style: AppTextStyles.sectionLabel.copyWith(color: AppColors.accent),
            ),
          ),
          title: Text(r.fundName ?? '—', style: AppTextStyles.labelLg, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(r.category ?? '', style: AppTextStyles.labelSm),
          trailing: Text(
            Fmt.pct(r.score),
            style: AppTextStyles.returnMedium.copyWith(
              color: (r.score ?? 0) >= 0 ? AppColors.priceUp : AppColors.priceDown,
            ),
          ),
        );
      }).toList(),
    );
  }
}
