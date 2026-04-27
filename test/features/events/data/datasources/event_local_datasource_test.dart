import 'dart:io';

import 'package:bongocal/features/events/data/datasources/event_local_datasource.dart';
import 'package:bongocal/features/events/data/models/personal_event_model.dart';
import 'package:bongocal/features/events/domain/entities/event_category.dart';
import 'package:bongocal/features/events/domain/entities/recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<PersonalEventModel> box;
  late EventLocalDataSource ds;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('bongocal_events_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(PersonalEventModelAdapter().typeId)) {
      Hive.registerAdapter(PersonalEventModelAdapter());
    }
    box = await Hive.openBox<PersonalEventModel>('events_test_${tempDir.path.hashCode}');
    ds = EventLocalDataSource(box: box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  PersonalEventModel sample({
    required String id,
    required DateTime date,
    RecurrenceRule recurrence = RecurrenceRule.none,
  }) =>
      PersonalEventModel(
        id: id,
        title: 'Title $id',
        date: date,
        isAllDay: false,
        calendarType: EventCalendarType.english,
        recurrence: recurrence,
        category: EventCategory.custom,
        colorValue: 0xFF006A4E,
        reminderMinutesBefore: const <int>[15, 60],
        createdAt: date,
        updatedAt: date,
        startMinutes: 600,
        endMinutes: 720,
      );

  test('round-trips through Hive (write → read same fields)', () async {
    final PersonalEventModel original =
        sample(id: 'a', date: DateTime(2026, 4, 27));
    await ds.create(original);

    final PersonalEventModel? loaded = ds.getById('a');
    expect(loaded, isNotNull);
    expect(loaded!.id, 'a');
    expect(loaded.title, 'Title a');
    expect(loaded.date, DateTime(2026, 4, 27));
    expect(loaded.startMinutes, 600);
    expect(loaded.endMinutes, 720);
    expect(loaded.calendarType, EventCalendarType.english);
    expect(loaded.category, EventCategory.custom);
    expect(loaded.reminderMinutesBefore, <int>[15, 60]);
  });

  test('getForDate respects recurrence', () async {
    await ds.create(
      sample(
        id: 'weekly',
        date: DateTime(2026, 4, 27),
        recurrence: RecurrenceRule.weekly,
      ),
    );
    await ds.create(
      sample(
        id: 'oneoff',
        date: DateTime(2026, 4, 28),
      ),
    );

    final hits = ds.getForDate(DateTime(2026, 5, 4));
    expect(hits.map((e) => e.id), <String>['weekly']);
  });

  test('getForMonth deduplicates same event across days', () async {
    await ds.create(
      sample(
        id: 'daily',
        date: DateTime(2026, 4, 1),
        recurrence: RecurrenceRule.daily,
      ),
    );
    final april = ds.getForMonth(2026, 4);
    expect(april.length, 1);
    expect(april.first.id, 'daily');
  });

  test('delete removes the event from getById', () async {
    await ds.create(sample(id: 'a', date: DateTime(2026, 4, 27)));
    await ds.delete('a');
    expect(ds.getById('a'), isNull);
  });
}
