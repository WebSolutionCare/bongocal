import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/month_data.dart';
import '../repositories/calendar_repository.dart';

class GetMonthDataParams extends Equatable {
  const GetMonthDataParams({required this.year, required this.month})
      : assert(month >= 1 && month <= 12, 'month must be 1..12');

  final int year;
  final int month;

  @override
  List<Object?> get props => <Object?>[year, month];
}

/// Build the 6×7 Sat-first grid for one Gregorian month.
class GetMonthData {
  const GetMonthData(this._repository);

  final CalendarRepository _repository;

  Future<Either<Failure, MonthData>> call(GetMonthDataParams params) =>
      _repository.getMonthData(params.year, params.month);
}
