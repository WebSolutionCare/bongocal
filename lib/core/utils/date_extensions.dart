import 'package:intl/intl.dart';

/// Generic [DateTime] helpers shared across features.
///
/// Calendar conversions (Gregorian → Bengali / Hijri) live with the calendar
/// feature in `features/calendar/data/datasources/`, since they are domain
/// logic owned by that feature. This file intentionally only carries
/// time-of-day / same-day helpers that any feature can use safely.
extension DateExtensions on DateTime {
  /// `27 April 2026`.
  String formatEnglishLong() => DateFormat('d MMMM y').format(this);

  /// `27 Apr`.
  String formatEnglishShort() => DateFormat('d MMM').format(this);

  /// True when [other] falls on the same calendar day, regardless of time-of-day.
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Midnight of this date (drops time-of-day).
  DateTime get startOfDay => DateTime(year, month, day);
}
