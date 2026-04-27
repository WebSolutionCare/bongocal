import 'package:hive/hive.dart';

import '../../domain/entities/event_category.dart';
import '../../domain/entities/personal_event.dart';
import '../../domain/entities/recurrence_rule.dart';

/// Hive type ids — kept centralized in code comments so contributors don't
/// silently collide. `1` is reserved here for [PersonalEventModel].
const int _personalEventTypeId = 1;

/// Hive-persisted projection of [PersonalEvent].
///
/// Adapter is **hand-written** below (we don't run build_runner) — keep the
/// `read` and `write` field order in lock-step. Adding a new field means
/// (a) bump nothing if you append at the end and tolerate `null` from
/// older records, or (b) bump the type id and migrate.
class PersonalEventModel extends PersonalEvent {
  const PersonalEventModel({
    required super.id,
    required super.title,
    required super.date,
    required super.isAllDay,
    required super.calendarType,
    required super.recurrence,
    required super.category,
    required super.colorValue,
    required super.reminderMinutesBefore,
    required super.createdAt,
    required super.updatedAt,
    super.description,
    super.startMinutes,
    super.endMinutes,
  });

  factory PersonalEventModel.fromEntity(PersonalEvent e) => PersonalEventModel(
        id: e.id,
        title: e.title,
        description: e.description,
        date: e.date,
        isAllDay: e.isAllDay,
        calendarType: e.calendarType,
        recurrence: e.recurrence,
        category: e.category,
        colorValue: e.colorValue,
        reminderMinutesBefore: e.reminderMinutesBefore,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
        startMinutes: e.startMinutes,
        endMinutes: e.endMinutes,
      );

  factory PersonalEventModel.fromJson(Map<String, dynamic> json) =>
      PersonalEventModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: (json['description'] as String?) ?? '',
        date: DateTime.parse(json['date'] as String),
        isAllDay: json['isAllDay'] as bool,
        calendarType: EventCalendarType
            .values[(json['calendarType'] as int?) ?? 0],
        recurrence:
            RecurrenceRule.values[(json['recurrence'] as int?) ?? 0],
        category: EventCategory
            .values[(json['category'] as int?) ?? EventCategory.custom.index],
        colorValue: json['colorValue'] as int,
        reminderMinutesBefore:
            ((json['reminderMinutesBefore'] as List<dynamic>?) ?? <dynamic>[])
                .map((dynamic e) => e as int)
                .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        startMinutes: json['startMinutes'] as int?,
        endMinutes: json['endMinutes'] as int?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'isAllDay': isAllDay,
        'calendarType': calendarType.index,
        'recurrence': recurrence.index,
        'category': category.index,
        'colorValue': colorValue,
        'reminderMinutesBefore': reminderMinutesBefore,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
      };
}

/// Hand-written Hive adapter for [PersonalEventModel]. Register once at
/// app boot (see [HiveService.init]).
class PersonalEventModelAdapter extends TypeAdapter<PersonalEventModel> {
  @override
  int get typeId => _personalEventTypeId;

  @override
  PersonalEventModel read(BinaryReader reader) {
    final int fieldCount = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };
    return PersonalEventModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: (fields[2] as String?) ?? '',
      date: fields[3] as DateTime,
      isAllDay: fields[4] as bool,
      calendarType: EventCalendarType.values[fields[5] as int],
      recurrence: RecurrenceRule.values[fields[6] as int],
      category: EventCategory.values[fields[7] as int],
      colorValue: fields[8] as int,
      reminderMinutesBefore:
          ((fields[9] as List<dynamic>?) ?? <dynamic>[])
              .map((dynamic e) => e as int)
              .toList(),
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
      startMinutes: fields[12] as int?,
      endMinutes: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalEventModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.isAllDay)
      ..writeByte(5)
      ..write(obj.calendarType.index)
      ..writeByte(6)
      ..write(obj.recurrence.index)
      ..writeByte(7)
      ..write(obj.category.index)
      ..writeByte(8)
      ..write(obj.colorValue)
      ..writeByte(9)
      ..write(obj.reminderMinutesBefore)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.startMinutes)
      ..writeByte(13)
      ..write(obj.endMinutes);
  }
}
