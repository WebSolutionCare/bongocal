import 'package:bongocal/features/events/domain/entities/recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_event_repository.dart';

void main() {
  group('PersonalEvent.occursOn', () {
    test('non-recurring: only the anchor date matches', () {
      final event = makeEvent(date: DateTime(2026, 4, 27));
      expect(event.occursOn(DateTime(2026, 4, 27)), isTrue);
      expect(event.occursOn(DateTime(2026, 4, 28)), isFalse);
      expect(event.occursOn(DateTime(2027, 4, 27)), isFalse);
    });

    test('daily recurrence', () {
      final event = makeEvent(
        date: DateTime(2026, 4, 27),
        recurrence: RecurrenceRule.daily,
      );
      expect(event.occursOn(DateTime(2026, 4, 27)), isTrue);
      expect(event.occursOn(DateTime(2026, 4, 28)), isTrue);
      expect(event.occursOn(DateTime(2026, 4, 26)), isFalse);
    });

    test('weekly recurrence', () {
      final event = makeEvent(
        date: DateTime(2026, 4, 27),
        recurrence: RecurrenceRule.weekly,
      );
      expect(event.occursOn(DateTime(2026, 5, 4)), isTrue);
      expect(event.occursOn(DateTime(2026, 5, 5)), isFalse);
    });

    test('monthly recurrence', () {
      final event = makeEvent(
        date: DateTime(2026, 4, 14),
        recurrence: RecurrenceRule.monthly,
      );
      expect(event.occursOn(DateTime(2026, 5, 14)), isTrue);
      expect(event.occursOn(DateTime(2026, 6, 14)), isTrue);
      expect(event.occursOn(DateTime(2026, 5, 13)), isFalse);
    });

    test('yearly recurrence', () {
      final event = makeEvent(
        date: DateTime(2026, 4, 27),
        recurrence: RecurrenceRule.yearly,
      );
      expect(event.occursOn(DateTime(2027, 4, 27)), isTrue);
      expect(event.occursOn(DateTime(2030, 4, 27)), isTrue);
      expect(event.occursOn(DateTime(2027, 4, 28)), isFalse);
    });
  });

  group('PersonalEvent.nextOccurrenceOnOrAfter', () {
    test('non-recurring: returns anchor when on/after, null otherwise', () {
      final event = makeEvent(date: DateTime(2026, 4, 27));
      expect(
        event.nextOccurrenceOnOrAfter(DateTime(2026, 4, 27)),
        DateTime(2026, 4, 27),
      );
      expect(
        event.nextOccurrenceOnOrAfter(DateTime(2026, 4, 28)),
        isNull,
      );
    });

    test('weekly: returns next matching weekday', () {
      final event = makeEvent(
        date: DateTime(2026, 4, 27), // Monday
        recurrence: RecurrenceRule.weekly,
      );
      expect(
        event.nextOccurrenceOnOrAfter(DateTime(2026, 4, 28)),
        DateTime(2026, 5, 4),
      );
    });

    test('yearly: returns next year-anniversary', () {
      final event = makeEvent(
        date: DateTime(2024, 1, 15),
        recurrence: RecurrenceRule.yearly,
      );
      expect(
        event.nextOccurrenceOnOrAfter(DateTime(2026, 4, 27)),
        DateTime(2027, 1, 15),
      );
    });
  });
}
