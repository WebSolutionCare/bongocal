import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/events/domain/entities/event_category.dart';
import 'package:bongocal/features/events/domain/entities/personal_event.dart';
import 'package:bongocal/features/events/domain/entities/recurrence_rule.dart';
import 'package:bongocal/features/events/domain/repositories/event_repository.dart';
import 'package:dartz/dartz.dart';

/// Pure-Dart in-memory event repository for unit + widget tests. Avoids
/// pulling in Hive — tests just construct one of these and feed it events.
class FakeEventRepository implements EventRepository {
  FakeEventRepository({
    DateTime Function()? now,
    List<PersonalEvent> seed = const <PersonalEvent>[],
  })  : _now = now ?? DateTime.now,
        _events = <String, PersonalEvent>{
          for (final PersonalEvent e in seed) e.id: e,
        };

  final DateTime Function() _now;
  final Map<String, PersonalEvent> _events;

  @override
  Future<Either<Failure, void>> createEvent(PersonalEvent event) async {
    _events[event.id] = event;
    return const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, void>> updateEvent(PersonalEvent event) async {
    _events[event.id] = event;
    return const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String id) async {
    _events.remove(id);
    return const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, PersonalEvent?>> getEventById(String id) async =>
      Right<Failure, PersonalEvent?>(_events[id]);

  @override
  Future<Either<Failure, List<PersonalEvent>>> getEventsForDate(
    DateTime date,
  ) async =>
      Right<Failure, List<PersonalEvent>>(<PersonalEvent>[
        for (final PersonalEvent e in _events.values)
          if (e.occursOn(date)) e,
      ]);

  @override
  Future<Either<Failure, List<PersonalEvent>>> getEventsForMonth(
    int year,
    int month,
  ) async {
    final DateTime first = DateTime(year, month, 1);
    final DateTime nextMonth = DateTime(year, month + 1, 1);
    final List<PersonalEvent> hits = <PersonalEvent>[];
    for (final PersonalEvent e in _events.values) {
      DateTime probe = first;
      while (probe.isBefore(nextMonth)) {
        if (e.occursOn(probe)) {
          hits.add(e);
          break;
        }
        probe = probe.add(const Duration(days: 1));
      }
    }
    return Right<Failure, List<PersonalEvent>>(hits);
  }

  @override
  Future<Either<Failure, List<PersonalEvent>>> getAllEvents() async {
    final List<PersonalEvent> all = _events.values.toList();
    all.sort((PersonalEvent a, PersonalEvent b) => a.date.compareTo(b.date));
    return Right<Failure, List<PersonalEvent>>(all);
  }

  @override
  Future<Either<Failure, List<PersonalEvent>>> getUpcomingEvents({
    int? limit,
  }) async {
    final DateTime from = _now();
    final List<({PersonalEvent event, DateTime next})> rows =
        <({PersonalEvent event, DateTime next})>[];
    for (final PersonalEvent e in _events.values) {
      final DateTime? next = e.nextOccurrenceOnOrAfter(from);
      if (next != null) rows.add((event: e, next: next));
    }
    rows.sort((a, b) => a.next.compareTo(b.next));
    final List<PersonalEvent> sorted = <PersonalEvent>[
      for (final r in rows) r.event,
    ];
    final List<PersonalEvent> result =
        limit == null || limit >= sorted.length
            ? sorted
            : sorted.sublist(0, limit);
    return Right<Failure, List<PersonalEvent>>(result);
  }
}

/// Convenience factory — terse `makeEvent(...)` for tests.
PersonalEvent makeEvent({
  required DateTime date,
  String id = 'e',
  String title = 'Test',
  bool isAllDay = false,
  int startMinutes = 600,
  int endMinutes = 720,
  RecurrenceRule recurrence = RecurrenceRule.none,
  EventCategory category = EventCategory.custom,
  int colorValue = 0xFF006A4E,
  List<int> reminderMinutesBefore = const <int>[],
  EventCalendarType calendarType = EventCalendarType.english,
}) =>
    PersonalEvent(
      id: id,
      title: title,
      date: date,
      isAllDay: isAllDay,
      calendarType: calendarType,
      recurrence: recurrence,
      category: category,
      colorValue: colorValue,
      reminderMinutesBefore: reminderMinutesBefore,
      createdAt: date,
      updatedAt: date,
      startMinutes: isAllDay ? null : startMinutes,
      endMinutes: isAllDay ? null : endMinutes,
    );
