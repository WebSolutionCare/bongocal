import 'dart:io';

import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/notifications/data/datasources/notification_local_datasource.dart';
import 'package:bongocal/features/notifications/data/repositories/notification_scheduler_impl.dart';
import 'package:bongocal/features/notifications/domain/entities/scheduled_notification.dart';
import 'package:bongocal/features/settings/domain/entities/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import '../../_fakes/holiday_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // flutter_local_notifications hits MethodChannels we can't fulfill in
  // unit tests, so stub them with no-op handlers. We're testing the
  // repository contract (failure mapping, durable state), not the
  // platform integration.
  const MethodChannel pluginChannel =
      MethodChannel('dexterous.com/flutter/local_notifications');

  late Directory tempDir;
  late Box<dynamic> stateBox;
  late NotificationLocalDataSource dataSource;
  late NotificationSchedulerImpl repo;

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pluginChannel, (MethodCall call) async {
      switch (call.method) {
        case 'initialize':
          return true;
        case 'pendingNotificationRequests':
          return <Map<String, Object?>>[];
        case 'cancel':
        case 'cancelAll':
        case 'zonedSchedule':
          return null;
        default:
          return null;
      }
    });

    tempDir = await Directory.systemTemp.createTemp('bongocal_notif_repo_');
    Hive.init(tempDir.path);
    stateBox = await Hive.openBox<dynamic>(
      'notif_test_${tempDir.path.hashCode}',
    );
    dataSource = NotificationLocalDataSource(stateBox: stateBox);
    repo = NotificationSchedulerImpl(dataSource: dataSource);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pluginChannel, null);
    await stateBox.close();
    await tempDir.delete(recursive: true);
  });

  test(
    'scheduleHolidayReminders short-circuits to cancel when '
    'notifications are disabled',
    () async {
      // Seed the state box with stale ids so we can verify they get cleared.
      await stateBox.put('holiday_reminder_ids', <int>[111, 222]);

      final result = await repo.scheduleHolidayReminders(
        holidays: <Holiday>[
          testHoliday(id: 'h', date: DateTime(2026, 5, 1)),
        ],
        settings: AppSettings.defaults().copyWith(notificationsEnabled: false),
      );

      expect(result.isRight(), isTrue);
      // No platform calls happen on the test runner (kIsWeb is false but
      // the plugin is unavailable), so we only verify the durable state
      // contract: the id list was wiped.
      final dynamic stored = stateBox.get('holiday_reminder_ids');
      expect(stored, <int>[]);
    },
  );

  test('cancelAllHolidayReminders wipes the persisted id list', () async {
    await stateBox.put('holiday_reminder_ids', <int>[1, 2, 3]);

    final result = await repo.cancelAllHolidayReminders();

    expect(result.isRight(), isTrue);
    expect(stateBox.get('holiday_reminder_ids'), <int>[]);
  });

  test('getPendingNotifications returns an empty list when none scheduled',
      () async {
    final result = await repo.getPendingNotifications();
    expect(result.isRight(), isTrue);
    result.fold(
      (_) => fail('expected Right'),
      (List<ScheduledNotification> list) => expect(list, isEmpty),
    );
  });
}
