import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/personal_event.dart';
import '../repositories/event_repository.dart';

class GetUpcomingEvents {
  const GetUpcomingEvents(this._repository);

  final EventRepository _repository;

  Future<Either<Failure, List<PersonalEvent>>> call({int? limit}) =>
      _repository.getUpcomingEvents(limit: limit);
}
