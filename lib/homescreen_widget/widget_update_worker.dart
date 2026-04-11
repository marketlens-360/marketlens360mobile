import 'package:workmanager/workmanager.dart';

// Background task that updates homescreen widgets with the latest market data.
// Registered as a periodic task (15-minute minimum interval by OS).
// Native widget UI (Android Glance / iOS SwiftUI) is out of scope.

const _taskName = 'widget_update_task';
const _taskTag  = 'marketlens360_widget_update';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == _taskName) {
      // TODO(Phase 2): Fetch latest prices from SecurityRepository
      // and call WidgetDataService to push data to homescreen widget.
      // Requires separate Dio instance (no ProviderScope in background isolate).
    }
    return Future.value(true);
  });
}

Future<void> registerWidgetUpdateWorker() async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    _taskTag,
    _taskName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}
