import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/app_bars.dart';
import 'package:marketlens360mobile/core/widgets/app_card.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/core/widgets/shimmer_list.dart';
import 'package:marketlens360mobile/features/funds/providers/funds_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';
import 'widgets/yearly_performance_chart.dart';

class FundDetailScreen extends ConsumerWidget {
  const FundDetailScreen({
    super.key,
    required this.fundId,
    this.initialCode,
    this.initialCategory,
  });

  final int fundId;
  final String? initialCode;
  final String? initialCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(fundDetailProvider(fundId));
    final c = AppColors.of(context);
    final category = initialCategory ?? detail.fund?.category;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppDetailBar(
        title: initialCode ?? detail.fund?.code ?? detail.fund?.name ?? 'Fund',
        subtitle: category,
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
                  SizedBox(height: 16),

                  // ── Hero card ────────────────────────────────────────────────
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fund identity
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: c.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusLg,
                                  ),
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
                                      style: AppTextStyles.titleLg.copyWith(
                                        color: c.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Asset Class: ${fund.category ?? 'Cash & Equivalents'} • ${fund.riskLevel ?? 'N/A'} Risk',
                                      style: AppTextStyles.body.copyWith(
                                        color: c.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(color: c.border, height: 1),

                        // Yield + risk
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CURRENT YIELD (ANNUALIZED)',
                                          style: AppTextStyles.sectionLabel
                                              .copyWith(
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
                                              fund.return1y != null
                                                  ? '${fund.return1y!.toStringAsFixed(2)}%'
                                                  : '—',
                                              style: AppTextStyles.displayMd
                                                  .copyWith(
                                                    color: c.secondary,
                                                    fontSize: 26,
                                                  ),
                                            ),
                                            if (fund.return1m != null) ...[
                                              const SizedBox(width: 6),
                                              Row(
                                                children: [
                                                  Icon(
                                                    (fund.return1m ?? 0) >= 0
                                                        ? Icons.trending_up
                                                        : Icons.trending_down,
                                                    size: 12,
                                                    color:
                                                        (fund.return1m ?? 0) >=
                                                                0
                                                            ? c.secondary
                                                            : c.priceDown,
                                                  ),
                                                  Text(
                                                    Fmt.pct(fund.return1m),
                                                    style: AppTextStyles.caption
                                                        .copyWith(
                                                          color:
                                                              (fund.return1m ??
                                                                          0) >=
                                                                      0
                                                                  ? c.secondary
                                                                  : c.priceDown,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'FUND CURRENCY',
                                        style: AppTextStyles.sectionLabel
                                            .copyWith(
                                              color: c.textMuted,
                                              fontSize: 9,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'KES',
                                        style: AppTextStyles.titleLg.copyWith(
                                          color: c.textPrimary,
                                        ),
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
                              _RiskProfileBar(riskLevel: fund.riskLevel),
                            ],
                          ),
                        ),

                        Divider(color: c.border, height: 1),

                        // Key metrics 2×2 table
                        _MetricsTable(
                          aum: Fmt.kesCompact(fund.aum),
                          fee:
                              fund.managementFee != null
                                  ? '${fund.managementFee!.toStringAsFixed(1)}% p.a.'
                                  : '—',
                          inception: _fmtMonthYear(fund.inceptionDate),
                          minInvest: Fmt.kes(fund.minimumInvestment),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Yield performance chart ──────────────────────────────────
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
                  const _PeriodSelector(),
                  const SizedBox(height: 12),
                  YearlyPerformanceChart(data: detail.yearlyPerf),
                  const SizedBox(height: 24),

                  // ── Investment objective ─────────────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: c.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Investment Objective',
                        style: AppTextStyles.titleMd.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The ${fund.name ?? 'fund'} aims to provide a high level of current income while maintaining capital preservation and liquidity. The fund invests primarily in short-term interest-bearing instruments, including government securities, commercial paper, and corporate deposits.',
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
                          Icon(IconService.check, size: 18, color: c.secondary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style: AppTextStyles.body.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Fund management ──────────────────────────────────────────
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
                        style: AppTextStyles.titleMd.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  AppSpacing.radiusLg,
                                ),
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
                                    style: AppTextStyles.titleMd.copyWith(
                                      color: c.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Lead Portfolio Manager',
                                    style: AppTextStyles.labelMd.copyWith(
                                      color: c.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'An experienced investment professional with deep expertise in East African capital markets, focused on delivering consistent risk-adjusted returns.',
                                    style: AppTextStyles.body.copyWith(
                                      color: c.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                'VIEW PROFILE',
                                style: AppTextStyles.sectionLabel.copyWith(
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Documents row ────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _DocumentButton(
                          icon: Icons.description_outlined,
                          label: 'FACT SHEET\n(PDF)',
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
                ]),
              ),
            ),
          ],
        );
      }(),
    );
  }

  /// Formats an ISO date string as e.g. "OCT 2014".
  static String _fmtMonthYear(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '—';
    try {
      final dt = DateTime.parse(isoString);
      return DateFormat('MMM yyyy').format(dt).toUpperCase();
    } catch (_) {
      return '—';
    }
  }
}

// ── Risk profile bar ────────────────────────────────────────────────────────────
class _RiskProfileBar extends StatelessWidget {
  const _RiskProfileBar({required this.riskLevel});

  final String? riskLevel;

  int get _level => switch ((riskLevel ?? '').toLowerCase()) {
    'low' => 1,
    'medium' => 2,
    'high' => 3,
    _ => 0,
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
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
            decoration: BoxDecoration(
              color: isActive ? activeColor : c.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}

// ── Metrics 2×2 table inside the hero card ─────────────────────────────────────
class _MetricsTable extends StatelessWidget {
  const _MetricsTable({
    required this.aum,
    required this.fee,
    required this.inception,
    required this.minInvest,
  });

  final String aum;
  final String fee;
  final String inception;
  final String minInvest;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    Widget cell(String label, String value) => Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );

    Widget dividerV() => Container(width: 1, height: 56, color: c.border);

    return Column(
      children: [
        Row(
          children: [
            cell('ASSETS UNDER MGT', aum),
            dividerV(),
            cell('MANAGEMENT FEE', fee),
          ],
        ),
        Divider(color: c.border, height: 1),
        Row(
          children: [
            cell('INCEPTION DATE', inception),
            dividerV(),
            cell('MIN. INVESTMENT', minInvest),
          ],
        ),
      ],
    );
  }
}

// ── Period selector ────────────────────────────────────────────────────────────
class _PeriodSelector extends StatefulWidget {
  const _PeriodSelector();

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color:
                    isSelected ? c.surfaceContainerLowest : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 4,
                          ),
                        ]
                        : null,
              ),
              child: Text(
                _periods[i],
                style: AppTextStyles.labelMd.copyWith(
                  color: isSelected ? c.primary : c.textMuted,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: c.primary),
            ),
            const SizedBox(width: 10),
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
