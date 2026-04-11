import 'package:dio/dio.dart';
import 'package:marketlens360mobile/core/network/app_exception.dart';
import 'package:marketlens360mobile/services/connectivity_service.dart';

class ErrorInterceptor extends Interceptor {
  const ErrorInterceptor(this._connectivity);

  final ConnectivityService _connectivity;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final appEx = await _convert(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appEx,
        message: appEx.message,
        type: err.type,
        response: err.response,
      ),
    );
  }

  Future<AppException> _convert(DioException err) async {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        final connected = await _connectivity.isConnected();
        return connected ? const ServerException() : const NetworkException();
      case DioExceptionType.badResponse:
        return _fromStatusCode(
          err.response?.statusCode,
          err.response?.data,
        );
      default:
        final inner = err.error;
        if (inner is AppException) return inner;
        return UnknownException(err.message ?? 'An unexpected error occurred.');
    }
  }

  AppException _fromStatusCode(int? code, dynamic body) {
    final apiMessage = _extractMessage(body);
    if (code == null) return UnknownException('Unexpected error.');
    return switch (code) {
      400 => BadRequestException(apiMessage ?? 'Invalid request.'),
      401 => UnauthorizedException(apiMessage ?? 'Unauthorised.'),
      404 => NotFoundException(apiMessage ?? 'Resource not found.'),
      _ when code >= 500 => ServerException(apiMessage ?? 'Server error.'),
      _ => UnknownException(apiMessage ?? 'Unexpected error (code: $code).'),
    };
  }

  String? _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      final msg = body['error'] ?? body['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return null;
  }
}
