import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketlens360mobile/core/router/app_routes.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_card.dart';
import 'package:marketlens360mobile/core/widgets/app_error_view.dart';
import 'package:marketlens360mobile/core/widgets/price_change_badge.dart';
import 'package:marketlens360mobile/core/widgets/shimmer_list.dart';
import 'package:marketlens360mobile/features/home/providers/home_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(IconService.menu, size: 22, color: c.primary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'MarketLens360',
          style: AppTextStyles.titleSm.copyWith(color: c.primary),
        ),
        actions: [
          IconButton(
            icon: Icon(IconService.notifications, size: 22, color: c.textSecondary),
            onPressed: () {},
          ),
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
                  // ── Market Pulse Hero ─────────────────────────────────────
                  _MarketPulseSection(),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Discovery Bento ───────────────────────────────────────
                  Text(
                    'Discovery',
                    style: AppTextStyles.titleLg.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _DiscoveryBento(),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Trending Stocks ────────────────────────────────────────
                  _TrendingStocksSection(),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── AI Sentiment Banner ────────────────────────────────────
                  _AiSentimentBanner(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Market Pulse Hero ──────────────────────────────────────────────────────────
class _MarketPulseSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final home = ref.watch(homeProvider);

    final index = home.indices.isNotEmpty ? home.indices.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MARKET PULSE',
          style: AppTextStyles.sectionLabel.copyWith(
            color: c.textMuted, fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'NSE Index',
          style: AppTextStyles.displayMd.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              // Chart area
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: isDark ? c.surfaceContainer : c.surfaceContainerLowest,
                  borderRadius: AppSpacing.cardRadius,
                ),
                padding: const EdgeInsets.all(16),
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
                                style: AppTextStyles.priceLarge.copyWith(
                                  color: c.textPrimary,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (index != null && index.changeAmount != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      index.changeAmount! >= 0 ? Icons.trending_up : Icons.trending_down,
                                      size: 14,
                                      color: index.changeAmount! >= 0 ? c.priceUp : c.priceDown,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${index.changeAmount! >= 0 ? '+' : ''}${index.changeAmount!.toStringAsFixed(2)} (${index.changePercent?.toStringAsFixed(2) ?? '0.00'}%)',
                                      style: AppTextStyles.returnMedium.copyWith(
                                        color: index.changeAmount! >= 0 ? c.priceUp : c.priceDown,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: c.surfaceContainer,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                            border: Border.all(color: c.border),
                          ),
                          child: Text(
                            'LIVE',
                            style: AppTextStyles.sectionLabel.copyWith(
                              color: c.textMuted, fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Bar chart mockup
                    _SparkBars(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('09:00 AM', style: AppTextStyles.caption.copyWith(color: c.textMuted, fontSize: 9)),
                        Text('12:00 PM', style: AppTextStyles.caption.copyWith(color: c.textMuted, fontSize: 9)),
                        Text('03:00 PM', style: AppTextStyles.caption.copyWith(color: c.textMuted, fontSize: 9)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SparkBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark ? const Color(0xFF1A2540) : const Color(0xFFDCE9FF);
    final activeColor = c.primary;
    // Heights as fractions
    final heights = [0.5, 0.67, 0.33, 0.5, 0.75, 1.0, 0.8, 0.4, 0.5, 0.6, 0.4, 0.83, 1.0];
    final activeIdx = [4, 5, 6, 11, 12]; // highlight some

    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(heights.length, (i) {
          final isActive = activeIdx.contains(i);
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              height: 48 * heights[i],
              decoration: BoxDecoration(
                color: isActive
                    ? (i == heights.length - 1 ? activeColor : activeColor.withAlpha(153))
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
class _DiscoveryBento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Column(
      children: [
        // ── Full-width AI card (if exists) or "Explore Stocks" primary ──────
        Row(
          children: [
            // Explore Stocks — primary (blue)
            Expanded(
              child: _BentoCard(
                color: c.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(IconService.stocks, size: 28, color: Colors.white),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore\nStocks',
                          style: AppTextStyles.titleMd.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'EQUITY MARKET',
                          style: AppTextStyles.sectionLabel.copyWith(
                            color: Colors.white.withAlpha(179), fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () => context.go(AppRoutes.stocks),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Find Funds — secondary
            Expanded(
              child: _BentoCard(
                color: c.surfaceContainerLow,
                border: c.border,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(IconService.funds, size: 28, color: c.primary),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find\nFunds',
                          style: AppTextStyles.titleMd.copyWith(color: c.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'UNIT TRUSTS',
                          style: AppTextStyles.sectionLabel.copyWith(
                            color: c.textMuted, fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () => context.go(AppRoutes.funds),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BentoCard extends StatelessWidget {
  const _BentoCard({
    required this.child,
    required this.color,
    this.border,
    required this.onTap,
  });

  final Widget child;
  final Color color;
  final Color? border;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppSpacing.cardRadius,
          border: border != null ? Border.all(color: border!, width: 1) : null,
        ),
        child: child,
      ),
    );
  }
}

// ── Trending Stocks ────────────────────────────────────────────────────────────
class _TrendingStocksSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final home = ref.watch(homeProvider);

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
                  color: c.primary, fontWeight: FontWeight.w600,
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
          AppCard(
            child: Column(
              children: [
                ...home.gainers.take(3).toList().asMap().entries.map((e) {
                  final i = e.key;
                  final s = e.value;
                  final isLast = i == (home.gainers.take(3).length - 1);
                  return Column(
                    children: [
                      _TrendingStockRow(
                        symbol: s.symbol,
                        name: s.name ?? '',
                        price: s.closePrice,
                        changePercent: s.changePercent,
                      ),
                      if (!isLast) Divider(color: c.border, height: 1),
                    ],
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}

class _TrendingStockRow extends StatelessWidget {
  const _TrendingStockRow({
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercent,
  });

  final String symbol;
  final String name;
  final double? price;
  final double? changePercent;

  static const _avatarColors = [
    Color(0xFF004AC6),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFF0D9488),
    Color(0xFFD97706),
  ];

  Color _avatarColor() {
    final idx = symbol.isNotEmpty ? symbol.codeUnitAt(0) % _avatarColors.length : 0;
    return _avatarColors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final avatarColor = _avatarColor();

    return InkWell(
      onTap: () => context.push(AppRoutes.stockDetailPath(symbol)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenH, vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: avatarColor.withAlpha(26),
                shape: BoxShape.circle,
                border: Border.all(color: avatarColor.withAlpha(51)),
              ),
              alignment: Alignment.center,
              child: Text(
                symbol.isNotEmpty ? symbol[0] : '?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: avatarColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name + symbol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(symbol, style: AppTextStyles.labelLg.copyWith(color: c.textPrimary)),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: AppTextStyles.labelSm.copyWith(color: c.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Price + change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price != null ? 'KES ${price!.toStringAsFixed(2)}' : '—',
                  style: AppTextStyles.priceMedium.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 3),
                if (changePercent != null)
                  PriceChangeBadge(value: changePercent!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── AI Sentiment Banner ────────────────────────────────────────────────────────
class _AiSentimentBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.inverseSurface,
        borderRadius: AppSpacing.cardRadius,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 14, color: c.primary.withAlpha(200)),
                  const SizedBox(width: 6),
                  Text(
                    'MARKET INTELLIGENCE',
                    style: AppTextStyles.sectionLabel.copyWith(
                      color: c.inverseOnSurface.withAlpha(200), fontSize: 9,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: c.tertiary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'COMING SOON',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'AI Sentiment Analysis',
                style: AppTextStyles.titleLg.copyWith(color: c.inverseOnSurface),
              ),
              const SizedBox(height: 6),
              Text(
                'Quantifying investor mood across news and social channels for precise entries.',
                style: AppTextStyles.body.copyWith(
                  color: c.inverseOnSurface.withAlpha(179),
                ),
              ),
            ],
          ),
          Positioned(
            right: -16,
            bottom: -16,
            child: Icon(
              Icons.analytics_outlined,
              size: 100,
              color: c.primary.withAlpha(30),
            ),
          ),
        ],
      ),
    );
  }
}
