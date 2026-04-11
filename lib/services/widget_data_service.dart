import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

class WidgetDataService {
  // iOS App Group ID — configure in Xcode for native widget
  // static const _appGroupId = 'group.com.marketlens360mobile';
  static const _iOSWidgetName  = 'MarketLensWidget';
  static const _androidWidgetName = 'MarketLensWidgetProvider';

  Future<void> updatePriceWidget({
    required String symbol,
    required double price,
    required double changePercent,
  }) async {
    await HomeWidget.saveWidgetData('price_symbol', symbol);
    await HomeWidget.saveWidgetData('price_value', price);
    await HomeWidget.saveWidgetData('price_change', changePercent);
    await triggerWidgetRefresh();
  }

  Future<void> updatePortfolioWidget({
    required double totalValue,
    required double changePercent,
  }) async {
    await HomeWidget.saveWidgetData('portfolio_total', totalValue);
    await HomeWidget.saveWidgetData('portfolio_change', changePercent);
    await triggerWidgetRefresh();
  }

  Future<void> updateMarketWidget({
    required double nasiValue,
    required double nasiChange,
  }) async {
    await HomeWidget.saveWidgetData('nasi_value', nasiValue);
    await HomeWidget.saveWidgetData('nasi_change', nasiChange);
    await triggerWidgetRefresh();
  }

  Future<void> triggerWidgetRefresh() async {
    await HomeWidget.updateWidget(
      iOSName: _iOSWidgetName,
      androidName: _androidWidgetName,
    );
  }
}

final widgetDataServiceProvider = Provider<WidgetDataService>(
  (ref) => WidgetDataService(),
);
