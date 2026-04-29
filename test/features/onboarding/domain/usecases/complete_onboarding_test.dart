import 'package:bongocal/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_onboarding_repository.dart';

void main() {
  test('CompleteOnboarding flips the persisted flag', () async {
    final FakeOnboardingRepository repo = FakeOnboardingRepository();
    expect(repo.completed, isFalse);

    final result = await CompleteOnboarding(repo)();

    expect(result.isRight(), isTrue);
    expect(repo.completed, isTrue);
    expect(repo.markCount, 1);
  });
}
