import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/pro_interest_submission.dart';
import '../../domain/repositories/pro_interest_repository.dart';
import '../datasources/pro_interest_remote_datasource.dart';
import '../models/pro_interest_submission_model.dart';

class ProInterestRepositoryImpl implements ProInterestRepository {
  ProInterestRepositoryImpl({required ProInterestRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final ProInterestRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, void>> submitInterest(
    ProInterestSubmission submission,
  ) async {
    try {
      await _dataSource.submit(
        ProInterestSubmissionModel.fromEntity(submission),
      );
      return const Right<Failure, void>(null);
    } on NetworkException catch (e) {
      return Left<Failure, void>(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left<Failure, void>(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left<Failure, void>(UnknownFailure(message: e.toString()));
    }
  }
}
