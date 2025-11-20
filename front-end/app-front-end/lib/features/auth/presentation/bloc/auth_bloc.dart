import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;

  AuthBloc({
    required this.login,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
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

  String _mapFailureToMessage(failure) {
    return 'Unexpected error occurred';
  }
}
