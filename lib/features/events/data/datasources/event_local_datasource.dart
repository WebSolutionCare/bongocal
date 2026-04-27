import 'package:hive/hive.dart';

import '../models/personal_event_model.dart';

/// Hive-backed CRUD + query helpers for personal events.
///
/// Holds a typed [Box] passed in by [EventRepositoryImpl]. Tests substitute
/// an in-memory box opened via `Hive.init('.tmp')` + `Hive.openBox`.
class EventLocalDataSource {
  EventLocalDataSource({required Box<PersonalEventModel> box}) : _box = box;

  final Box<PersonalEventModel> _box;

  Future<void> create(PersonalEventModel event) =>
      _box.put(event.id, event);

  Future<void> update(PersonalEventModel event) =>
      _box.put(event.id, event);

  Future<void> delete(String id) => _box.delete(id);

  PersonalEventModel? getById(String id) => _box.get(id);

  /// All stored events, ordered by anchor date ascending.
  List<PersonalEventModel> getAll() {
    final List<PersonalEventModel> all = _box.values.toList();
    all.sort(
      (PersonalEventModel a, PersonalEventModel b) =>
          a.date.compareTo(b.date),
    );
    return all;
  }

  /// Events whose recurrence-expanded occurrence falls on [date].
  List<PersonalEventModel> getForDate(DateTime date) =>
      <PersonalEventModel>[
        for (final PersonalEventModel e in _box.values)
          if (e.occursOn(date)) e,
      ];

  /// Events whose recurrence-expanded occurrence falls on any day in
  /// [year]/[month].
  List<PersonalEventModel> getForMonth(int year, int month) {
    final DateTime firstOfMonth = DateTime(year, month, 1);
    final DateTime nextMonth = DateTime(year, month + 1, 1);
    final Set<String> hits = <String>{};
    final List<PersonalEventModel> out = <PersonalEventModel>[];
    for (final PersonalEventModel e in _box.values) {
      DateTime probe = firstOfMonth;
      while (probe.isBefore(nextMonth)) {
        if (e.occursOn(probe)) {
          if (hits.add(e.id)) out.add(e);
          break;
        }
        probe = probe.add(const Duration(days: 1));
      }
    }
    out.sort(
      (PersonalEventModel a, PersonalEventModel b) =>
          a.date.compareTo(b.date),
    );
    return out;
  }

  /// Events whose next occurrence on or after [from] is non-null,
  /// sorted by that next occurrence ascending.
  List<PersonalEventModel> getUpcoming({
    required DateTime from,
    int? limit,
  }) {
    final List<({PersonalEventModel event, DateTime next})> withNext =
        <({PersonalEventModel event, DateTime next})>[];
    for (final PersonalEventModel e in _box.values) {
      final DateTime? next = e.nextOccurrenceOnOrAfter(from);
      if (next != null) withNext.add((event: e, next: next));
    }
    withNext.sort((a, b) => a.next.compareTo(b.next));
    final List<PersonalEventModel> sorted = <PersonalEventModel>[
      for (final r in withNext) r.event,
    ];
    if (limit == null || limit >= sorted.length) return sorted;
    return sorted.sublist(0, limit);
  }
}
