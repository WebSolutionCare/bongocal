import 'package:equatable/equatable.dart';

import 'event_category.dart';
import 'recurrence_rule.dart';

/// A single user-entered personal event. Time-of-day is stored as minutes
/// from midnight so the domain layer stays free of Flutter's `TimeOfDay`.
class PersonalEvent extends Equatable {
  const PersonalEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.isAllDay,
    required this.calendarType,
    required this.recurrence,
    required this.category,
    required this.colorValue,
    required this.reminderMinutesBefore,
    required this.createdAt,
    required this.updatedAt,
    this.description = '',
    this.startMinutes,
    this.endMinutes,
  })  : assert(
          isAllDay || startMinutes != null,
          'Timed event must define a start time',
        ),
        assert(
          startMinutes == null || (startMinutes >= 0 && startMinutes < 1440),
          'startMinutes must be in [0, 1440)',
        ),
        assert(
          endMinutes == null || (endMinutes >= 0 && endMinutes < 1440),
          'endMinutes must be in [0, 1440)',
        );

  /// Stable id (UUID v4 from the `uuid` package).
  final String id;
  final String title;
  final String description;

  /// Anchor date in Gregorian. Time-of-day on this DateTime is **ignored**
  /// — `startMinutes`/`endMinutes` are the source of truth for the time.
  final DateTime date;

  /// True for all-day events; both [startMinutes] and [endMinutes] should
  /// be null when this is set.
  final bool isAllDay;

  /// User's preferred calendar for displaying this event's date.
  final EventCalendarType calendarType;
  final RecurrenceRule recurrence;
  final EventCategory category;

  /// 32-bit ARGB color value (use `Color(...).value` from Flutter).
  final int colorValue;

  /// Minutes-before-start at which to fire reminders (e.g. `[15, 60, 1440]`).
  final List<int> reminderMinutesBefore;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Minutes from midnight for the event's start time. Null for all-day.
  final int? startMinutes;

  /// Minutes from midnight for the event's end time. Null for all-day or
  /// for events without an explicit end (instantaneous reminders).
  final int? endMinutes;

  PersonalEvent copyWith({
    String? title,
    String? description,
    DateTime? date,
    bool? isAllDay,
    EventCalendarType? calendarType,
    RecurrenceRule? recurrence,
    EventCategory? category,
    int? colorValue,
    List<int>? reminderMinutesBefore,
    DateTime? updatedAt,
    int? startMinutes,
    int? endMinutes,
  }) =>
      PersonalEvent(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
        isAllDay: isAllDay ?? this.isAllDay,
        calendarType: calendarType ?? this.calendarType,
        recurrence: recurrence ?? this.recurrence,
        category: category ?? this.category,
        colorValue: colorValue ?? this.colorValue,
        reminderMinutesBefore:
            reminderMinutesBefore ?? this.reminderMinutesBefore,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        startMinutes: startMinutes ?? this.startMinutes,
        endMinutes: endMinutes ?? this.endMinutes,
      );

  /// True if this event has an occurrence on [day] (start-of-day),
  /// after expanding [recurrence].
  bool occursOn(DateTime day) {
    final DateTime base = DateTime(date.year, date.month, date.day);
    final DateTime target = DateTime(day.year, day.month, day.day);
    if (target.isBefore(base)) return false;
    switch (recurrence) {
      case RecurrenceRule.none:
        return target.isAtSameMomentAs(base);
      case RecurrenceRule.daily:
        return true;
      case RecurrenceRule.weekly:
        return target.difference(base).inDays % 7 == 0;
      case RecurrenceRule.monthly:
        return target.day == base.day;
      case RecurrenceRule.yearly:
        return target.day == base.day && target.month == base.month;
    }
  }

  /// Next occurrence of this event on or after [from] (start-of-day),
  /// or null when none exists in the next ~5 years.
  DateTime? nextOccurrenceOnOrAfter(DateTime from) {
    final DateTime cutoff = DateTime(from.year, from.month, from.day);
    final DateTime base = DateTime(date.year, date.month, date.day);
    if (recurrence == RecurrenceRule.none) {
      return base.isBefore(cutoff) ? null : base;
    }
    // Bound the search at ~5 years so an unbounded recurrence on a
    // far-past base never spins forever.
    final DateTime hardCutoff = cutoff.add(const Duration(days: 365 * 5));
    DateTime probe = base.isBefore(cutoff) ? cutoff : base;
    while (!probe.isAfter(hardCutoff)) {
      if (occursOn(probe)) return probe;
      probe = probe.add(const Duration(days: 1));
    }
    return null;
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        description,
        date,
        isAllDay,
        calendarType,
        recurrence,
        category,
        colorValue,
        reminderMinutesBefore,
        createdAt,
        updatedAt,
        startMinutes,
        endMinutes,
      ];
}
