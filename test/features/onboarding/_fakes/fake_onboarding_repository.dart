import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:dartz/dartz.dart';

/// In-memory fake onboarding repo. The default state is "not completed";
/// `markCompleted` flips the flag and is recorded.
class FakeOnboardingRepository implements OnboardingRepository {
  FakeOnboardingRepository({this.completed = false});

  bool completed;
  int markCount = 0;

  @override
  Future<Either<Failure, bool>> hasCompletedOnboarding() async =>
      Right<Failure, bool>(completed);

  @override
  Future<Either<Failure, void>> markCompleted() async {
    completed = true;
    markCount++;
    return const Right<Failure, void>(null);
  }
}
