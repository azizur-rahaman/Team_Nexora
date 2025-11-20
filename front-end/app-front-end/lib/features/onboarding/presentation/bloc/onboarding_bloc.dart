import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// Onboarding BLoC
/// Manages the state and business logic for onboarding screens
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const int totalPages = 3;

  OnboardingBloc() : super(const OnboardingPageState(
    currentPage: 0,
    totalPages: totalPages,
    isLastPage: false,
  )) {
    on<OnboardingNextPage>(_onNextPage);
    on<OnboardingPreviousPage>(_onPreviousPage);
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingSkipped>(_onSkipped);
    on<OnboardingCompleted>(_onCompleted);
  }

  void _onNextPage(OnboardingNextPage event, Emitter<OnboardingState> emit) {
    if (state is OnboardingPageState) {
      final currentState = state as OnboardingPageState;
      final nextPage = currentState.currentPage + 1;

      if (nextPage < totalPages) {
        emit(OnboardingPageState(
          currentPage: nextPage,
          totalPages: totalPages,
          isLastPage: nextPage == totalPages - 1,
        ));
      } else {
        emit(const OnboardingCompletedState());
      }
    }
  }

  void _onPreviousPage(OnboardingPreviousPage event, Emitter<OnboardingState> emit) {
    if (state is OnboardingPageState) {
      final currentState = state as OnboardingPageState;
      final previousPage = currentState.currentPage - 1;

      if (previousPage >= 0) {
        emit(OnboardingPageState(
          currentPage: previousPage,
          totalPages: totalPages,
          isLastPage: false,
        ));
      }
    }
  }

  void _onPageChanged(OnboardingPageChanged event, Emitter<OnboardingState> emit) {
    emit(OnboardingPageState(
      currentPage: event.pageIndex,
      totalPages: totalPages,
      isLastPage: event.pageIndex == totalPages - 1,
    ));
  }

  void _onSkipped(OnboardingSkipped event, Emitter<OnboardingState> emit) {
    emit(const OnboardingSkippedState());
  }

  void _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) {
    emit(const OnboardingCompletedState());
  }
}
