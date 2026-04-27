import 'package:equatable/equatable.dart';

import 'language_preference.dart';
import 'primary_calendar_preference.dart';
import 'theme_preference.dart';
import 'week_start_preference.dart';

/// All persisted user preferences. A single instance is the source of truth;
/// the settings repository streams updates so the whole app rebuilds when
/// any field changes.
class AppSettings extends Equatable {
  const AppSettings({
    required this.themeMode,
    required this.language,
    required this.primaryCalendar,
    required this.showBanglaNumerals,
    required this.weekStartDay,
    required this.notificationsEnabled,
    required this.holidayReminderDays,
    required this.eventReminderSound,
    required this.festivalGreetingsEnabled,
  });

  /// Project-wide defaults — pinned to the Bangladesh-first behavior the
  /// brand voice asks for (Bangla UI, Sat-first weeks, holiday reminders on).
  factory AppSettings.defaults() => const AppSettings(
        themeMode: ThemePreference.system,
        language: LanguagePreference.bangla,
        primaryCalendar: PrimaryCalendarPreference.english,
        showBanglaNumerals: true,
        weekStartDay: WeekStartPreference.saturday,
        notificationsEnabled: true,
        holidayReminderDays: <int>[3],
        eventReminderSound: 'default',
        festivalGreetingsEnabled: true,
      );

  final ThemePreference themeMode;
  final LanguagePreference language;
  final PrimaryCalendarPreference primaryCalendar;
  final bool showBanglaNumerals;
  final WeekStartPreference weekStartDay;

  final bool notificationsEnabled;

  /// Days-before-holiday at which reminders fire (e.g. `[1, 3, 7]`).
  final List<int> holidayReminderDays;

  /// Sound id for event notifications. `'default'` uses the platform default.
  final String eventReminderSound;

  /// Toggles the "Eid Mubarak / শুভ নববর্ষ" greeting overlay on festival days.
  final bool festivalGreetingsEnabled;

  AppSettings copyWith({
    ThemePreference? themeMode,
    LanguagePreference? language,
    PrimaryCalendarPreference? primaryCalendar,
    bool? showBanglaNumerals,
    WeekStartPreference? weekStartDay,
    bool? notificationsEnabled,
    List<int>? holidayReminderDays,
    String? eventReminderSound,
    bool? festivalGreetingsEnabled,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        language: language ?? this.language,
        primaryCalendar: primaryCalendar ?? this.primaryCalendar,
        showBanglaNumerals: showBanglaNumerals ?? this.showBanglaNumerals,
        weekStartDay: weekStartDay ?? this.weekStartDay,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        holidayReminderDays: holidayReminderDays ?? this.holidayReminderDays,
        eventReminderSound: eventReminderSound ?? this.eventReminderSound,
        festivalGreetingsEnabled:
            festivalGreetingsEnabled ?? this.festivalGreetingsEnabled,
      );

  @override
  List<Object?> get props => <Object?>[
        themeMode,
        language,
        primaryCalendar,
        showBanglaNumerals,
        weekStartDay,
        notificationsEnabled,
        holidayReminderDays,
        eventReminderSound,
        festivalGreetingsEnabled,
      ];
}
