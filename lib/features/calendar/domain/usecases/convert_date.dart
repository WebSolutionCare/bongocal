import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/calendar_date.dart';
import '../repositories/calendar_repository.dart';

/// Convert any Gregorian date into a [CalendarDate] (Gregorian + Bengali +
/// Hijri).
class ConvertDate {
  const ConvertDate(this._repository);

  final CalendarRepository _repository;

  Future<Either<Failure, CalendarDate>> call(DateTime date) =>
      _repository.convertToAllCalendars(date);
}
