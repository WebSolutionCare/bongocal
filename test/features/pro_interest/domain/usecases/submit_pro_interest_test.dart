import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/pro_interest/domain/entities/beta_interest.dart';
import 'package:bongocal/features/pro_interest/domain/entities/price_point.dart';
import 'package:bongocal/features/pro_interest/domain/entities/pro_feature.dart';
import 'package:bongocal/features/pro_interest/domain/entities/pro_interest_submission.dart';
import 'package:bongocal/features/pro_interest/domain/entities/usage_frequency.dart';
import 'package:bongocal/features/pro_interest/domain/usecases/submit_pro_interest.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_pro_interest_repository.dart';

ProInterestSubmission _submission() => ProInterestSubmission(
      email: 'a@b.com',
      usageFrequency: UsageFrequency.daily,
      features: const <ProFeature>[ProFeature.noAds],
      pricePoint: PricePoint.tk99,
      betaInterest: BetaInterest.yes,
      submittedAt: DateTime.utc(2026, 4, 28),
    );

void main() {
  test('SubmitProInterest forwards the submission to the repository', () async {
    final FakeProInterestRepository repo = FakeProInterestRepository();
    final ProInterestSubmission s = _submission();

    final result = await SubmitProInterest(repo)(s);

    expect(result.isRight(), isTrue);
    expect(repo.callCount, 1);
    expect(repo.lastSubmission, s);
  });

  test('SubmitProInterest propagates a repository failure', () async {
    final FakeProInterestRepository repo = FakeProInterestRepository(
      nextResult:
          const Left<Failure, void>(NetworkFailure(message: 'offline')),
    );

    final result = await SubmitProInterest(repo)(_submission());

    expect(result.isLeft(), isTrue);
    result.fold(
      (Failure f) => expect(f, isA<NetworkFailure>()),
      (_) => fail('expected Left'),
    );
  });
}
