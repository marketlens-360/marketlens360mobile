import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_card.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(IconService.menu, size: 22, color: c.textSecondary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text('MarketLens360', style: AppTextStyles.titleSm.copyWith(color: c.primary)),
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.lg,
              ),
              children: [
                // ── Welcome header ────────────────────────────────────────────
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.primaryDim,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Text(
                    'AI INTELLIGENCE ENGINE',
                    style: AppTextStyles.sectionLabel.copyWith(
                      color: c.primary, fontSize: 9,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'How can I assist your portfolio today?',
                  style: AppTextStyles.displayMd.copyWith(color: c.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Get real-time insights, technical analysis, and fundamental breakdowns for East African markets.',
                  style: AppTextStyles.body.copyWith(color: c.textMuted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // ── Sample user message ───────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: c.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      "What's the outlook for Safaricom?",
                      style: AppTextStyles.labelMd.copyWith(
                        color: Colors.white, fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── AI response ───────────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c.primary,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: const Icon(Icons.smart_toy_outlined, size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'SAFARICOM PLC (SCOM)',
                                  style: AppTextStyles.sectionLabel.copyWith(
                                    color: c.primary, fontSize: 9,
                                  ),
                                ),
                                Container(
                                  width: 3,
                                  height: 3,
                                  margin: const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: c.textMuted,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(
                                  'Updated 2m ago',
                                  style: AppTextStyles.caption.copyWith(color: c.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: AppTextStyles.body.copyWith(color: c.textPrimary),
                                children: [
                                  const TextSpan(text: 'Safaricom shows '),
                                  TextSpan(
                                    text: 'bullish consolidation',
                                    style: TextStyle(
                                      color: c.secondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(
                                    text:
                                        ' at KES 17.20 support level. Recent EOD data suggests a tightening Bollinger Band squeeze, often preceding a breakout. MACD has crossed neutral territory with increasing volume.',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Embedded metrics card
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: c.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                border: Border.all(color: c.border),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'RESISTANCE TARGET',
                                          style: AppTextStyles.sectionLabel.copyWith(
                                            color: c.textMuted, fontSize: 9,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'KES 18.45',
                                          style: AppTextStyles.titleMd.copyWith(
                                            color: c.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '+2.4%',
                                        style: AppTextStyles.returnMedium.copyWith(
                                          color: c.secondary,
                                        ),
                                      ),
                                      Text(
                                        'Daily Momentum',
                                        style: AppTextStyles.caption.copyWith(
                                          color: c.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Institutional inflow into telcos has increased by 14% this quarter, providing a strong floor for SCOM.',
                              style: AppTextStyles.caption.copyWith(
                                color: c.textMuted,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Quick insight chips ───────────────────────────────────────
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 2.4,
                  children: [
                    _QuickChip(
                      icon: IconService.stocks,
                      label: 'Market Sentiment',
                      onTap: () {},
                    ),
                    _QuickChip(
                      icon: IconService.compare,
                      label: 'Sector Comparison',
                      onTap: () {},
                    ),
                    _QuickChip(
                      icon: Icons.payments_outlined,
                      label: 'Dividend Yields',
                      onTap: () {},
                    ),
                    _QuickChip(
                      icon: IconService.analytics,
                      label: 'Technical Signals',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 100), // space for input bar
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _ChatInput(controller: _controller),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: c.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: c.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: AppTextStyles.sectionLabel.copyWith(
                  color: c.textSecondary, fontSize: 9,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? c.surface : c.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(IconService.attach, size: 20, color: c.textMuted),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.labelMd.copyWith(color: c.textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Ask about any stock or fund...',
                hintStyle: AppTextStyles.labelMd.copyWith(color: c.textMuted, fontSize: 13),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: IconButton(
              icon: Icon(IconService.send, size: 18, color: Colors.white),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
