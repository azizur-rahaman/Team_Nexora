import 'package:equatable/equatable.dart';

/// Onboarding States
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

/// State when on a specific page
class OnboardingPageState extends OnboardingState {
  final int currentPage;
  final int totalPages;
  final bool isLastPage;

  const OnboardingPageState({
    required this.currentPage,
    required this.totalPages,
    required this.isLastPage,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, isLastPage];
}

/// State when onboarding is completed
class OnboardingCompletedState extends OnboardingState {
  const OnboardingCompletedState();
}

/// State when onboarding is skipped
class OnboardingSkippedState extends OnboardingState {
  const OnboardingSkippedState();
}
