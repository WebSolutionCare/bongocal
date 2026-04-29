import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../entities/festival_greeting.dart';
import '../repositories/festival_overlay_repository.dart';

/// Composes settings + the festival catalog + the "already shown" ledger
/// into a single yes/no answer for the overlay.
///
/// Returns a greeting iff:
///   1. [AppSettings.festivalGreetingsEnabled] is true, AND
///   2. [today] matches a known festival id, AND
///   3. that festival has not yet been shown on [today].
class CheckFestivalForToday {
  CheckFestivalForToday(this._repo);

  final FestivalOverlayRepository _repo;

  Future<Either<Failure, FestivalGreeting?>> call({
    required DateTime today,
    required AppSettings settings,
  }) async {
    if (!settings.festivalGreetingsEnabled) {
      return const Right<Failure, FestivalGreeting?>(null);
    }
    return _repo.getCurrentFestival(today);
  }
}
