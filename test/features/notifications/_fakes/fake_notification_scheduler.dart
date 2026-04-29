import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/notifications/domain/entities/notification_type.dart';
import 'package:bongocal/features/notifications/domain/entities/scheduled_notification.dart';
import 'package:bongocal/features/notifications/domain/repositories/notification_scheduler.dart';
import 'package:bongocal/features/settings/domain/entities/app_settings.dart';
import 'package:dartz/dartz.dart';

/// In-memory recorder for use-case tests. Tracks the last call to each
/// boundary method so a single test can assert "scheduleHolidayReminders
/// was invoked once with these holidays".
class FakeNotificationScheduler implements NotificationScheduler {
  int scheduleCount = 0;
  int cancelAllCount = 0;
  int scheduleTestCount = 0;
  final List<String> cancelledHolidayIds = <String>[];

  List<Holiday>? lastHolidays;
  AppSettings? lastSettings;

  /// Pre-populate to drive [getPendingNotifications] return value.
  List<ScheduledNotification> pending = const <ScheduledNotification>[];

  @override
  Future<Either<Failure, void>> scheduleHolidayReminders({
    required List<Holiday> holidays,
    required AppSettings settings,
  }) async {
    scheduleCount++;
    lastHolidays = holidays;
    lastSettings = settings;
    return const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, void>> cancelHolidayReminder(String holidayId) async {
    cancelledHolidayIds.add(holidayId);
    return const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, void>> cancelAllHolidayReminders() async {
    cancelAllCount++;
    return const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, List<ScheduledNotification>>>
      getPendingNotifications() async =>
          Right<Failure, List<ScheduledNotification>>(pending);

  @override
  Future<Either<Failure, void>> scheduleTestNotification() async {
    scheduleTestCount++;
    return const Right<Failure, void>(null);
  }

  /// Convenience for tests that only care about counts, not contents.
  ScheduledNotification stubFor(String holidayId) => ScheduledNotification(
        id: holidayId.hashCode & 0x7fffffff,
        title: 'stub',
        body: 'stub',
        scheduledFor: DateTime(2026),
        payload: '/holidays/$holidayId',
        type: NotificationType.holiday,
      );
}
