import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/price_change_badge.dart';
import 'package:marketlens360mobile/data/models/security.dart';

class SecurityListTile extends StatefulWidget {
  const SecurityListTile({super.key, required this.security});

  final Security security;

  @override
  State<SecurityListTile> createState() => _SecurityListTileState();
}

class _SecurityListTileState extends State<SecurityListTile>
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
    _expandAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final s = widget.security;
    final isUp = (s.changePercent ?? 0) >= 0;

    return Column(
      children: [
        // ── Main row ───────────────────────────────────────────────────────
        InkWell(
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenH,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                // Symbol + name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.symbol,
                        style: AppTextStyles.labelLg.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.name ?? '',
                        style: AppTextStyles.caption.copyWith(color: c.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Price + sparkline
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Fmt.price(s.closePrice),
                      style: AppTextStyles.priceMedium.copyWith(
                        color: c.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _Sparkline(isUp: isUp),
                  ],
                ),

                const SizedBox(width: 10),

                // Change badge + expand arrow
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (s.changePercent != null)
                      PriceChangeBadge(value: s.changePercent!),
                    const SizedBox(width: 6),
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5).animate(_expandAnim),
                      child: Icon(
                        Icons.expand_more,
                        size: 18,
                        color: c.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Expanded content ───────────────────────────────────────────────
        SizeTransition(
          sizeFactor: _expandAnim,
          child: Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.md,
            ),
            child: Column(
              children: [
                // Updated time row
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: c.surfaceContainerLow.withAlpha(120),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: c.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: c.primary),
                      const SizedBox(width: 6),
                      Text(
                        'UPDATED: ${_formattedNow()}',
                        style: AppTextStyles.sectionLabel.copyWith(
                          color: c.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Metrics mini-grid
                Row(
                  children: [
                    _MiniMetric(label: 'P/E RATIO', value: '—'),
                    const SizedBox(width: AppSpacing.sm),
                    _MiniMetric(label: 'EPS (KES)', value: '—'),
                    const SizedBox(width: AppSpacing.sm),
                    _MiniMetric(
                      label: 'MKT CAP',
                      value: _compactCap(s.marketCap),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // VIEW FULL ANALYSIS button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push(
                      AppRoutes.stockDetailPath(s.symbol),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      elevation: 0,
                    ),
                    icon: const Text(
                      'VIEW FULL ANALYSIS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    label: const Icon(Icons.arrow_forward, size: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formattedNow() {
    final now = DateTime.now();
    final months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    final hour = now.hour > 12 ? now.hour - 12 : now.hour == 0 ? 12 : now.hour;
    final amPm = now.hour >= 12 ? 'PM' : 'AM';
    final min = now.minute.toString().padLeft(2, '0');
    return '${months[now.month - 1]} ${now.day}, ${now.year}, $hour:$min $amPm';
  }

  String _compactCap(double? cap) {
    if (cap == null) return '—';
    if (cap >= 1e9) return '${(cap / 1e9).toStringAsFixed(1)}B';
    if (cap >= 1e6) return '${(cap / 1e6).toStringAsFixed(1)}M';
    return cap.toStringAsFixed(0);
  }
}

// ── Sparkline painter ──────────────────────────────────────────────────────────

class _Sparkline extends StatelessWidget {
  const _Sparkline({required this.isUp});

  final bool isUp;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return CustomPaint(
      size: const Size(56, 16),
      painter: _SparklinePainter(
        isUp: isUp,
        color: isUp ? c.priceUp : c.priceDown,
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.isUp, required this.color});

  final bool isUp;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width;
    final h = size.height;

    if (isUp) {
      // Gently rising with slight noise
      final pts = [
        Offset(0, h * 0.75),
        Offset(w * 0.15, h * 0.55),
        Offset(w * 0.30, h * 0.65),
        Offset(w * 0.50, h * 0.35),
        Offset(w * 0.65, h * 0.45),
        Offset(w * 0.82, h * 0.20),
        Offset(w, h * 0.25),
      ];
      path.moveTo(pts[0].dx, pts[0].dy);
      for (int i = 1; i < pts.length; i++) {
        final cp = Offset(
          (pts[i - 1].dx + pts[i].dx) / 2,
          (pts[i - 1].dy + pts[i].dy) / 2,
        );
        path.quadraticBezierTo(pts[i - 1].dx, pts[i - 1].dy, cp.dx, cp.dy);
      }
      path.lineTo(pts.last.dx, pts.last.dy);
    } else {
      // Gently falling with slight noise
      final pts = [
        Offset(0, h * 0.25),
        Offset(w * 0.15, h * 0.40),
        Offset(w * 0.30, h * 0.30),
        Offset(w * 0.50, h * 0.55),
        Offset(w * 0.65, h * 0.45),
        Offset(w * 0.82, h * 0.70),
        Offset(w, h * 0.85),
      ];
      path.moveTo(pts[0].dx, pts[0].dy);
      for (int i = 1; i < pts.length; i++) {
        final cp = Offset(
          (pts[i - 1].dx + pts[i].dx) / 2,
          (pts[i - 1].dy + pts[i].dy) / 2,
        );
        path.quadraticBezierTo(pts[i - 1].dx, pts[i - 1].dy, cp.dx, cp.dy);
      }
      path.lineTo(pts.last.dx, pts.last.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.isUp != isUp || old.color != color;
}

// ── Mini metric chip ───────────────────────────────────────────────────────────

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 8,
        ),
        decoration: BoxDecoration(
          color: c.surfaceContainerLow.withAlpha(80),
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
                color: c.textPrimary,
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
