import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../holidays/domain/entities/holiday.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../entities/scheduled_notification.dart';

/// Boundary for OS-level notification scheduling. Implementations are
/// expected to:
///
/// 1. Cancel-then-schedule on every call (never duplicate IDs).
/// 2. Skip past-dated reminders silently.
/// 3. Cap output at the platform-safe limit (Android allows ~500 but
///    we self-limit to 100 over the next 90 days).
/// 4. No-op gracefully on unsupported platforms (web).
abstract class NotificationScheduler {
  /// Cancel all existing holiday reminders, then schedule reminders for
  /// every holiday in [holidays] whose date falls within the next 90 days,
  /// using the days-before list from [settings].
  ///
  /// Honors [AppSettings.notificationsEnabled] — when off, behaves like
  /// [cancelAllHolidayReminders].
  Future<Either<Failure, void>> scheduleHolidayReminders({
    required List<Holiday> holidays,
    required AppSettings settings,
  });

  /// Cancel every reminder previously scheduled for [holidayId] across
  /// all `days_before` variants.
  Future<Either<Failure, void>> cancelHolidayReminder(String holidayId);

  /// Cancel every holiday reminder we have ever scheduled.
  Future<Either<Failure, void>> cancelAllHolidayReminders();

  /// Read the OS's pending-notification list. Useful for the settings
  /// page subtitle ("X scheduled") and for debugging.
  Future<Either<Failure, List<ScheduledNotification>>>
      getPendingNotifications();

  /// Fire a self-test notification 5 seconds from now so the user can
  /// verify permissions + channel setup. Wired to the settings page button.
  Future<Either<Failure, void>> scheduleTestNotification();
}
