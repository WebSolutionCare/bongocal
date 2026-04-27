import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/personal_event.dart';
import '../repositories/event_repository.dart';

class GetEventsForDate {
  const GetEventsForDate(this._repository);

  final EventRepository _repository;

  Future<Either<Failure, List<PersonalEvent>>> call(DateTime date) =>
      _repository.getEventsForDate(date);
}
