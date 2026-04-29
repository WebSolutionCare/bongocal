import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../holidays/domain/entities/holiday.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../repositories/notification_scheduler.dart';

/// Branches on the user's current preference: when reminders are enabled
/// and at least one days-before value is selected, reschedule against the
/// latest holiday list. Otherwise wipe everything.
///
/// This is the single entry point used by the orchestrator provider, so
/// settings changes and yearly holiday refreshes both flow through the
/// same logic.
class RescheduleOnSettingsChange {
  RescheduleOnSettingsChange(this._scheduler);

  final NotificationScheduler _scheduler;

  Future<Either<Failure, void>> call({
    required List<Holiday> holidays,
    required AppSettings settings,
  }) {
    final bool enabled = settings.notificationsEnabled &&
        settings.holidayReminderDays.isNotEmpty;
    if (!enabled) {
      return _scheduler.cancelAllHolidayReminders();
    }
    return _scheduler.scheduleHolidayReminders(
      holidays: holidays,
      settings: settings,
    );
  }
}
