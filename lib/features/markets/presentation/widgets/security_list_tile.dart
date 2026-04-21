import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/price_change_badge.dart';
import 'package:marketlens360mobile/data/models/security.dart';

// ── Sector → color mapping ─────────────────────────────────────────────────────

Color _sectorColor(String? sector, String symbol) {
  final s = (sector ?? '').toLowerCase();
  if (s.contains('bank') || s.contains('financ') || s.contains('insurance')) {
    return const Color(0xFF2563EB);
  }
  if (s.contains('telecom') || s.contains('tech')) {
    return const Color(0xFF7C3AED);
  }
  if (s.contains('energy') || s.contains('oil') || s.contains('power')) {
    return const Color(0xFFD97706);
  }
  if (s.contains('manufactur') || s.contains('industri')) {
    return const Color(0xFF0D9488);
  }
  if (s.contains('commercial') || s.contains('retail') || s.contains('consumer')) {
    return const Color(0xFFDB2777);
  }
  if (s.contains('agri') || s.contains('farm')) {
    return const Color(0xFF16A34A);
  }
  // Fallback: hash the symbol for deterministic color
  const palette = [
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFF0D9488),
    Color(0xFFDB2777),
    Color(0xFFD97706),
    Color(0xFF0369A1),
  ];
  final idx = symbol.isNotEmpty ? symbol.codeUnitAt(0) % palette.length : 0;
  return palette[idx];
}

String _compactCap(double? val) {
  if (val == null) return '—';
  if (val >= 1e9) return '${(val / 1e9).toStringAsFixed(1)}B';
  if (val >= 1e6) return '${(val / 1e6).toStringAsFixed(1)}M';
  if (val >= 1e3) return '${(val / 1e3).toStringAsFixed(1)}K';
  return val.toStringAsFixed(0);
}

// ── Reusable tile content (no outer card wrapper) ─────────────────────────────

class SecurityTileContent extends StatefulWidget {
  const SecurityTileContent({
    super.key,
    required this.security,
    this.sectorOverride,
  });

  final Security security;
  final String? sectorOverride;

  @override
  State<SecurityTileContent> createState() => _SecurityTileContentState();
}

class _SecurityTileContentState extends State<SecurityTileContent>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnim;

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

  @override
  Widget build(BuildContext context) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s      = widget.security;
    final sector = widget.sectorOverride ?? s.sector;
    final color  = _sectorColor(sector, s.symbol);

    final initials = s.symbol.length >= 2
        ? s.symbol.substring(0, 2)
        : s.symbol;

    return Material(
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
                  // Sector avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withAlpha(isDark ? 30 : 20),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: color.withAlpha(isDark ? 60 : 40),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: color,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Symbol + name + sector
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.symbol,
                          style: AppTextStyles.titleSm.copyWith(
                            color: c.textPrimary,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.name ?? '',
                          style: AppTextStyles.caption.copyWith(
                            color: c.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (sector != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            sector.toUpperCase(),
                            style: AppTextStyles.sectionLabel.copyWith(
                              color: color,
                              fontSize: 8,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Price + change stacked column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Fmt.price(s.closePrice),
                        style: AppTextStyles.priceMedium.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (s.changePercent != null)
                        PriceChangeBadge(value: s.changePercent!)
                      else
                        Text('—',
                            style: AppTextStyles.caption
                                .copyWith(color: c.textMuted)),
                    ],
                  ),

                  const SizedBox(width: 6),

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

                    // Metrics row
                    Row(
                      children: [
                        _MiniMetric(label: 'MKT CAP', value: _compactCap(s.marketCap)),
                        const SizedBox(width: AppSpacing.sm),
                        _MiniMetric(label: 'VOLUME', value: _compactCap(s.volume)),
                        const SizedBox(width: AppSpacing.sm),
                        _MiniMetric(
                          label: '24H CHG',
                          value: s.changeAmount != null
                              ? '${s.changeAmount! >= 0 ? '+' : ''}KES ${s.changeAmount!.toStringAsFixed(2)}'
                              : '—',
                          valueColor: s.changeAmount != null
                              ? (s.changeAmount! >= 0 ? c.priceUp : c.priceDown)
                              : null,
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
                          AppRoutes.stockDetailPath(s.symbol),
                          extra: sector,
                        ),
                        icon: const Icon(Icons.analytics_outlined, size: 16),
                        label: const Text('VIEW FULL ANALYSIS'),
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
    );
  }
}

// ── Tile (card wrapper around SecurityTileContent) ────────────────────────────

class SecurityListTile extends StatelessWidget {
  const SecurityListTile({super.key, required this.security});

  final Security security;

  @override
  Widget build(BuildContext context) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.xs,
      ),
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
      child: ClipRRect(
        borderRadius: AppSpacing.cardRadius,
        child: SecurityTileContent(security: security),
      ),
    );
  }
}

// ── Mini metric cell ──────────────────────────────────────────────────────────

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
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
