import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/app_empty_view.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/features/stock_detail/providers/stock_detail_providers.dart';

class DividendsTab extends ConsumerWidget {
  const DividendsTab({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dividendsAsync = ref.watch(dividendsProvider(symbol));

    return dividendsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorView(
        error: e,
        onRetry: () => ref.invalidate(dividendsProvider(symbol)),
      ),
      data: (dividends) {
        if (dividends.isEmpty) {
          return const AppEmptyView(message: 'No dividend history');
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          itemCount: dividends.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final d = dividends[i];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withAlpha(30),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      Fmt.dateShort(d.exDate),
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      d.type ?? 'Dividend',
                      style: AppTextStyles.labelMd,
                    ),
                  ),
                  Text(
                    'KES ${Fmt.price(d.amount)}',
                    style: AppTextStyles.priceMedium,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
