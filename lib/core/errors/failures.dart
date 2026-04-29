import 'package:equatable/equatable.dart';

/// Base type for all domain-layer failures. Use cases and repositories return
/// `Either<Failure, T>` so callers must handle the failure branch explicitly.
abstract class Failure extends Equatable {
  const Failure({this.message});

  final String? message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Server / remote API failure (HTTP 5xx, malformed response, etc.).
class ServerFailure extends Failure {
  const ServerFailure({super.message});
}

/// Local persistence failure (Hive read/write, file IO).
class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

/// No connectivity or DNS unreachable.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

/// OS denied a permission (location, notifications, calendar).
class PermissionFailure extends Failure {
  const PermissionFailure({super.message, this.permission});

  final String? permission;

  @override
  List<Object?> get props => <Object?>[message, permission];
}

/// Geolocation lookup failed (GPS off, timeout, no fix).
class LocationFailure extends Failure {
  const LocationFailure({super.message});
}

/// Failure from a calendar / date computation (Hijri, Bengali, recurrence).
class CalendarFailure extends Failure {
  const CalendarFailure({super.message});
}

/// Caller-side validation: bad input that never reached IO.
class ValidationFailure extends Failure {
  const ValidationFailure({super.message, this.field});

  final String? field;

  @override
  List<Object?> get props => <Object?>[message, field];
}

/// Anything we did not anticipate. Prefer a more specific failure type.
class UnknownFailure extends Failure {
  const UnknownFailure({super.message});
}

/// OS-level notification scheduling failed (channel rejected, exact-alarm
/// permission missing on Android 12+, plugin not initialized, etc.).
class NotificationFailure extends Failure {
  const NotificationFailure({super.message});
}
