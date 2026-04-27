import 'package:bongocal/features/events/domain/entities/personal_event.dart';
import 'package:bongocal/features/events/domain/usecases/create_event.dart';
import 'package:bongocal/features/events/domain/usecases/delete_event.dart';
import 'package:bongocal/features/events/domain/usecases/get_events_for_date.dart';
import 'package:bongocal/features/events/domain/usecases/get_events_for_month.dart';
import 'package:bongocal/features/events/domain/usecases/get_upcoming_events.dart';
import 'package:bongocal/features/events/domain/usecases/update_event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_event_repository.dart';

void main() {
  test('CreateEvent + UpdateEvent + DeleteEvent round-trip', () async {
    final FakeEventRepository repo = FakeEventRepository();
    final PersonalEvent event = makeEvent(
      id: 'a',
      date: DateTime(2026, 4, 27),
      title: 'Original',
    );

    await CreateEvent(repo)(event);
    final created = await repo.getEventById('a');
    expect(
      created.fold((_) => null, (PersonalEvent? e) => e?.title),
      'Original',
    );

    await UpdateEvent(repo)(event.copyWith(title: 'Renamed'));
    final updated = await repo.getEventById('a');
    expect(
      updated.fold((_) => null, (PersonalEvent? e) => e?.title),
      'Renamed',
    );

    await DeleteEvent(repo)('a');
    final deleted = await repo.getEventById('a');
    expect(deleted.fold((_) => null, (PersonalEvent? e) => e), isNull);
  });

  test('GetEventsForDate filters by occurrence', () async {
    final FakeEventRepository repo = FakeEventRepository(
      seed: <PersonalEvent>[
        makeEvent(id: 'a', date: DateTime(2026, 4, 27)),
        makeEvent(id: 'b', date: DateTime(2026, 4, 28)),
      ],
    );
    final result =
        await GetEventsForDate(repo)(DateTime(2026, 4, 27, 23, 59));
    expect(
      result.fold(
        (_) => null,
        (List<PersonalEvent> list) => list.map((PersonalEvent e) => e.id).toList(),
      ),
      <String>['a'],
    );
  });

  test('GetEventsForMonth filters by Gregorian month', () async {
    final FakeEventRepository repo = FakeEventRepository(
      seed: <PersonalEvent>[
        makeEvent(id: 'a', date: DateTime(2026, 4, 1)),
        makeEvent(id: 'b', date: DateTime(2026, 5, 31)),
        makeEvent(id: 'c', date: DateTime(2026, 4, 30)),
      ],
    );
    final result = await GetEventsForMonth(repo)(
      const GetEventsForMonthParams(year: 2026, month: 4),
    );
    final List<String> ids =
        result.fold((_) => <String>[], (List<PersonalEvent> l) => l.map((e) => e.id).toList());
    expect(ids, containsAll(<String>['a', 'c']));
    expect(ids, isNot(contains('b')));
  });

  test('GetUpcomingEvents respects "now" + limit', () async {
    final FakeEventRepository repo = FakeEventRepository(
      now: () => DateTime(2026, 4, 27),
      seed: <PersonalEvent>[
        makeEvent(id: 'past', date: DateTime(2026, 4, 1)),
        makeEvent(id: 'today', date: DateTime(2026, 4, 27)),
        makeEvent(id: 'soon', date: DateTime(2026, 5, 1)),
        makeEvent(id: 'later', date: DateTime(2026, 6, 15)),
      ],
    );
    final result = await GetUpcomingEvents(repo)(limit: 2);
    final List<String> ids =
        result.fold((_) => <String>[], (l) => l.map((e) => e.id).toList());
    expect(ids, <String>['today', 'soon']);
  });
}
