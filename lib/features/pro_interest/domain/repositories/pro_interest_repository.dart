import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/pro_interest_submission.dart';

abstract class ProInterestRepository {
  /// Send the submission to the demand-validation backend. Treats any
  /// 2xx response (or opaque success on web) as a success.
  Future<Either<Failure, void>> submitInterest(
    ProInterestSubmission submission,
  );
}
