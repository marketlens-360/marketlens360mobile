sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection. Please check your network.']);
}

final class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out. Please try again.']);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorised. Please sign in again.']);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'The requested resource was not found.']);
}

final class BadRequestException extends AppException {
  const BadRequestException([super.message = 'Invalid request.']);
}

final class ServerException extends AppException {
  const ServerException([super.message = 'A server error occurred. Please try again later.']);
}

final class UnknownException extends AppException {
  const UnknownException([super.message = 'An unexpected error occurred.']);
}
