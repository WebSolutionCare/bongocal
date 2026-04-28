import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/pro_interest_submission.dart';
import '../repositories/pro_interest_repository.dart';

class SubmitProInterest {
  const SubmitProInterest(this._repository);

  final ProInterestRepository _repository;

  Future<Either<Failure, void>> call(ProInterestSubmission submission) =>
      _repository.submitInterest(submission);
}
