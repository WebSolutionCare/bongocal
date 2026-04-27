import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/personal_event.dart';
import '../repositories/event_repository.dart';

class GetEventsForMonthParams extends Equatable {
  const GetEventsForMonthParams({required this.year, required this.month})
      : assert(month >= 1 && month <= 12, 'month must be 1..12');

  final int year;
  final int month;

  @override
  List<Object?> get props => <Object?>[year, month];
}

class GetEventsForMonth {
  const GetEventsForMonth(this._repository);

  final EventRepository _repository;

  Future<Either<Failure, List<PersonalEvent>>> call(
    GetEventsForMonthParams params,
  ) =>
      _repository.getEventsForMonth(params.year, params.month);
}
