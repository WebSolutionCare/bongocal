import 'package:equatable/equatable.dart';

/// In-memory snapshot of the user's onboarding journey. Only [isCompleted]
/// persists across launches; [currentStep] is transient UI state.
class OnboardingState extends Equatable {
  const OnboardingState({
    required this.isCompleted,
    this.currentStep = 0,
  })  : assert(currentStep >= 0, 'currentStep must be non-negative');

  factory OnboardingState.initial() =>
      const OnboardingState(isCompleted: false);

  /// True once the user has finished (or skipped) onboarding. Persisted in
  /// the Hive settings box under key `'onboarding_completed'`.
  final bool isCompleted;

  /// Index into the onboarding PageView (0 = welcome, 1 = features,
  /// 2 = calendar preference, 3 = permissions).
  final int currentStep;

  OnboardingState copyWith({bool? isCompleted, int? currentStep}) =>
      OnboardingState(
        isCompleted: isCompleted ?? this.isCompleted,
        currentStep: currentStep ?? this.currentStep,
      );

  @override
  List<Object?> get props => <Object?>[isCompleted, currentStep];
}
