import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/app.dart';
import 'package:marketlens360mobile/core/config/app_config.dart';
import 'package:marketlens360mobile/core/config/config_providers.dart';
import 'package:marketlens360mobile/services/notification_service.dart';

Future<void> bootstrap(AppConfig config, FirebaseOptions firebaseOptions) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: firebaseOptions);
  await NotificationService.initialize();
  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const App(),
    ),
  );
}
