enum AppEnvironment { development, production }

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.baseUrl,
    required this.appName,
  });

  final AppEnvironment environment;
  final String baseUrl;
  final String appName;

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isProduction => environment == AppEnvironment.production;

  static const AppConfig development = AppConfig(
    environment: AppEnvironment.development,
    baseUrl: 'https://marketlens360backend-development.up.railway.app/api/v1',
    appName: 'MarketLens360 Dev',
  );

  static const AppConfig production = AppConfig(
    environment: AppEnvironment.production,
    baseUrl: 'https://marketlens360backend-development.up.railway.app/api/v1',
    appName: 'MarketLens360',
  );
}
