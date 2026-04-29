import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/onboarding_repository.dart';

class CompleteOnboarding {
  const CompleteOnboarding(this._repository);

  final OnboardingRepository _repository;

  Future<Either<Failure, void>> call() => _repository.markCompleted();
}
