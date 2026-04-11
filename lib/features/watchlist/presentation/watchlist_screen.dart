import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/core/widgets/app_empty_view.dart';
import 'package:marketlens360mobile/features/watchlist/providers/watchlist_providers.dart';
import 'package:marketlens360mobile/services/icon_service.dart';
import 'widgets/alert_tile.dart';
import 'widgets/watchlist_tile.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist', style: AppTextStyles.screenTitle),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.of(context).primary,
        onPressed: () => _showAddAlertSheet(context, ref),
        child: const Icon(IconService.bellPlus, color: Colors.white),
      ),
      body: ListView(
        children: [
          // Watchlisted securities
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH, AppSpacing.lg,
              AppSpacing.screenH, AppSpacing.sm,
            ),
            child: Text('Saved Securities', style: AppTextStyles.sectionLabel),
          ),
          () {
            if (watchlist.isLoading && watchlist.securities.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (watchlist.securities.isEmpty) {
              return const AppEmptyView(
                message: 'No securities saved',
                subMessage: 'Tap the bookmark icon on a stock to add it.',
              );
            }
            return Column(
              children: watchlist.securities
                  .map((s) => Dismissible(
                        key: ValueKey(s.symbol),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: AppColors.priceDown,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: AppSpacing.lg),
                          child: const Icon(IconService.delete, color: Colors.white),
                        ),
                        onDismissed: (_) =>
                            ref.read(watchlistProvider).removeFromWatchlist(s.symbol),
                        child: WatchlistTile(summary: s),
                      ))
                  .toList(),
            );
          }(),

          // Price alerts
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH, AppSpacing.lg,
              AppSpacing.screenH, AppSpacing.sm,
            ),
            child: Text('Price Alerts', style: AppTextStyles.sectionLabel),
          ),
          () {
            if (watchlist.isLoading && watchlist.alerts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (watchlist.alerts.isEmpty) {
              return const AppEmptyView(
                message: 'No active alerts',
                subMessage: 'Tap + to add a price alert.',
              );
            }
            return Column(
              children: watchlist.alerts
                  .map((a) => AlertTile(alert: a))
                  .toList(),
            );
          }(),
        ],
      ),
    );
  }

  void _showAddAlertSheet(BuildContext context, WidgetRef ref) {
    final symbolCtrl = TextEditingController();
    final priceCtrl  = TextEditingController();
    bool isAbove     = true;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.of(context).surface,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: AppSpacing.lg,
            left: AppSpacing.screenH,
            right: AppSpacing.screenH,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Price Alert', style: AppTextStyles.labelLg),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: symbolCtrl,
                decoration: const InputDecoration(hintText: 'Symbol (e.g. SCOM)'),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(hintText: 'Target price'),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Text('Direction', style: AppTextStyles.body),
                  const Spacer(),
                  ChoiceChip(
                    label: const Text('Above'),
                    selected: isAbove,
                    onSelected: (_) => setState(() => isAbove = true),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ChoiceChip(
                    label: const Text('Below'),
                    selected: !isAbove,
                    onSelected: (_) => setState(() => isAbove = false),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.of(ctx).primary,
                  ),
                  onPressed: () async {
                    final price = double.tryParse(priceCtrl.text);
                    if (symbolCtrl.text.isNotEmpty && price != null) {
                      await ref.read(watchlistProvider).addAlert(
                        symbol: symbolCtrl.text.toUpperCase(),
                        targetPrice: price,
                        direction: isAbove ? 'above' : 'below',
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Save Alert'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
