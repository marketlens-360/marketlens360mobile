import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/app_card.dart';
import 'package:marketlens360mobile/data/models/fund.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

class FundListTile extends StatefulWidget {
  const FundListTile({super.key, required this.fund});

  final Fund fund;

  @override
  State<FundListTile> createState() => _FundListTileState();
}

class _FundListTileState extends State<FundListTile> {
  bool _expanded = false;

  Fund get fund => widget.fund;

  Color _riskColor(AppColorsData c) {
    return switch ((fund.riskLevel ?? '').toLowerCase()) {
      'low'    => c.priceUp,
      'medium' => c.tertiary,
      'high'   => c.priceDown,
      _        => c.textMuted,
    };
  }

  Color _riskBg(AppColorsData c) {
    return switch ((fund.riskLevel ?? '').toLowerCase()) {
      'low'    => c.priceUpDim,
      'medium' => c.tertiaryDim,
      'high'   => c.priceDownDim,
      _        => c.surfaceContainer,
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final returnColor =
        (fund.return1y ?? 0) >= 0 ? c.priceUp : c.priceDown;

    return AppCard(
      child: InkWell(
        borderRadius: AppSpacing.cardRadius,
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row ──────────────────────────────────────────────────
              Row(
                children: [
                  // Logo avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: c.border),
                    ),
                    alignment: Alignment.center,
                    child: Icon(IconService.funds, size: 22, color: c.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Manager name
                        Text(
                          (fund.managerName ?? '').toUpperCase(),
                          style: AppTextStyles.sectionLabel.copyWith(
                            color: c.primary,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fund.name ?? '—',
                          style: AppTextStyles.titleSm
                              .copyWith(color: c.textPrimary),
                          maxLines: 2,
                        ),
                        if (fund.code != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            fund.code!,
                            style: AppTextStyles.caption.copyWith(
                              color: c.textMuted,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Risk badge (collapsed only)
                  if (!_expanded && fund.riskLevel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _riskBg(c),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        '${fund.riskLevel!.toUpperCase()} RISK',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: _riskColor(c),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      IconService.chevronDown,
                      size: 18,
                      color: c.textMuted,
                    ),
                  ),
                ],
              ),

              // ── Collapsed: 1Y return ───────────────────────────────────────
              if (!_expanded) ...[
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1Y RETURNS',
                      style: AppTextStyles.sectionLabel.copyWith(
                        color: c.textMuted,
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${Fmt.pct(fund.return1y)} (2024)',
                      style: AppTextStyles.displayMd.copyWith(
                        color: returnColor,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ],

              // ── Expanded: full details ─────────────────────────────────────
              if (_expanded) ...[
                const SizedBox(height: 16),
                // 2-column metrics: 1Y vs 6M returns
                Row(
                  children: [
                    _MetricCell(
                      label: '1Y RETURNS',
                      value: '${Fmt.pct(fund.return1y)} (2024)',
                      valueColor:
                          (fund.return1y ?? 0) >= 0 ? c.priceUp : c.priceDown,
                    ),
                    const SizedBox(width: 8),
                    _MetricCell(
                      label: '6M RETURNS',
                      value: Fmt.pct(fund.return6m),
                      valueColor:
                          (fund.return6m ?? 0) >= 0 ? c.priceUp : c.priceDown,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _MetricCell(
                      label: 'AUM',
                      value: Fmt.kesCompact(fund.aum),
                    ),
                    const SizedBox(width: 8),
                    _MetricCell(
                      label: 'RISK LEVEL',
                      value: fund.riskLevel ?? '—',
                      valueColor: _riskColor(c),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(color: c.border, height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MIN INVESTMENT',
                            style: AppTextStyles.sectionLabel.copyWith(
                              color: c.textMuted,
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            Fmt.kesCompact(fund.minimumInvestment),
                            style: AppTextStyles.titleSm
                                .copyWith(color: c.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'MGMT FEE',
                            style: AppTextStyles.sectionLabel.copyWith(
                              color: c.textMuted,
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            Fmt.pctAbs(fund.managementFee),
                            style: AppTextStyles.titleSm
                                .copyWith(color: c.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // CTA button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton.icon(
                    onPressed: () =>
                        context.push(AppRoutes.fundDetailPath(fund.id)),
                    icon: Icon(IconService.analytics, size: 16),
                    label: const Text('VIEW FUND ANALYSIS'),
                    style: FilledButton.styleFrom(
                      backgroundColor: c.primary,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.cardRadius,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: c.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: c.border),
        ),
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
              style: AppTextStyles.titleSm.copyWith(
                color: valueColor ?? c.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
