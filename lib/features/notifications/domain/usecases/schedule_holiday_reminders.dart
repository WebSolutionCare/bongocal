import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../holidays/domain/entities/holiday.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../repositories/notification_scheduler.dart';

/// Wipe and reschedule every holiday reminder. Idempotent — safe to call
/// on every settings change or yearly holiday refresh.
class ScheduleHolidayReminders {
  ScheduleHolidayReminders(this._scheduler);

  final NotificationScheduler _scheduler;

  Future<Either<Failure, void>> call({
    required List<Holiday> holidays,
    required AppSettings settings,
  }) =>
      _scheduler.scheduleHolidayReminders(
        holidays: holidays,
        settings: settings,
      );
}
