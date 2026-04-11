import 'package:dio/dio.dart';
import 'package:marketlens360mobile/services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._storage);

  final StorageService _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
