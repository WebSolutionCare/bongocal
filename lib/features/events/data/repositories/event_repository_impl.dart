import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/personal_event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_local_datasource.dart';
import '../models/personal_event_model.dart';

class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl({
    required EventLocalDataSource dataSource,
    required DateTime Function() now,
  })  : _dataSource = dataSource,
        _now = now;

  final EventLocalDataSource _dataSource;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, void>> createEvent(PersonalEvent event) =>
      _wrapWrite(() => _dataSource.create(PersonalEventModel.fromEntity(event)));

  @override
  Future<Either<Failure, void>> updateEvent(PersonalEvent event) =>
      _wrapWrite(() => _dataSource.update(PersonalEventModel.fromEntity(event)));

  @override
  Future<Either<Failure, void>> deleteEvent(String id) =>
      _wrapWrite(() => _dataSource.delete(id));

  @override
  Future<Either<Failure, PersonalEvent?>> getEventById(String id) async {
    try {
      return Right<Failure, PersonalEvent?>(_dataSource.getById(id));
    } on Exception catch (e) {
      return Left<Failure, PersonalEvent?>(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PersonalEvent>>> getEventsForDate(
    DateTime date,
  ) async {
    try {
      return Right<Failure, List<PersonalEvent>>(
        List<PersonalEvent>.unmodifiable(_dataSource.getForDate(date)),
      );
    } on Exception catch (e) {
      return Left<Failure, List<PersonalEvent>>(
        CacheFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<PersonalEvent>>> getEventsForMonth(
    int year,
    int month,
  ) async {
    try {
      return Right<Failure, List<PersonalEvent>>(
        List<PersonalEvent>.unmodifiable(_dataSource.getForMonth(year, month)),
      );
    } on Exception catch (e) {
      return Left<Failure, List<PersonalEvent>>(
        CacheFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<PersonalEvent>>> getAllEvents() async {
    try {
      return Right<Failure, List<PersonalEvent>>(
        List<PersonalEvent>.unmodifiable(_dataSource.getAll()),
      );
    } on Exception catch (e) {
      return Left<Failure, List<PersonalEvent>>(
        CacheFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<PersonalEvent>>> getUpcomingEvents({
    int? limit,
  }) async {
    try {
      return Right<Failure, List<PersonalEvent>>(
        List<PersonalEvent>.unmodifiable(
          _dataSource.getUpcoming(from: _now(), limit: limit),
        ),
      );
    } on Exception catch (e) {
      return Left<Failure, List<PersonalEvent>>(
        CacheFailure(message: e.toString()),
      );
    }
  }

  Future<Either<Failure, void>> _wrapWrite(
    Future<void> Function() op,
  ) async {
    try {
      await op();
      return const Right<Failure, void>(null);
    } on Exception catch (e) {
      return Left<Failure, void>(CacheFailure(message: e.toString()));
    }
  }
}
