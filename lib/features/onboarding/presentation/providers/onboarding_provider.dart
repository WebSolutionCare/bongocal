import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_service.dart';
import '../../data/datasources/onboarding_local_datasource.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';

final Provider<OnboardingLocalDataSource>
    onboardingLocalDataSourceProvider =
    Provider<OnboardingLocalDataSource>((Ref ref) {
  final Box<dynamic> box = Hive.box<dynamic>(HiveBoxes.settings);
  return OnboardingLocalDataSource(box: box);
});

final Provider<OnboardingRepository> onboardingRepositoryProvider =
    Provider<OnboardingRepository>(
  (Ref ref) => OnboardingRepositoryImpl(
    dataSource: ref.watch(onboardingLocalDataSourceProvider),
  ),
);

/// Whether the user has completed (or skipped) onboarding before. The
/// router watches this to decide where the splash routes to.
final FutureProvider<bool> hasCompletedOnboardingProvider =
    FutureProvider<bool>((Ref ref) async {
  final OnboardingRepository repo = ref.watch(onboardingRepositoryProvider);
  final result = await repo.hasCompletedOnboarding();
  return result.fold((_) => false, (bool v) => v);
});

/// Minimum on-screen time for the splash. Production = 2 s; tests
/// override to `Duration.zero` so they don't wait.
final Provider<Duration> splashMinDurationProvider =
    Provider<Duration>((Ref ref) => const Duration(seconds: 2));
