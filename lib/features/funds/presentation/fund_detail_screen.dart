import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/app_card.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/core/widgets/shimmer_list.dart';
import 'package:marketlens360mobile/features/funds/providers/funds_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';
import 'widgets/monthly_performance_chart.dart';
import 'widgets/portfolio_allocation_chart.dart';
import 'widgets/yearly_performance_chart.dart';

class FundDetailScreen extends ConsumerWidget {
  const FundDetailScreen({super.key, required this.fundId});

  final int fundId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(fundDetailProvider(fundId));
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 20, color: c.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'MarketLens360',
          style: AppTextStyles.titleSm.copyWith(color: c.primary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: c.surfaceContainer,
              child: Icon(IconService.profile, size: 16, color: c.primary),
            ),
          ),
        ],
      ),
      body: () {
        if (detail.isLoading && detail.fund == null) {
          return const ShimmerList(itemCount: 8);
        }
        if (detail.error != null && detail.fund == null) {
          return AppErrorView(
            error: detail.error!,
            onRetry: () => ref.read(fundDetailProvider(fundId)).refresh(),
          );
        }
        final fund = detail.fund;
        if (fund == null) return const SizedBox.shrink();

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.sm,
                AppSpacing.screenH,
                AppSpacing.xxl * 2,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Breadcrumb + Invest Now ────────────────────────────────
                  Row(
                    children: [
                      Text(
                        'FUNDS',
                        style: AppTextStyles.sectionLabel.copyWith(
                          color: c.textMuted,
                          fontSize: 9,
                        ),
                      ),
                      Icon(
                        IconService.chevronRight,
                        size: 12,
                        color: c.textMuted,
                      ),
                      Expanded(
                        child: Text(
                          (fund.name ?? '—').toUpperCase(),
                          style: AppTextStyles.sectionLabel.copyWith(
                            color: c.primary,
                            fontSize: 9,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: Icon(IconService.add, size: 16),
                        label: const Text('Invest Now'),
                        style: FilledButton.styleFrom(
                          backgroundColor: c.primary,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppSpacing.cardRadius,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Hero section ───────────────────────────────────────────
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: c.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusLg),
                                border: Border.all(color: c.border),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                IconService.funds,
                                size: 24,
                                color: c.primary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fund.name ?? '—',
                                    style: AppTextStyles.titleLg
                                        .copyWith(color: c.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Asset Class: ${fund.category ?? 'Cash & Equivalents'} • ${fund.riskLevel ?? 'N/A'} Risk',
                                    style: AppTextStyles.body
                                        .copyWith(color: c.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Yield + currency
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CURRENT YIELD (ANNUALIZED)',
                                    style: AppTextStyles.sectionLabel.copyWith(
                                      color: c.textMuted,
                                      fontSize: 9,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        Fmt.pct(fund.return1y),
                                        style:
                                            AppTextStyles.displayMd.copyWith(
                                          color: c.secondary,
                                          fontSize: 26,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.trending_up,
                                            size: 12,
                                            color: c.secondary,
                                          ),
                                          Text(
                                            '+0.2%',
                                            style: AppTextStyles.caption
                                                .copyWith(color: c.secondary),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FUND CURRENCY',
                                  style: AppTextStyles.sectionLabel.copyWith(
                                    color: c.textMuted,
                                    fontSize: 9,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'KES',
                                  style: AppTextStyles.titleLg
                                      .copyWith(color: c.textPrimary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'RISK PROFILE',
                          style: AppTextStyles.sectionLabel.copyWith(
                            color: c.textMuted,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _RiskProfileDots(riskLevel: fund.riskLevel),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Key metrics grid ───────────────────────────────────────
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 2.2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      _MetricTile(
                        label: 'ASSETS UNDER MGT',
                        value: Fmt.kesCompact(fund.aum),
                      ),
                      _MetricTile(
                        label: 'MANAGEMENT FEE',
                        value: Fmt.pctAbs(fund.managementFee),
                      ),
                      _MetricTile(
                        label: 'INCEPTION DATE',
                        value: Fmt.date(fund.inceptionDate),
                      ),
                      _MetricTile(
                        label: 'MIN. INVESTMENT',
                        value: Fmt.kes(fund.minimumInvestment),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Yield performance chart ────────────────────────────────
                  Text(
                    'Yield Performance Analysis',
                    style: AppTextStyles.titleMd.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trailing 12-month annualized yield trends',
                    style: AppTextStyles.body.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  _PeriodSelector(),
                  const SizedBox(height: 12),
                  detail.isLoading
                      ? const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : YearlyPerformanceChart(data: detail.yearlyPerf),
                  const SizedBox(height: 24),

                  // ── Monthly performance chart ──────────────────────────────
                  Text(
                    'Monthly Returns',
                    style: AppTextStyles.titleMd.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  detail.isLoading
                      ? const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : MonthlyPerformanceChart(data: detail.monthlyPerf),
                  const SizedBox(height: 24),

                  // ── Investment objective ───────────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: c.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Investment Objective',
                        style: AppTextStyles.titleMd
                            .copyWith(color: c.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This fund aims to provide a high level of current income while maintaining capital preservation and liquidity.',
                          style: AppTextStyles.body.copyWith(
                            color: c.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...[
                          'High liquidity with withdrawal processing within 48 hours.',
                          'Professional management focused on interest rate optimization.',
                          'Ideal for emergency funds or parking capital between investments.',
                        ].map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  IconService.check,
                                  size: 18,
                                  color: c.secondary,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: AppTextStyles.body
                                        .copyWith(color: c.textPrimary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Portfolio allocation ───────────────────────────────────
                  Text(
                    'Portfolio Allocation',
                    style: AppTextStyles.titleMd.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  detail.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PortfolioAllocationChart(holdings: detail.holdings),
                  const SizedBox(height: 24),

                  // ── Fund management ────────────────────────────────────────
                  Row(
                    children: [
                      Icon(
                        Icons.person_search_outlined,
                        size: 18,
                        color: c.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Fund Management',
                        style: AppTextStyles.titleMd
                            .copyWith(color: c.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: c.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusLg),
                                border: Border.all(color: c.border),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                IconService.profile,
                                size: 36,
                                color: c.textMuted,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fund.managerName ?? '—',
                                    style: AppTextStyles.titleMd
                                        .copyWith(color: c.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Portfolio Manager',
                                    style: AppTextStyles.labelMd.copyWith(
                                      color: c.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'VIEW PROFILE',
                                        style: AppTextStyles.sectionLabel
                                            .copyWith(
                                          color: c.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        IconService.arrowRight,
                                        size: 12,
                                        color: c.primary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _DocumentButton(
                                icon: Icons.description_outlined,
                                label: 'FACT SHEET (PDF)',
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _DocumentButton(
                                icon: Icons.history_outlined,
                                label: 'PROSPECTUS',
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      }(),
    );
  }
}

// ── Risk profile dots ──────────────────────────────────────────────────────────
class _RiskProfileDots extends StatelessWidget {
  const _RiskProfileDots({required this.riskLevel});

  final String? riskLevel;

  int get _level => switch ((riskLevel ?? '').toLowerCase()) {
        'low'    => 1,
        'medium' => 2,
        'high'   => 3,
        _        => 0,
      };

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final activeColor = switch (_level) {
      1 => c.secondary,
      2 => c.tertiary,
      3 => c.priceDown,
      _ => c.textMuted,
    };

    return Row(
      children: List.generate(3, (i) {
        final isActive = i < _level;
        return Container(
          width: 24,
          height: 4,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: isActive ? activeColor : c.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

// ── Metric tile ────────────────────────────────────────────────────────────────
class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.surfaceContainerLow,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.sectionLabel.copyWith(
              color: c.textMuted,
              fontSize: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.titleSm.copyWith(color: c.textPrimary),
          ),
        ],
      ),
    );
  }
}

// ── Period selector ────────────────────────────────────────────────────────────
class _PeriodSelector extends StatefulWidget {
  @override
  State<_PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<_PeriodSelector> {
  int _selected = 0;
  static const _periods = ['1Y', '3Y', '5Y', 'MAX'];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_periods.length, (i) {
          final isSelected = _selected == i;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? c.surfaceContainerLowest
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusMd),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 4,
                        )
                      ]
                    : null,
              ),
              child: Text(
                _periods[i],
                style: AppTextStyles.labelMd.copyWith(
                  color: isSelected ? c.primary : c.textMuted,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Document button ────────────────────────────────────────────────────────────
class _DocumentButton extends StatelessWidget {
  const _DocumentButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: c.surfaceContainerLowest,
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusMd),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: c.primary),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.sectionLabel.copyWith(
                  color: c.textPrimary,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
