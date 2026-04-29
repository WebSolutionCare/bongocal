import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class OnboardingRepository {
  /// True if the user has completed (or skipped) onboarding before.
  Future<Either<Failure, bool>> hasCompletedOnboarding();

  /// Mark onboarding as complete so subsequent launches skip it.
  Future<Either<Failure, void>> markCompleted();
}
