import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/holiday.dart';
import '../repositories/holiday_repository.dart';

class GetHolidaysForYear {
  const GetHolidaysForYear(this._repository);

  final HolidayRepository _repository;

  Future<Either<Failure, List<Holiday>>> call(int year) =>
      _repository.getAllHolidays(year);
}
