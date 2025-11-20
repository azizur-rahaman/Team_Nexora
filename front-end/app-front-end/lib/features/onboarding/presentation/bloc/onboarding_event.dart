import 'package:equatable/equatable.dart';

/// Onboarding Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Event when user goes to next page
class OnboardingNextPage extends OnboardingEvent {
  const OnboardingNextPage();
}

/// Event when user goes to previous page
class OnboardingPreviousPage extends OnboardingEvent {
  const OnboardingPreviousPage();
}

/// Event when user jumps to specific page
class OnboardingPageChanged extends OnboardingEvent {
  final int pageIndex;

  const OnboardingPageChanged(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}

/// Event when user skips onboarding
class OnboardingSkipped extends OnboardingEvent {
  const OnboardingSkipped();
}

/// Event when user completes onboarding
class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}
