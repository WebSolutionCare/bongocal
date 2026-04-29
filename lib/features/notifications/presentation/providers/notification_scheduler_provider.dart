import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_service.dart';
import '../../../holidays/domain/entities/holiday.dart';
import '../../../holidays/presentation/providers/holidays_provider.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../data/datasources/notification_local_datasource.dart';
import '../../data/repositories/notification_scheduler_impl.dart';
import '../../domain/entities/scheduled_notification.dart';
import '../../domain/repositories/notification_scheduler.dart';
import '../../domain/usecases/cancel_all_reminders.dart';
import '../../domain/usecases/reschedule_on_settings_change.dart';
import '../../domain/usecases/schedule_holiday_reminders.dart';

/// Hive-backed durable state for the notifications feature (the list of
/// IDs we have currently scheduled). Pre-opened by [HiveService].
final Provider<Box<dynamic>> notificationsStateBoxProvider =
    Provider<Box<dynamic>>(
  (Ref ref) => Hive.box<dynamic>(HiveBoxes.notifications),
);

final Provider<NotificationLocalDataSource> notificationLocalDataSourceProvider =
    Provider<NotificationLocalDataSource>(
  (Ref ref) => NotificationLocalDataSource(
    stateBox: ref.watch(notificationsStateBoxProvider),
  ),
);

final Provider<NotificationScheduler> notificationSchedulerProvider =
    Provider<NotificationScheduler>(
  (Ref ref) => NotificationSchedulerImpl(
    dataSource: ref.watch(notificationLocalDataSourceProvider),
  ),
);

final Provider<ScheduleHolidayReminders> scheduleHolidayRemindersProvider =
    Provider<ScheduleHolidayReminders>(
  (Ref ref) =>
      ScheduleHolidayReminders(ref.watch(notificationSchedulerProvider)),
);

final Provider<RescheduleOnSettingsChange>
    rescheduleOnSettingsChangeProvider = Provider<RescheduleOnSettingsChange>(
  (Ref ref) =>
      RescheduleOnSettingsChange(ref.watch(notificationSchedulerProvider)),
);

final Provider<CancelAllReminders> cancelAllRemindersProvider =
    Provider<CancelAllReminders>(
  (Ref ref) => CancelAllReminders(ref.watch(notificationSchedulerProvider)),
);

/// Live count of pending holiday reminders. Re-fetches when a reschedule
/// finishes so the settings subtitle stays in sync.
final FutureProvider<int> pendingHolidayReminderCountProvider =
    FutureProvider<int>((Ref ref) async {
  // Re-run whenever the orchestrator fires.
  ref.watch(notificationOrchestratorProvider);
  final NotificationScheduler scheduler =
      ref.watch(notificationSchedulerProvider);
  final result = await scheduler.getPendingNotifications();
  return result.fold(
    (_) => 0,
    (List<ScheduledNotification> list) => list.length,
  );
});

/// The orchestrator: watches settings + the upcoming holiday list and
/// re-runs the reschedule use case any time either input changes.
///
/// Activate it once from a top-level widget (`ref.watch(...)`) and the
/// rest is automatic.
final Provider<int> notificationOrchestratorProvider = Provider<int>(
  (Ref ref) {
    final AppSettings settings = ref.watch(currentSettingsProvider);
    final AsyncValue<List<Holiday>> holidaysAsync =
        ref.watch(upcomingHolidaysProvider);

    holidaysAsync.whenData((List<Holiday> holidays) {
      final RescheduleOnSettingsChange usecase =
          ref.read(rescheduleOnSettingsChangeProvider);
      // Run on the next microtask so we never schedule from inside a
      // provider-build call (which would re-enter the graph).
      Future<void>.microtask(() async {
        await usecase(holidays: holidays, settings: settings);
        // Bust the cached pending-count so the settings page repaints.
        // ignore: unused_result
        ref.refresh(pendingHolidayReminderCountProvider);
      });
    });

    // Returning a tick lets pendingHolidayReminderCountProvider depend
    // on us without anyone caring about the actual value.
    return DateTime.now().microsecondsSinceEpoch;
  },
);
