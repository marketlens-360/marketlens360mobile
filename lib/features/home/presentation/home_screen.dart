import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_bars.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/core/widgets/shimmer_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:marketlens360mobile/features/home/providers/home_providers.dart';
import 'package:marketlens360mobile/features/markets/presentation/widgets/security_list_tile.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.background,
      appBar: const AppShellBar(),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeProvider).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH, AppSpacing.lg,
                AppSpacing.screenH, AppSpacing.xxl * 2,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Market Pulse ──────────────────────────────────────────
                  _MarketPulseSection(),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Discovery ─────────────────────────────────────────────
                  Text(
                    'Discovery',
                    style: AppTextStyles.titleLg.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _DiscoveryBento(),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Trending Stocks ───────────────────────────────────────
                  _TrendingStocksSection(),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Academy Promo ─────────────────────────────────────────
                  _AcademyPromo(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Market Pulse ───────────────────────────────────────────────────────────────
class _MarketPulseSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final home   = ref.watch(homeProvider);
    final index  = home.indices.isNotEmpty ? home.indices.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label + heading
        Text(
          'MARKET PULSE',
          style: AppTextStyles.sectionLabel.copyWith(
            color: c.textMuted,
            fontSize: 10,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'NSE Index',
          style: AppTextStyles.displayMd.copyWith(
            color: c.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        // Card
        Container(
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
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index != null && index.value != null
                              ? index.value!.toStringAsFixed(2)
                              : '—',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: c.textPrimary,
                            letterSpacing: -1,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        if (index != null && index.changeAmount != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                index.changeAmount! >= 0
                                    ? Icons.trending_up_rounded
                                    : Icons.trending_down_rounded,
                                size: 16,
                                color: index.changeAmount! >= 0
                                    ? c.priceUp
                                    : c.priceDown,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${index.changeAmount! >= 0 ? '+' : ''}${index.changeAmount!.toStringAsFixed(2)} '
                                '(${index.changePercent?.toStringAsFixed(2) ?? '0.00'}%)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: index.changeAmount! >= 0
                                      ? c.priceUp
                                      : c.priceDown,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? c.surfaceContainerHigh : c.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                      border: Border.all(color: c.border),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: c.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SparkBars(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('09:00 AM', style: _timeLabel(c)),
                  Text('12:00 PM', style: _timeLabel(c)),
                  Text('03:00 PM', style: _timeLabel(c)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle _timeLabel(AppColorsData c) => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: c.textMuted,
      );
}

class _SparkBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor    = isDark ? const Color(0xFF1E2D3D) : const Color(0xFFDBEAFE);
    final activeColor = c.primary;

    final heights    = [0.5, 0.67, 0.33, 0.5, 0.75, 1.0, 0.8, 0.4, 0.5, 0.6, 0.4, 0.83, 1.0];
    final activeIdx  = {4, 5, 6, 11, 12};

    return SizedBox(
      height: 52,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(heights.length, (i) {
          final isActive = activeIdx.contains(i);
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              height: 52 * heights[i],
              decoration: BoxDecoration(
                color: isActive
                    ? (i == heights.length - 1 ? activeColor : activeColor.withAlpha(160))
                    : barColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Discovery Bento ────────────────────────────────────────────────────────────
class _DiscoveryBento extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c    = AppColors.of(context);
    final home = ref.watch(homeProvider);

    final topGainer = home.gainers.isNotEmpty ? home.gainers.first : null;

    return Column(
      children: [
        // ── AI Analysis full-width card ──────────────────────────────────────
        _AiAnalysisCard(),
        const SizedBox(height: AppSpacing.md),
        // ── Two small bento cards ────────────────────────────────────────────
        Row(
          children: [
            // Top Gainer
            Expanded(
              child: _SmallBentoCard(
                iconData: IconService.stocks,
                iconBg: c.priceUp.withAlpha(26),
                iconBorder: c.priceUp.withAlpha(51),
                iconColor: c.priceUp,
                label: 'TOP GAINER',
                title: topGainer?.name ?? topGainer?.symbol ?? '',
                subtitle: topGainer?.changePercent != null
                    ? '+${topGainer!.changePercent!.toStringAsFixed(1)}%'
                    : null,
                subtitleColor: c.priceUp,
                isLoading: home.isLoading && topGainer == null,
                onTap: topGainer != null
                    ? () => context.push(AppRoutes.stockDetailPath(topGainer.symbol), extra: home.sectorFor(topGainer.symbol))
                    : null,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Watchlist CTA
            Expanded(
              child: _SmallBentoCard(
                iconData: IconService.watchlist,
                iconBg: c.primary.withAlpha(26),
                iconBorder: c.primary.withAlpha(51),
                iconColor: c.primary,
                label: 'WATCHLIST',
                title: 'Safaricom',
                subtitle: 'Active Now',
                subtitleColor: c.textMuted,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AiAnalysisCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 192,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: c.aiGradient,
          borderRadius: AppSpacing.cardRadius,
        ),
        child: Stack(
          children: [
            // Watermark icon
            Positioned(
              right: -24,
              bottom: -20,
              child: Icon(
                Icons.rocket_launch_outlined,
                size: 160,
                color: Colors.white.withAlpha(30),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // AI ANALYSIS badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    border: Border.all(color: Colors.white.withAlpha(60)),
                  ),
                  child: const Text(
                    'AI ANALYSIS',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                // Title
                Text(
                  'Energy Sector Set for\nQ4 Expansion',
                  style: AppTextStyles.titleMd.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // Button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Read Insights',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: c.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(IconService.arrowRight, size: 14, color: c.primary),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallBentoCard extends StatelessWidget {
  const _SmallBentoCard({
    required this.iconData,
    required this.iconBg,
    required this.iconBorder,
    required this.iconColor,
    required this.label,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.onTap,
    this.isLoading = false,
  });

  final IconData iconData;
  final Color iconBg;
  final Color iconBorder;
  final Color iconColor;
  final String label;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final c       = AppColors.of(context);
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final base      = isDark ? const Color(0xFF1E2D3D) : const Color(0xFFE2E8F0);
    final highlight = isDark ? const Color(0xFF2A3F57) : const Color(0xFFF1F5F9);

    Widget shimmerBar(double w, double h) => Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: iconBorder),
              ),
              alignment: Alignment.center,
              child: Icon(iconData, size: 20, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: c.textMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            // Title row — shimmer or real text, same height
            isLoading
                ? shimmerBar(88, 16)
                : Text(
                    title,
                    style: AppTextStyles.labelLg.copyWith(
                      color: c.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            const SizedBox(height: 4),
            // Subtitle row — always occupies same height
            isLoading
                ? shimmerBar(56, 13)
                : subtitle != null
                    ? Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: subtitleColor ?? c.textMuted,
                        ),
                      )
                    : const SizedBox(height: 13),
          ],
        ),
      ),
    );
  }
}

// ── Trending Stocks ────────────────────────────────────────────────────────────
class _TrendingStocksSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final home   = ref.watch(homeProvider);

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Trending Stocks',
              style: AppTextStyles.titleMd.copyWith(color: c.textPrimary),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go(AppRoutes.stocks),
              child: Text(
                'See All',
                style: AppTextStyles.labelMd.copyWith(
                  color: c.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (home.isLoading && home.gainers.isEmpty)
          const ShimmerList(itemCount: 3)
        else if (home.error != null && home.gainers.isEmpty)
          AppErrorView(
            error: home.error!,
            onRetry: () => ref.read(homeProvider).refresh(),
          )
        else
          Container(
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
              child: Column(
                children: [
                  // ── Column header ────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 0),
                    height: 34,
                    decoration: BoxDecoration(
                      color: c.surfaceContainerLow,
                      border: Border(bottom: BorderSide(color: c.border, width: 1)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'EQUITY / SYMBOL',
                          style: AppTextStyles.sectionLabel.copyWith(
                            color: c.textMuted,
                            fontSize: 9,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'PRICE (KES)  /  24H CHG',
                          style: AppTextStyles.sectionLabel.copyWith(
                            color: c.textMuted,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ── Rows ────────────────────────────────────────────────
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: home.gainers.take(4).length,
                    separatorBuilder: (ctx, i) => Divider(color: c.border, height: 1),
                    itemBuilder: (ctx, i) {
                      final s = home.gainers.elementAt(i);
                      return SecurityTileContent(
                        security: s,
                        sectorOverride: home.sectorFor(s.symbol),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Academy Promo ──────────────────────────────────────────────────────────────
class _AcademyPromo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF1e1b4b), Color(0xFF312e81)]
              : const [Color(0xFF4338CA), Color(0xFF3730A3)],
        ),
        borderRadius: AppSpacing.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial Architect Academy',
                  style: AppTextStyles.titleSm.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Master the art of high-precision trading with our premium guides.',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withAlpha(200),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enroll for Free',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        IconService.chevronRight,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Transform.rotate(
            angle: 0.22,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(28),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: Colors.white.withAlpha(60)),
              ),
              alignment: Alignment.center,
              child: const Icon(
                IconService.education,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
