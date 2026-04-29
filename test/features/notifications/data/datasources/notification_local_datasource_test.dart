import 'dart:io';

import 'package:bongocal/features/notifications/data/datasources/notification_local_datasource.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // flutter_local_notifications calls native code we can't fulfill in unit
  // tests. Stub the channel so initialization + cancel calls return null.
  const MethodChannel pluginChannel =
      MethodChannel('dexterous.com/flutter/local_notifications');

  late Directory tempDir;
  late Box<dynamic> stateBox;
  late NotificationLocalDataSource dataSource;

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pluginChannel, (MethodCall call) async {
      switch (call.method) {
        case 'initialize':
          return true;
        case 'pendingNotificationRequests':
          return <Map<String, Object?>>[];
        default:
          return null;
      }
    });

    tempDir = await Directory.systemTemp.createTemp('bongocal_notif_ds_');
    Hive.init(tempDir.path);
    stateBox = await Hive.openBox<dynamic>(
      'notif_test_${tempDir.path.hashCode}',
    );
    dataSource = NotificationLocalDataSource(stateBox: stateBox);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pluginChannel, null);
    await stateBox.close();
    await tempDir.delete(recursive: true);
  });

  group('persisted scheduled-id list', () {
    test('cancelAllHolidayReminders is a no-op when nothing is persisted',
        () async {
      // Should complete without throwing — the platform plugin is never
      // contacted because the id list is empty.
      await dataSource.cancelAllHolidayReminders();
      expect(stateBox.get('holiday_reminder_ids'), <int>[]);
    });

    test('reads back what was written, casting through dynamic', () async {
      await stateBox.put('holiday_reminder_ids', <dynamic>[100, 200, 'oops']);
      // Internally filtered with whereType<int> — non-int garbage is dropped
      // before any cancel call. Behaviour is observed via cancelAll which
      // uses the same reader path.
      await dataSource.cancelAllHolidayReminders();
      expect(stateBox.get('holiday_reminder_ids'), <int>[]);
    });
  });

  group('getPendingNotifications', () {
    test('returns an empty list before anything is scheduled', () async {
      final list = await dataSource.getPendingNotifications();
      expect(list, isEmpty);
    });
  });
}
