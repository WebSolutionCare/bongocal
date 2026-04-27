import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/event_repository.dart';

class DeleteEvent {
  const DeleteEvent(this._repository);

  final EventRepository _repository;

  Future<Either<Failure, void>> call(String id) => _repository.deleteEvent(id);
}
