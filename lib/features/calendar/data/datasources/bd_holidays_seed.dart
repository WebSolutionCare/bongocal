import '../../domain/entities/upcoming_holiday.dart';

/// Hard-coded fixture of Bangladesh's 2026 holidays + festivals so the home
/// screen can render an "upcoming holiday" card before the holidays feature
/// is implemented.
///
/// **TODO(holidays):** delete this file once `features/holidays/` ships and
/// route `CalendarRepositoryImpl.getNextHoliday()` through that feature.
class BdHolidaysSeed {
  const BdHolidaysSeed._();

  static List<UpcomingHoliday> all = <UpcomingHoliday>[
    _h(
      'shaheed_dibosh',
      'শহীদ দিবস',
      'Language Martyrs Day',
      DateTime(2026, 2, 21),
      isGovernment: true,
    ),
    _h(
      'independence',
      'স্বাধীনতা দিবস',
      'Independence Day',
      DateTime(2026, 3, 26),
      isGovernment: true,
    ),
    _h(
      'eid_fitr',
      'ঈদুল ফিতর',
      'Eid al-Fitr',
      DateTime(2026, 3, 21),
      isFestival: true,
      isGovernment: true,
    ),
    _h(
      'boishakh',
      'পহেলা বৈশাখ',
      'Bangla New Year',
      DateTime(2026, 4, 14),
      isFestival: true,
      isGovernment: true,
    ),
    _h(
      'may_day',
      'মে দিবস',
      'May Day',
      DateTime(2026, 5, 1),
      isGovernment: true,
    ),
    _h(
      'buddha_purnima',
      'বুদ্ধ পূর্ণিমা',
      'Buddha Purnima',
      DateTime(2026, 5, 1),
      isFestival: true,
      isGovernment: true,
    ),
    _h(
      'eid_adha',
      'ঈদুল আজহা',
      'Eid al-Adha',
      DateTime(2026, 5, 28),
      isFestival: true,
      isGovernment: true,
    ),
    _h(
      'ashura',
      'আশুরা',
      'Ashura',
      DateTime(2026, 6, 26),
      isGovernment: true,
    ),
    _h(
      'janmashtami',
      'জন্মাষ্টমী',
      'Janmashtami',
      DateTime(2026, 9, 4),
      isFestival: true,
      isGovernment: true,
    ),
    _h(
      'eid_milad',
      'ঈদে মিলাদুন্নবী',
      'Eid-e-Miladunnabi',
      DateTime(2026, 8, 26),
      isGovernment: true,
    ),
    _h(
      'puja',
      'দুর্গা পূজা',
      'Durga Puja',
      DateTime(2026, 10, 19),
      isFestival: true,
      isGovernment: true,
    ),
    _h(
      'victory',
      'বিজয় দিবস',
      'Victory Day',
      DateTime(2026, 12, 16),
      isGovernment: true,
    ),
    _h(
      'christmas',
      'বড়দিন',
      'Christmas',
      DateTime(2026, 12, 25),
      isGovernment: true,
    ),
  ];

  static UpcomingHoliday _h(
    String id,
    String nameBn,
    String nameEn,
    DateTime date, {
    bool isFestival = false,
    bool isGovernment = false,
  }) =>
      UpcomingHoliday(
        id: id,
        nameBn: nameBn,
        nameEn: nameEn,
        date: date,
        // daysAway is recomputed per query; a default of 0 here is fine.
        daysAway: 0,
        isFestival: isFestival,
        isGovernment: isGovernment,
      );

  /// Find the next holiday on/after [from] (start-of-day).
  static UpcomingHoliday? nextOnOrAfter(DateTime from) {
    final DateTime cutoff = DateTime(from.year, from.month, from.day);
    UpcomingHoliday? best;
    for (final UpcomingHoliday h in all) {
      if (h.date.isBefore(cutoff)) continue;
      if (best == null || h.date.isBefore(best.date)) best = h;
    }
    if (best == null) return null;
    final int days = best.date.difference(cutoff).inDays;
    return UpcomingHoliday(
      id: best.id,
      nameBn: best.nameBn,
      nameEn: best.nameEn,
      date: best.date,
      daysAway: days,
      isFestival: best.isFestival,
      isGovernment: best.isGovernment,
    );
  }

  /// True if a Gregorian day matches any seeded holiday. Used by the month
  /// grid for marking cells.
  static UpcomingHoliday? matching(DateTime day) {
    final DateTime d = DateTime(day.year, day.month, day.day);
    for (final UpcomingHoliday h in all) {
      if (h.date.year == d.year &&
          h.date.month == d.month &&
          h.date.day == d.day) {
        return h;
      }
    }
    return null;
  }
}
