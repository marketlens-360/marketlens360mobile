import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/data/models/fund.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

// ── Category → color mapping ──────────────────────────────────────────────────

Color _categoryColor(String? category) {
  final s = (category ?? '').toLowerCase();
  if (s.contains('money') || s.contains('mmf'))    return const Color(0xFF2563EB);
  if (s.contains('equity'))                         return const Color(0xFF7C3AED);
  if (s.contains('fixed') || s.contains('fif'))    return const Color(0xFF0D9488);
  if (s.contains('balanced') || s.contains('bal')) return const Color(0xFFD97706);
  if (s.contains('special') || s.contains('spf'))  return const Color(0xFFDB2777);
  return const Color(0xFF0369A1);
}

// ── Tile ──────────────────────────────────────────────────────────────────────

class FundListTile extends StatefulWidget {
  const FundListTile({super.key, required this.fund});

  final Fund fund;

  @override
  State<FundListTile> createState() => _FundListTileState();
}

class _FundListTileState extends State<FundListTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnim;

  Fund get fund => widget.fund;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      _expanded ? _controller.forward() : _controller.reverse();
    });
  }

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
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color  = _categoryColor(fund.category);
    final returnColor = (fund.return1y ?? 0) >= 0 ? c.priceUp : c.priceDown;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: c.border, width: 1),
        boxShadow: isDark
            ? null
            : [
                const BoxShadow(
                  color: Color(0x0A0F172A),
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: AppSpacing.cardRadius,
        child: InkWell(
          onTap: _toggle,
          borderRadius: AppSpacing.cardRadius,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // ── Main row ─────────────────────────────────────────────────
                Row(
                  children: [
                    // Category avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withAlpha(isDark ? 30 : 20),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(
                          color: color.withAlpha(isDark ? 60 : 40),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(IconService.funds, size: 22, color: color),
                    ),
                    const SizedBox(width: 12),

                    // Manager + name + category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (fund.managerName != null) ...[
                            Text(
                              fund.managerName!.toUpperCase(),
                              style: AppTextStyles.sectionLabel.copyWith(
                                color: color,
                                fontSize: 8,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                          ],
                          Text(
                            fund.name ?? '—',
                            style: AppTextStyles.titleSm.copyWith(
                              color: c.textPrimary,
                              letterSpacing: 0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (fund.code != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              fund.code!,
                              style: AppTextStyles.caption.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 1Y return + risk badge
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Fmt.pct(fund.return1y),
                          style: AppTextStyles.priceMedium.copyWith(
                            color: returnColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (fund.riskLevel != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
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
                      ],
                    ),

                    const SizedBox(width: 8),

                    // Expand chevron
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5).animate(_expandAnim),
                      child: Icon(
                        Icons.expand_more_rounded,
                        size: 20,
                        color: c.textMuted,
                      ),
                    ),
                  ],
                ),

                // ── Expanded panel ───────────────────────────────────────────
                SizeTransition(
                  sizeFactor: _expandAnim,
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      Divider(color: c.border, height: 1),
                      const SizedBox(height: AppSpacing.md),

                      // Returns row
                      Row(
                        children: [
                          _MetricCell(
                            label: '1Y RETURNS',
                            value: '${Fmt.pct(fund.return1y)} (2024)',
                            valueColor: (fund.return1y ?? 0) >= 0
                                ? c.priceUp
                                : c.priceDown,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _MetricCell(
                            label: '3Y RETURNS',
                            value: fund.return3y != null
                                ? '${Fmt.pct(fund.return3y)} (2024)'
                                : '—',
                            valueColor: (fund.return3y ?? 0) >= 0
                                ? c.priceUp
                                : c.priceDown,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          _MetricCell(
                            label: 'AUM',
                            value: Fmt.kesCompact(fund.aum),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _MetricCell(
                            label: 'MIN INVESTMENT',
                            value: Fmt.kesCompact(fund.minimumInvestment),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _MetricCell(
                            label: 'MGMT FEE',
                            value: Fmt.pctAbs(fund.managementFee),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // CTA button
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: FilledButton.icon(
                          onPressed: () => context.push(
                              AppRoutes.fundDetailPath(fund.id),
                              extra: {'code': fund.code, 'category': fund.category},
                            ),
                          icon: const Icon(IconService.analytics, size: 16),
                          label: const Text('VIEW FUND ANALYSIS'),
                          style: FilledButton.styleFrom(
                            backgroundColor: c.primary,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.buttonRadius,
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mini metric cell ──────────────────────────────────────────────────────────

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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: c.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
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
            const SizedBox(height: 3),
            Text(
              value,
              style: AppTextStyles.priceSmall.copyWith(
                color: valueColor ?? c.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
