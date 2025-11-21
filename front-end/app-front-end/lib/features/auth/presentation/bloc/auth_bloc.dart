import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/logout.dart';
import '../../../../core/error/failures.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final RegisterUser registerUser;
  final Logout logout;

  AuthBloc({
    required this.login,
    required this.registerUser,
    required this.logout,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await login(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerUser(
      RegisterUserParams(
        username: event.username,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Simulate password reset API call
    // TODO: Implement actual password reset use case
    await Future.delayed(const Duration(seconds: 2));

    // For now, we'll just emit success
    // In a real implementation, this would call a use case
    emit(AuthPasswordResetSent(email: event.email));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await logout.call(null);

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error occurred. Please try again later.';
    } else if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network.';
    } else if (failure is ValidationFailure) {
      return failure.message;
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
