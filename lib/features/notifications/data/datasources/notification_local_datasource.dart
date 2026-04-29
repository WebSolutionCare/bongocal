import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/utils/bangla_numerals.dart';
import '../../../holidays/domain/entities/holiday.dart';
import '../../domain/entities/notification_type.dart';
import '../../domain/entities/scheduled_notification.dart';

/// Wraps [FlutterLocalNotificationsPlugin] for the notifications feature.
///
/// All public methods no-op on web (where the plugin is unsupported) — the
/// settings UI shows a snackbar in that case so users aren't surprised.
class NotificationLocalDataSource {
  NotificationLocalDataSource({
    required Box<dynamic> stateBox,
    FlutterLocalNotificationsPlugin? plugin,
    DateTime Function()? now,
  })  : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
        _stateBox = stateBox,
        _now = now ?? DateTime.now;

  final FlutterLocalNotificationsPlugin _plugin;
  final Box<dynamic> _stateBox;
  final DateTime Function() _now;

  /// Hive key under which we keep the list of every notification ID we
  /// have scheduled for a holiday reminder. The list is the source of
  /// truth for "cancel everything we own" so we never accidentally
  /// cancel an unrelated notification (e.g. a personal event).
  static const String _scheduledIdsKey = 'holiday_reminder_ids';

  /// Self-test notification ID — fixed so a second tap of the test button
  /// replaces the first instead of stacking.
  static const int _testNotificationId = 1924;

  /// We only look ahead this far. Anything farther is rescheduled later
  /// (yearly refresh, or whenever the user reopens the app).
  static const Duration _scheduleHorizon = Duration(days: 90);

  /// Hard cap to stay well under the per-app limit on every platform.
  static const int _maxScheduled = 100;

  /// Wall-clock hour for fire time. Picked for "morning coffee" feel and
  /// to avoid late-night pings.
  static const int _fireHour = 9;

  bool _initialized = false;

  bool get _supported => !kIsWeb;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    if (!_supported) {
      _initialized = true;
      return;
    }
    tz_data.initializeTimeZones();
    const InitializationSettings initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  /// Cancel every previously-scheduled holiday reminder, then schedule
  /// reminders for the supplied [holidays] using [daysBeforeOptions].
  ///
  /// Returns the count of notifications that were actually scheduled
  /// (after past-date and horizon filtering).
  Future<int> rescheduleHolidayReminders({
    required List<Holiday> holidays,
    required List<int> daysBeforeOptions,
  }) async {
    if (!_supported) return 0;
    await _ensureInitialized();
    await _cancelAllHolidayInternal();

    final DateTime now = _now();
    final DateTime horizon = now.add(_scheduleHorizon);
    final tz.Location dhaka = tz.getLocation('Asia/Dhaka');
    final List<int> scheduledIds = <int>[];

    for (final Holiday h in holidays) {
      for (final int days in daysBeforeOptions) {
        if (scheduledIds.length >= _maxScheduled) break;
        final DateTime fireDay = DateTime(h.date.year, h.date.month, h.date.day)
            .subtract(Duration(days: days));
        if (fireDay.isBefore(DateTime(now.year, now.month, now.day))) {
          continue;
        }
        if (fireDay.isAfter(horizon)) {
          continue;
        }
        final tz.TZDateTime fireTime = tz.TZDateTime(
          dhaka,
          fireDay.year,
          fireDay.month,
          fireDay.day,
          _fireHour,
        );
        if (fireTime.isBefore(tz.TZDateTime.now(dhaka))) {
          continue;
        }
        final int id = _idFor(h.id, days);
        await _scheduleZoned(
          id: id,
          title: _titleBn(days, h.nameBn),
          body: h.descriptionBn.isEmpty ? h.nameBn : h.descriptionBn,
          fireTime: fireTime,
          payload: '/holidays/${h.id}',
        );
        scheduledIds.add(id);
      }
      if (scheduledIds.length >= _maxScheduled) break;
    }

    await _stateBox.put(_scheduledIdsKey, scheduledIds);
    return scheduledIds.length;
  }

