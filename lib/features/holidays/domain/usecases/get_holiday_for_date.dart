import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/holiday.dart';
import '../repositories/holiday_repository.dart';

class GetHolidayForDate {
  const GetHolidayForDate(this._repository);

  final HolidayRepository _repository;

  Future<Either<Failure, Holiday?>> call(DateTime date) =>
      _repository.getHolidayByDate(date);
}
