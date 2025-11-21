import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser implements UseCase<User, RegisterUserParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterUserParams params) async {
    return await repository.register(
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterUserParams extends Equatable {
  final String username;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}
