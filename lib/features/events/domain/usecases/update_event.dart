import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/personal_event.dart';
import '../repositories/event_repository.dart';

class UpdateEvent {
  const UpdateEvent(this._repository);

  final EventRepository _repository;

  Future<Either<Failure, void>> call(PersonalEvent event) =>
      _repository.updateEvent(event);
}
