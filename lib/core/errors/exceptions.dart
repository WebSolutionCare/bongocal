/// Data-layer exceptions. Throw these inside data sources; the repository
/// implementation catches them and converts to a [Failure] for the domain
/// layer.
class AppException implements Exception {
  const AppException([this.message]);

  final String? message;

  @override
  String toString() => '$runtimeType${message != null ? ': $message' : ''}';
}

class ServerException extends AppException {
  const ServerException([super.message]);
}

class CacheException extends AppException {
  const CacheException([super.message]);
}

class NetworkException extends AppException {
  const NetworkException([super.message]);
}

class PermissionException extends AppException {
  const PermissionException([super.message, this.permission]);

  final String? permission;
}

class LocationException extends AppException {
  const LocationException([super.message]);
}

class CalendarException extends AppException {
  const CalendarException([super.message]);
}
