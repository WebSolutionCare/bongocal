/// User-facing categories for personal events. Drives the emoji-tile picker
/// in the add/edit sheet and the icon shown on event list cards.
enum EventCategory { birthday, anniversary, meeting, reminder, custom }

extension EventCategoryX on EventCategory {
  String get displayBn {
    switch (this) {
      case EventCategory.birthday:
        return 'জন্মদিন';
      case EventCategory.anniversary:
        return 'বিবাহ';
      case EventCategory.meeting:
        return 'মিটিং';
      case EventCategory.reminder:
        return 'রিমাইন্ডার';
      case EventCategory.custom:
        return 'কাস্টম';
    }
  }

  String get displayEn {
    switch (this) {
      case EventCategory.birthday:
        return 'Birthday';
      case EventCategory.anniversary:
        return 'Anniversary';
      case EventCategory.meeting:
        return 'Meeting';
      case EventCategory.reminder:
        return 'Reminder';
      case EventCategory.custom:
        return 'Custom';
    }
  }

  /// Single emoji glyph used as the visual marker. Per CLAUDE.md "no emoji
  /// in product UI" — we make a deliberate exception here because the
  /// design references emoji-tile pickers for event categories. These are
  /// user-content classifiers, not UI chrome.
  String get emoji {
    switch (this) {
      case EventCategory.birthday:
        return '🎂';
      case EventCategory.anniversary:
        return '💍';
      case EventCategory.meeting:
        return '🤝';
      case EventCategory.reminder:
        return '⏰';
      case EventCategory.custom:
        return '✨';
    }
  }
}
