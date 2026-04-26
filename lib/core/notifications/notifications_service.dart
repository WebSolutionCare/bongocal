/// Stub for the local-notifications service.
///
/// Phase 1 will wire this to `flutter_local_notifications` for prayer-time
/// reminders and event alarms. Kept as a stub here so feature wiring can
/// reference the type without pulling notification logic into the bootstrap
/// path before we are ready.
class NotificationsService {
  NotificationsService._();

  static final NotificationsService instance = NotificationsService._();

  Future<void> init() async {
    // TODO: wire flutter_local_notifications + tz database in Phase 1.
  }
}
