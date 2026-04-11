import 'package:marketlens360mobile/core/bootstrap.dart';
import 'package:marketlens360mobile/core/config/app_config.dart';
import 'package:marketlens360mobile/firebase_options_production.dart';

void main() => bootstrap(AppConfig.production, DefaultFirebaseOptions.currentPlatform);