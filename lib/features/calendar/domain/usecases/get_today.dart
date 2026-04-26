import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/calendar_date.dart';
import '../repositories/calendar_repository.dart';

/// Resolve "today" into a [CalendarDate] (all three calendars).
class GetToday {
  const GetToday(this._repository);

  final CalendarRepository _repository;

  Future<Either<Failure, CalendarDate>> call() => _repository.getCurrentDate();
}
