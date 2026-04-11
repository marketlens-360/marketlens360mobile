import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/config/config_providers.dart';
import 'package:marketlens360mobile/services/connectivity_service.dart';
import 'package:marketlens360mobile/services/storage_service.dart';
import 'api_client.dart';

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(),
);

final dioProvider = Provider<Dio>((ref) {
  final storage      = ref.watch(storageServiceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final config       = ref.watch(appConfigProvider);
  final dio = AppHttpClient.create(storage, connectivity, config.baseUrl);
  ref.onDispose(dio.close);
  return dio;
});
