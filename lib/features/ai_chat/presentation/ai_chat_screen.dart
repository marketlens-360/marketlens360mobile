import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_bars.dart';
import 'package:marketlens360mobile/services/icon_service.dart';

// ── Message model ─────────────────────────────────────────────────────────────

class _Msg {
  _Msg({required this.text, required this.isUser})
      : id = DateTime.now().microsecondsSinceEpoch.toString(),
        time = DateTime.now();

  final String id;
  final String text;
  final bool isUser;
  final DateTime time;
}

// ── Simulated AI responses ────────────────────────────────────────────────────

String _aiReply(String query) {
  final q = query.toLowerCase();
  if (q.contains('safaricom') || q.contains('scom')) {
    return 'Safaricom (SCOM) is showing bullish consolidation at KES\u00A017.20 support. A Bollinger Band squeeze is detected with MACD crossing neutral — a breakout is likely within the week.\n\nInstitutional inflow into telcos is up 14% this quarter, providing a strong floor.\n\nResistance target: KES\u00A018.45 (+2.4%)';
  }
  if (q.contains('equity bank') || q.contains('eqty')) {
    return 'Equity Bank (EQTY) remains fundamentally strong with a P/E of 5.2x — well below regional peers. Regional expansion into DRC and Rwanda adds growth optionality.\n\nQ2 earnings are due in 3 weeks. Watch for loan-book growth and NIM compression data.\n\nSupport: KES\u00A044.00 · Resistance: KES\u00A049.50';
  }
  if (q.contains('kes') || q.contains('shilling') || q.contains('currency') || q.contains('forex')) {
    return 'The KES has stabilized after CBK\'s rate interventions. USD/KES is currently ~129.40. Forex reserves stand at 4.2 months of import cover — above the 4-month adequacy threshold.\n\nShort-term pressure remains from external debt servicing obligations due in Q3.';
  }
  if (q.contains('mmf') || q.contains('money market')) {
    return 'Money Market Funds are offering average yields of 14.2% p.a. — attractive vs. bank deposits. CIC Money Market and Sanlam MMF lead on returns.\n\nLiquidity is T+1 for most funds, making them ideal for parking short-term capital while earning competitive returns.';
  }
  if (q.contains('dividend') || q.contains('yield')) {
    return 'Top NSE dividend yields right now:\n· BAT Kenya — 12.1%\n· Stanbic Holdings — 8.4%\n· Jubilee Holdings — 6.2%\n\nThe NSE average yield is 4.8%, comparing favourably to the 10-yr T-Bond at 14.3% for investors with lower risk appetite.';
  }
  if (q.contains('market') || q.contains('nse') || q.contains('index') || q.contains('summary')) {
    return 'NSE market snapshot:\n· NSE 20 Index — 1,842 pts (+0.4%)\n· Gainers vs Losers — 23:11\n· Foreign net inflow — KES 340M\n\nBanking and Telco sectors led today\'s rally. Market breadth is positive. Turnover was above the 30-day average by 18%.';
  }
  if (q.contains('kplc') || q.contains('kenya power')) {
    return 'Kenya Power (KPLC) is under pressure from rising fuel costs and distribution losses (currently ~23%). The recent tariff review adds some relief, but execution risk remains elevated.\n\nConsider waiting for Q3 results before entering a position. Short-term downside risk is real.';
  }
  if (q.contains('buy') || q.contains('invest') || q.contains('recommend') || q.contains('best')) {
    return 'Strong setups based on current fundamentals + technicals:\n· EQTY — value play, strong regional growth\n· SCOM — technical breakout incoming\n· KCB — defensive, 7.1% yield provides downside cover\n\n⚠️ This is informational only. Always consult a licensed investment advisor before trading.';
  }
  if (q.contains('hello') || q.contains('hi') || q.contains('hey') || q.contains('how are')) {
    return 'Hello! I\'m your AI market intelligence assistant for East African capital markets.\n\nI can help with stock analysis, fund comparisons, sector insights, and portfolio ideas. What would you like to explore?';
  }
  return 'I\'ve cross-referenced your query against current NSE and regional market data. For precise signals, try asking about a specific ticker (e.g. SCOM, EQTY, KPLC) or a fund category.\n\nOr ask for a full market summary — I\'ll pull the latest snapshot for you.';
}

