import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../holidays/domain/entities/holiday.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../domain/entities/scheduled_notification.dart';
import '../../domain/repositories/notification_scheduler.dart';
import '../datasources/notification_local_datasource.dart';

class NotificationSchedulerImpl implements NotificationScheduler {
  NotificationSchedulerImpl({required NotificationLocalDataSource dataSource})
      : _dataSource = dataSource;

  final NotificationLocalDataSource _dataSource;

  @override
  Future<Either<Failure, void>> scheduleHolidayReminders({
    required List<Holiday> holidays,
    required AppSettings settings,
  }) async {
    if (!settings.notificationsEnabled ||
        settings.holidayReminderDays.isEmpty) {
      return cancelAllHolidayReminders();
    }
    try {
      await _dataSource.rescheduleHolidayReminders(
        holidays: holidays,
        daysBeforeOptions: settings.holidayReminderDays,
      );
      return const Right<Failure, void>(null);
    } on Exception catch (e) {
      return Left<Failure, void>(NotificationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelHolidayReminder(String holidayId) async {
    try {
      await _dataSource.cancelHolidayReminder(holidayId);
      return const Right<Failure, void>(null);
    } on Exception catch (e) {
      return Left<Failure, void>(NotificationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAllHolidayReminders() async {
    try {
      await _dataSource.cancelAllHolidayReminders();
      return const Right<Failure, void>(null);
    } on Exception catch (e) {
      return Left<Failure, void>(NotificationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ScheduledNotification>>>
      getPendingNotifications() async {
    try {
      final List<ScheduledNotification> list =
          await _dataSource.getPendingNotifications();
      return Right<Failure, List<ScheduledNotification>>(list);
    } on Exception catch (e) {
      return Left<Failure, List<ScheduledNotification>>(
        NotificationFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> scheduleTestNotification() async {
    try {
      await _dataSource.scheduleTestNotification();
      return const Right<Failure, void>(null);
    } on Exception catch (e) {
      return Left<Failure, void>(NotificationFailure(message: e.toString()));
    }
  }
}
