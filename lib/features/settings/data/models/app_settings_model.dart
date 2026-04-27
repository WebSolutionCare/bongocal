import 'package:hive/hive.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/entities/language_preference.dart';
import '../../domain/entities/primary_calendar_preference.dart';
import '../../domain/entities/theme_preference.dart';
import '../../domain/entities/week_start_preference.dart';

/// Hive type id reserved for [AppSettingsModel]. PersonalEvents reserved 1;
/// settings reserves 2. Future Hive types pick the next free integer.
const int kAppSettingsTypeId = 2;

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.themeMode,
    required super.language,
    required super.primaryCalendar,
    required super.showBanglaNumerals,
    required super.weekStartDay,
    required super.notificationsEnabled,
    required super.holidayReminderDays,
    required super.eventReminderSound,
    required super.festivalGreetingsEnabled,
  });

  factory AppSettingsModel.fromEntity(AppSettings s) => AppSettingsModel(
        themeMode: s.themeMode,
        language: s.language,
        primaryCalendar: s.primaryCalendar,
        showBanglaNumerals: s.showBanglaNumerals,
        weekStartDay: s.weekStartDay,
        notificationsEnabled: s.notificationsEnabled,
        holidayReminderDays: s.holidayReminderDays,
        eventReminderSound: s.eventReminderSound,
        festivalGreetingsEnabled: s.festivalGreetingsEnabled,
      );

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      AppSettingsModel(
        themeMode: ThemePreference.values[
            (json['themeMode'] as int?) ?? ThemePreference.system.index],
        language: LanguagePreference.values[
            (json['language'] as int?) ?? LanguagePreference.bangla.index],
        primaryCalendar: PrimaryCalendarPreference.values[
            (json['primaryCalendar'] as int?) ??
                PrimaryCalendarPreference.english.index],
        showBanglaNumerals: (json['showBanglaNumerals'] as bool?) ?? true,
        weekStartDay: WeekStartPreference.values[(json['weekStartDay'] as int?) ??
            WeekStartPreference.saturday.index],
        notificationsEnabled: (json['notificationsEnabled'] as bool?) ?? true,
        holidayReminderDays: ((json['holidayReminderDays'] as List<dynamic>?) ??
                <dynamic>[3])
            .map((dynamic e) => e as int)
            .toList(),
        eventReminderSound:
            (json['eventReminderSound'] as String?) ?? 'default',
        festivalGreetingsEnabled:
            (json['festivalGreetingsEnabled'] as bool?) ?? true,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'themeMode': themeMode.index,
        'language': language.index,
        'primaryCalendar': primaryCalendar.index,
        'showBanglaNumerals': showBanglaNumerals,
        'weekStartDay': weekStartDay.index,
        'notificationsEnabled': notificationsEnabled,
        'holidayReminderDays': holidayReminderDays,
        'eventReminderSound': eventReminderSound,
        'festivalGreetingsEnabled': festivalGreetingsEnabled,
      };
}

/// Hand-written adapter (no build_runner). Field indices are stable —
/// append new fields at the next index, don't renumber existing ones.
class AppSettingsModelAdapter extends TypeAdapter<AppSettingsModel> {
  @override
  int get typeId => kAppSettingsTypeId;

  @override
  AppSettingsModel read(BinaryReader reader) {
    final int fieldCount = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };
    return AppSettingsModel(
      themeMode: ThemePreference.values[(fields[0] as int?) ?? 2],
      language: LanguagePreference.values[(fields[1] as int?) ?? 0],
      primaryCalendar:
          PrimaryCalendarPreference.values[(fields[2] as int?) ?? 0],
      showBanglaNumerals: (fields[3] as bool?) ?? true,
      weekStartDay: WeekStartPreference.values[(fields[4] as int?) ?? 0],
      notificationsEnabled: (fields[5] as bool?) ?? true,
      holidayReminderDays: ((fields[6] as List<dynamic>?) ?? <dynamic>[3])
          .map((dynamic e) => e as int)
          .toList(),
      eventReminderSound: (fields[7] as String?) ?? 'default',
      festivalGreetingsEnabled: (fields[8] as bool?) ?? true,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettingsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.themeMode.index)
      ..writeByte(1)
      ..write(obj.language.index)
      ..writeByte(2)
      ..write(obj.primaryCalendar.index)
      ..writeByte(3)
      ..write(obj.showBanglaNumerals)
      ..writeByte(4)
      ..write(obj.weekStartDay.index)
      ..writeByte(5)
      ..write(obj.notificationsEnabled)
      ..writeByte(6)
      ..write(obj.holidayReminderDays)
      ..writeByte(7)
      ..write(obj.eventReminderSound)
      ..writeByte(8)
      ..write(obj.festivalGreetingsEnabled);
  }
}
