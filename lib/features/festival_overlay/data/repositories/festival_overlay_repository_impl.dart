import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../holidays/domain/entities/holiday.dart';
import '../../../holidays/domain/repositories/holiday_repository.dart';
import '../../domain/entities/festival_greeting.dart';
import '../../domain/repositories/festival_overlay_repository.dart';
import '../datasources/festival_greetings_loader.dart';
import '../datasources/festival_local_datasource.dart';

class FestivalOverlayRepositoryImpl implements FestivalOverlayRepository {
  FestivalOverlayRepositoryImpl({
    required FestivalGreetingsLoader loader,
    required FestivalLocalDataSource localDataSource,
    required HolidayRepository holidayRepository,
  })  : _loader = loader,
        _local = localDataSource,
        _holidays = holidayRepository;

  final FestivalGreetingsLoader _loader;
  final FestivalLocalDataSource _local;
  final HolidayRepository _holidays;

  @override
  Future<Either<Failure, FestivalGreeting?>> getCurrentFestival(
    DateTime today,
  ) async {
    try {
      final holidayResult = await _holidays.getHolidayByDate(today);
      final Holiday? holiday = holidayResult.fold(
        (_) => null,
        (Holiday? h) => h,
      );
      if (holiday == null) {
        return const Right<Failure, FestivalGreeting?>(null);
      }
      final Map<String, FestivalGreeting> catalog = await _loader.load();
      final FestivalGreeting? greeting = catalog[holiday.id];
      if (greeting == null) {
        return const Right<Failure, FestivalGreeting?>(null);
      }
      final String? lastShown = _local.readLastShown(greeting.id);
      if (lastShown == FestivalLocalDataSource.formatDate(today)) {
        return const Right<Failure, FestivalGreeting?>(null);
      }
      return Right<Failure, FestivalGreeting?>(greeting);
    } on Exception catch (e) {
      return Left<Failure, FestivalGreeting?>(
        CacheFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> markAsShown({
    required String festivalId,
    required DateTime date,
  }) async {
    try {
      await _local.writeLastShown(festivalId: festivalId, date: date);
      return const Right<Failure, void>(null);
    } on Exception catch (e) {
      return Left<Failure, void>(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> hasShown({
    required String festivalId,
    required DateTime date,
  }) async {
    try {
      final String? last = _local.readLastShown(festivalId);
      return Right<Failure, bool>(
        last == FestivalLocalDataSource.formatDate(date),
      );
    } on Exception catch (e) {
      return Left<Failure, bool>(CacheFailure(message: e.toString()));
    }
  }
}