// ── Screen ────────────────────────────────────────────────────────────────────

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Msg> _messages = [];
  bool _isTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isTyping) return;
    _textController.clear();

    setState(() => _messages.add(_Msg(text: trimmed, isUser: true)));
    _scrollToBottom();

    setState(() => _isTyping = true);
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add(_Msg(text: _aiReply(trimmed), isUser: false));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.background,
      appBar: const AppShellBar(),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _WelcomeView(onChipTap: _send)
                : _ChatView(
                    messages: _messages,
                    isTyping: _isTyping,
                    scrollController: _scrollController,
                  ),
          ),
          _ChatInputBar(
            controller: _textController,
            isTyping: _isTyping,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

// ── Welcome view ──────────────────────────────────────────────────────────────

class _WelcomeView extends StatelessWidget {
  const _WelcomeView({required this.onChipTap});

  final void Function(String) onChipTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH, AppSpacing.xxl,
        AppSpacing.screenH, AppSpacing.lg,
      ),
      children: [
        Center(
          child: Container(
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
        ),
        const SizedBox(height: 16),
        Text(
          'How can I assist\nyour portfolio today?',
          style: AppTextStyles.displayMd.copyWith(color: c.textPrimary, height: 1.2),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Real-time insights, technical analysis, and fundamental breakdowns for East African markets.',
          style: AppTextStyles.body.copyWith(color: c.textMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),
        Text(
          'TRY ASKING',
          style: AppTextStyles.sectionLabel.copyWith(
            color: c.textMuted, fontSize: 9,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 2.5,
          children: [
            _QuickChip(
              icon: IconService.stocks,
              label: 'Market Summary',
              onTap: () => onChipTap('Give me a market summary'),
            ),
            _QuickChip(
              icon: Icons.payments_outlined,
              label: 'Top Dividend Yields',
              onTap: () => onChipTap('What are the top dividend yields?'),
            ),
            _QuickChip(
              icon: IconService.funds,
              label: 'Best MMF Funds',
              onTap: () => onChipTap('What are the best money market funds?'),
            ),
            _QuickChip(
              icon: IconService.analytics,
              label: 'Safaricom Outlook',
              onTap: () => onChipTap('What is the outlook for Safaricom?'),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Chat view ─────────────────────────────────────────────────────────────────

class _ChatView extends StatelessWidget {
  const _ChatView({
    required this.messages,
    required this.isTyping,
    required this.scrollController,
  });

  final List<_Msg> messages;
  final bool isTyping;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final itemCount = messages.length + (isTyping ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH, AppSpacing.md,
        AppSpacing.screenH, AppSpacing.md,
      ),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        if (isTyping && i == messages.length) {
          return const _TypingBubble();
        }
        return _AnimatedMessage(
          key: ValueKey(messages[i].id),
          message: messages[i],
        );
      },
    );
  }
}

// ── Animated message wrapper ──────────────────────────────────────────────────

class _AnimatedMessage extends StatefulWidget {
  const _AnimatedMessage({super.key, required this.message});

  final _Msg message;

  @override
  State<_AnimatedMessage> createState() => _AnimatedMessageState();
}

class _AnimatedMessageState extends State<_AnimatedMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: _MessageBubble(message: widget.message),
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _Msg message;

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI avatar dot
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: c.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? c.primary : c.surface,
                    borderRadius: BorderRadius.only(
                      topLeft:    const Radius.circular(AppSpacing.radiusXl),
                      topRight:   const Radius.circular(AppSpacing.radiusXl),
                      bottomLeft: Radius.circular(
                          isUser ? AppSpacing.radiusXl : 4),
                      bottomRight: Radius.circular(
                          isUser ? 4 : AppSpacing.radiusXl),
                    ),
                    border: isUser
                        ? null
                        : Border.all(color: c.border, width: 1),
                    boxShadow: isUser || isDark
                        ? null
                        : [
                            const BoxShadow(
                              color: Color(0x0A0F172A),
                              offset: Offset(0, 1),
                              blurRadius: 4,
                            ),
                          ],
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.body.copyWith(
                      color: isUser ? Colors.white : c.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.time),
                  style: AppTextStyles.caption.copyWith(
                    color: c.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // User spacer
          if (isUser) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ── Typing indicator bubble ───────────────────────────────────────────────────

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              size: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: const BorderRadius.only(
                topLeft:     Radius.circular(AppSpacing.radiusXl),
                topRight:    Radius.circular(AppSpacing.radiusXl),
                bottomLeft:  Radius.circular(4),
                bottomRight: Radius.circular(AppSpacing.radiusXl),
              ),
              border: Border.all(color: c.border),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final phase = (_ctrl.value * 2 * pi) - (i * pi / 2.5);
                    final dy = sin(phase) * 3.5;
                    return Transform.translate(
                      offset: Offset(0, -dy),
                      child: Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          color: AppColors.of(context).primary.withAlpha(160),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick chip ────────────────────────────────────────────────────────────────

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
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: c.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.labelMd.copyWith(
                  color: c.textSecondary,
                  fontSize: 12,
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

// ── Chat input bar ────────────────────────────────────────────────────────────

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.isTyping,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isTyping;
  final void Function(String) onSend;

  @override
  Widget build(BuildContext context) {
    final c      = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border, width: 1)),
        boxShadow: isDark
            ? null
            : [
                const BoxShadow(
                  color: Color(0x0A0F172A),
                  offset: Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: c.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    border: Border.all(color: c.border),
                  ),
                  child: TextField(
                    controller: controller,
                    style: AppTextStyles.body.copyWith(
                      color: c.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: isTyping
                          ? 'AI is thinking...'
                          : 'Ask about any stock or fund...',
                      hintStyle: AppTextStyles.body.copyWith(
                        color: c.textMuted,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                      isDense: true,
                    ),
                    onSubmitted: onSend,
                    enabled: !isTyping,
                    textInputAction: TextInputAction.send,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isTyping
                      ? c.primary.withAlpha(80)
                      : c.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: IconButton(
                  icon: Icon(
                    isTyping ? Icons.hourglass_empty_rounded : IconService.send,
                    size: 18,
                    color: Colors.white,
                  ),
                  onPressed: isTyping ? null : () => onSend(controller.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
