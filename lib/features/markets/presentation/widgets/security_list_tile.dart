import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/utils/formatters.dart';
import 'package:marketlens360mobile/core/widgets/price_change_badge.dart';
import 'package:marketlens360mobile/data/models/security.dart';

class SecurityListTile extends StatelessWidget {
  const SecurityListTile({super.key, required this.security});

  final Security security;

  static const _avatarColors = [
    Color(0xFF004AC6),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFF0D9488),
    Color(0xFFD97706),
  ];

  Color _avatarColor() {
    final idx = security.symbol.isNotEmpty
        ? security.symbol.codeUnitAt(0) % _avatarColors.length
        : 0;
    return _avatarColors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final avatarColor = _avatarColor();

    return InkWell(
      onTap: () => context.push(AppRoutes.stockDetailPath(security.symbol)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenH, vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            // ── Symbol avatar ────────────────────────────────────────────────
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: avatarColor.withAlpha(26),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: avatarColor.withAlpha(51)),
              ),
              alignment: Alignment.center,
              child: Text(
                security.symbol.length >= 4
                    ? security.symbol.substring(0, 4)
                    : security.symbol,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: avatarColor,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Name ─────────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(security.symbol, style: AppTextStyles.labelLg.copyWith(color: c.textPrimary)),
                  const SizedBox(height: 2),
                  Text(
                    security.name ?? '',
                    style: AppTextStyles.caption.copyWith(color: c.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── Price + change ────────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Fmt.price(security.closePrice),
                  style: AppTextStyles.priceMedium.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 4),
                if (security.changePercent != null)
                  PriceChangeBadge(value: security.changePercent!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
