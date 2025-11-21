import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } on UnauthorizedException catch (e) {
      return Left(ValidationFailure(e.message ?? 'Invalid credentials'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException {
      return Left(NetworkFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.register(username, email, password);
      return Right(user);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException {
      return Left(NetworkFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on NetworkException {
      return Left(NetworkFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on UnauthorizedException {
      return const Left(ValidationFailure('Not authenticated'));
    } on NetworkException {
      return Left(NetworkFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
