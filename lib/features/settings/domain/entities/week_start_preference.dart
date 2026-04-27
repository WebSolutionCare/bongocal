/// The day on which the week starts in calendar grids and week strips.
/// Defaults to Saturday for Bangladesh — same convention used on the home
/// screen's week strip.
enum WeekStartPreference { saturday, sunday, monday }

extension WeekStartPreferenceX on WeekStartPreference {
  String get displayBn {
    switch (this) {
      case WeekStartPreference.saturday:
        return 'শনিবার';
      case WeekStartPreference.sunday:
        return 'রবিবার';
      case WeekStartPreference.monday:
        return 'সোমবার';
    }
  }
}
