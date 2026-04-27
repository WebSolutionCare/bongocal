import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/holiday.dart';
import '../entities/holiday_type.dart';
import '../repositories/holiday_repository.dart';

class FilterHolidaysByTypeParams extends Equatable {
  const FilterHolidaysByTypeParams({required this.type, required this.year});

  final HolidayType type;
  final int year;

  @override
  List<Object?> get props => <Object?>[type, year];
}

class FilterHolidaysByType {
  const FilterHolidaysByType(this._repository);

  final HolidayRepository _repository;

  Future<Either<Failure, List<Holiday>>> call(
    FilterHolidaysByTypeParams params,
  ) =>
      _repository.getHolidaysByType(params.type, year: params.year);
}
