import 'package:equatable/equatable.dart';

import 'notification_type.dart';

/// A pending OS-level notification we have asked the platform to fire.
///
/// [id] is a stable 31-bit positive integer derived from the source
/// (e.g. `holidayId + daysBefore`) so subsequent reschedules cancel
/// and replace cleanly without duplicates.
///
/// [payload] is consumed by the tap handler to deep-link into the app —
/// for holiday reminders this is `'/holidays/<id>'`.
class ScheduledNotification extends Equatable {
  const ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledFor,
    required this.payload,
    required this.type,
  });

  final int id;
  final String title;
  final String body;
  final DateTime scheduledFor;
  final String payload;
  final NotificationType type;

  @override
  List<Object?> get props =>
      <Object?>[id, title, body, scheduledFor, payload, type];
}