  /// Cancel every reminder we previously scheduled for [holidayId].
  Future<void> cancelHolidayReminder(String holidayId) async {
    if (!_supported) return;
    await _ensureInitialized();
    final List<int> ids = _readScheduledIds();
    final List<int> survivors = <int>[];
    final Set<int> targets = <int>{
      for (final int d in const <int>[1, 3, 7]) _idFor(holidayId, d),
    };
    for (final int id in ids) {
      if (targets.contains(id)) {
        await _plugin.cancel(id);
      } else {
        survivors.add(id);
      }
    }
    await _stateBox.put(_scheduledIdsKey, survivors);
  }

  /// Cancel every holiday reminder this datasource scheduled.
  Future<void> cancelAllHolidayReminders() async {
    if (!_supported) return;
    await _ensureInitialized();
    await _cancelAllHolidayInternal();
  }

  /// Currently-pending notifications as the OS sees them. We can only
  /// recover id + title + body + payload — not the original fire time —
  /// so [ScheduledNotification.scheduledFor] is set to epoch zero. UI
  /// surfaces just need the count, so this is enough.
  Future<List<ScheduledNotification>> getPendingNotifications() async {
    if (!_supported) return const <ScheduledNotification>[];
    await _ensureInitialized();
    final List<PendingNotificationRequest> pending =
        await _plugin.pendingNotificationRequests();
    final Set<int> ours = _readScheduledIds().toSet();
    return <ScheduledNotification>[
      for (final PendingNotificationRequest r in pending)
        if (ours.contains(r.id))
          ScheduledNotification(
            id: r.id,
            title: r.title ?? '',
            body: r.body ?? '',
            scheduledFor: DateTime.fromMillisecondsSinceEpoch(0),
            payload: r.payload ?? '',
            type: NotificationType.holiday,
          ),
    ];
  }

  /// Self-test: fire a notification 5 s from now so the user can verify
  /// the channel works.
  Future<void> scheduleTestNotification() async {
    if (!_supported) return;
    await _ensureInitialized();
    final tz.Location dhaka = tz.getLocation('Asia/Dhaka');
    final tz.TZDateTime fireTime =
        tz.TZDateTime.now(dhaka).add(const Duration(seconds: 5));
    await _scheduleZoned(
      id: _testNotificationId,
      title: 'BongoCal পরীক্ষা',
      body: 'নোটিফিকেশন কাজ করছে।',
      fireTime: fireTime,
      payload: '/settings',
    );
  }

  // ------------------------------------------------------------------
  // Internals
  // ------------------------------------------------------------------

  Future<void> _cancelAllHolidayInternal() async {
    final List<int> ids = _readScheduledIds();
    for (final int id in ids) {
      await _plugin.cancel(id);
    }
    await _stateBox.put(_scheduledIdsKey, <int>[]);
  }

  List<int> _readScheduledIds() {
    final dynamic raw = _stateBox.get(_scheduledIdsKey);
    if (raw is List) {
      return raw.whereType<int>().toList(growable: false);
    }
    return const <int>[];
  }

  Future<void> _scheduleZoned({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime fireTime,
    required String payload,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'holiday_reminders',
        'Holiday reminders',
        channelDescription: 'ছুটি ও উৎসবের পূর্বাভাস',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      fireTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // ignore: deprecated_member_use
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Stable 31-bit positive int from holiday id + days-before. Collisions
  /// across the ~300-id working set are negligible.
  static int _idFor(String holidayId, int daysBefore) =>
      'h:$holidayId:$daysBefore'.hashCode & 0x7fffffff;

  /// "আগামীকাল: <name>" for 1 day, "৩ দিন পরে: <name>" otherwise. Bangla
  /// numerals everywhere — no emoji per the brand voice.
  static String _titleBn(int daysBefore, String nameBn) {
    if (daysBefore == 1) return 'আগামীকাল: $nameBn';
    return '${BanglaNumerals.fromInt(daysBefore)} দিন পরে: $nameBn';
  }
}
