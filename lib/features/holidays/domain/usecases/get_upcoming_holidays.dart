import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/holiday.dart';
import '../repositories/holiday_repository.dart';

class GetUpcomingHolidaysParams extends Equatable {
  const GetUpcomingHolidaysParams({required this.from, this.limit});

  final DateTime from;
  final int? limit;

  @override
  List<Object?> get props => <Object?>[from, limit];
}

class GetUpcomingHolidays {
  const GetUpcomingHolidays(this._repository);

  final HolidayRepository _repository;

  Future<Either<Failure, List<Holiday>>> call(
    GetUpcomingHolidaysParams params,
  ) =>
      _repository.getUpcomingHolidays(from: params.from, limit: params.limit);
}
