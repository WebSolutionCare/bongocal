import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Wraps `flutter_local_notifications` with no-op fallbacks for environments
/// the plugin does not support (web, desktop without local-notification
/// integration, tests). Schedules personal-event reminders, prayer-time
/// alerts, etc.
///
/// IMPORTANT: actual delivery still requires platform-specific config —
/// Android `AndroidManifest.xml` permissions + iOS `Info.plist` keys. Code
/// here is wired so adding that config is the only remaining step.
class NotificationsService {
  NotificationsService._();

  static final NotificationsService instance = NotificationsService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  bool get _supported => !kIsWeb;

  Future<void> init() async {
    if (_initialized) return;
    if (!_supported) {
      _initialized = true;
      return;
    }

    tz_data.initializeTimeZones();
    // Use UTC — caller schedules reminders relative to wall-clock anyway.
    tz.setLocalLocation(tz.UTC);

    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings);
    _initialized = true;
  }

  /// Schedule a one-shot notification. [whenLocal] is interpreted in UTC
  /// for the bundled timezone database.
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime whenLocal,
    String channelId = 'event_reminders',
    String channelName = 'Event reminders',
  }) async {
    if (!_supported) return;
    if (!_initialized) await init();

    final tz.TZDateTime when = tz.TZDateTime.from(whenLocal.toUtc(), tz.UTC);
    final NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
    );

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // ignore: deprecated_member_use
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } on Exception {
      // Best-effort — failures (no permission, plugin missing on the
      // platform) shouldn't block event creation.
    }
  }

  Future<void> cancel(int id) async {
    if (!_supported) return;
    try {
      await _plugin.cancel(id);
    } on Exception {
      // best effort
    }
  }
}
