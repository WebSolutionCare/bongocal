import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/festival_greeting.dart';

/// Boundary for the once-per-day festival greeting. The repository
/// composes the static greeting catalog with a per-festival "last shown"
/// ledger so the overlay only fires the first time the user opens the
/// app on a festival day.
abstract class FestivalOverlayRepository {
  /// The greeting to show right now, or `Right(null)` when:
  ///   - today is not a known festival, or
  ///   - the user has already dismissed today's greeting.
  /// Settings (festivalGreetingsEnabled) are applied by the use case,
  /// not the repository.
  Future<Either<Failure, FestivalGreeting?>> getCurrentFestival(
    DateTime today,
  );

  /// Record [festivalId] as shown on [date]. Idempotent — overwriting an
  /// older marker is fine because we only ever compare to today.
  Future<Either<Failure, void>> markAsShown({
    required String festivalId,
    required DateTime date,
  });

  /// Convenience: was the festival with [festivalId] already shown on
  /// [date]? Used by [getCurrentFestival].
  Future<Either<Failure, bool>> hasShown({
    required String festivalId,
    required DateTime date,
  });
}
