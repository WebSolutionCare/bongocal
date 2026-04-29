import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/festival_overlay/domain/entities/festival_greeting.dart';
import 'package:bongocal/features/festival_overlay/domain/repositories/festival_overlay_repository.dart';
import 'package:dartz/dartz.dart';

/// In-memory fake — used by use-case tests so we don't need Hive +
/// HolidayRepository wired up just to assert composition logic.
class FakeFestivalOverlayRepository implements FestivalOverlayRepository {
  FakeFestivalOverlayRepository({this.greetingForToday});

  /// What [getCurrentFestival] should return regardless of [today].
  FestivalGreeting? greetingForToday;

  /// Records every (festivalId, dateKey) the use case marks shown.
  final List<MapEntry<String, String>> shownLog =
      <MapEntry<String, String>>[];

  @override
  Future<Either<Failure, FestivalGreeting?>> getCurrentFestival(
    DateTime today,
  ) async =>
      Right<Failure, FestivalGreeting?>(greetingForToday);

  @override
  Future<Either<Failure, void>> markAsShown({
    required String festivalId,
    required DateTime date,
  }) async {
    shownLog.add(
      MapEntry<String, String>(
        festivalId,
        '${date.year}-${date.month}-${date.day}',
      ),
    );
    return const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, bool>> hasShown({
    required String festivalId,
    required DateTime date,
  }) async {
    final String target = '${date.year}-${date.month}-${date.day}';
    final bool found = shownLog.any(
      (MapEntry<String, String> e) => e.key == festivalId && e.value == target,
    );
    return Right<Failure, bool>(found);
  }
}
