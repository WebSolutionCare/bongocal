import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/notification_scheduler.dart';

/// Cancel every previously-scheduled holiday reminder. Triggered when the
/// user toggles holiday reminders off.
class CancelAllReminders {
  CancelAllReminders(this._scheduler);

  final NotificationScheduler _scheduler;

  Future<Either<Failure, void>> call() =>
      _scheduler.cancelAllHolidayReminders();
}
