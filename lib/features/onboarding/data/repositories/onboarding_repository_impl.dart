import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl({required OnboardingLocalDataSource dataSource})
      : _dataSource = dataSource;

  final OnboardingLocalDataSource _dataSource;

  @override
  Future<Either<Failure, bool>> hasCompletedOnboarding() async {
    try {
      return Right<Failure, bool>(_dataSource.readCompleted());
    } on Exception catch (e) {
      return Left<Failure, bool>(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markCompleted() async {
    try {
      await _dataSource.writeCompleted(true);
      return const Right<Failure, void>(null);
    } on Exception catch (e) {
      return Left<Failure, void>(CacheFailure(message: e.toString()));
    }
  }
}
