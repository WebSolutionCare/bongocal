import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/pro_interest/domain/entities/pro_interest_submission.dart';
import 'package:bongocal/features/pro_interest/domain/repositories/pro_interest_repository.dart';
import 'package:dartz/dartz.dart';

/// In-memory fake repository for unit + widget tests. Records every
/// submission attempt and lets the test choose what the next call returns.
class FakeProInterestRepository implements ProInterestRepository {
  FakeProInterestRepository({this.nextResult});

  /// Override the result of the next [submitInterest] call.
  Either<Failure, void>? nextResult;

  /// Latest submission passed to [submitInterest], or null if none.
  ProInterestSubmission? lastSubmission;

  /// Total number of [submitInterest] invocations.
  int callCount = 0;

  @override
  Future<Either<Failure, void>> submitInterest(
    ProInterestSubmission submission,
  ) async {
    callCount++;
    lastSubmission = submission;
    return nextResult ?? const Right<Failure, void>(null);
  }
}
