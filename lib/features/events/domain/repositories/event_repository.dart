import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/personal_event.dart';

/// Domain port for personal-event CRUD + queries. The implementation lives
/// in `data/repositories/event_repository_impl.dart` and persists via Hive.
abstract class EventRepository {
  Future<Either<Failure, void>> createEvent(PersonalEvent event);

  Future<Either<Failure, void>> updateEvent(PersonalEvent event);

  Future<Either<Failure, void>> deleteEvent(String id);

  Future<Either<Failure, PersonalEvent?>> getEventById(String id);

  /// Events whose recurrence-expanded occurrence falls on [date].
  Future<Either<Failure, List<PersonalEvent>>> getEventsForDate(DateTime date);

  /// Events whose recurrence-expanded occurrence falls within [year]/[month].
  Future<Either<Failure, List<PersonalEvent>>> getEventsForMonth(
    int year,
    int month,
  );

  /// All raw events (no recurrence expansion), ordered by anchor date.
  Future<Either<Failure, List<PersonalEvent>>> getAllEvents();

  /// Next [limit] occurrences (across all events) on or after now —
  /// returns each event with its computed next occurrence implicit in
  /// the underlying [PersonalEvent.date] / `nextOccurrenceOnOrAfter`.
  Future<Either<Failure, List<PersonalEvent>>> getUpcomingEvents({int? limit});
}
