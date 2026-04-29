/// Classification used to derive both notification IDs and the channel
/// the OS files the alert under. New types should also map to a channel
/// in [NotificationLocalDataSource].
enum NotificationType {
  /// Public / religious / national holidays (driven by the holiday list).
  holiday,

  /// Personal events the user authored.
  event,

  /// Festival-day morning greetings ("শুভ নববর্ষ").
  festival,
}
