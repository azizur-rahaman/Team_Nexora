import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import '../network/token_storage.dart';

/// Auth status checker to verify if user is authenticated
class AuthStatusChecker {
  final TokenStorage tokenStorage;

  AuthStatusChecker({required this.tokenStorage});

  /// Check if user is currently authenticated
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final token = await tokenStorage.getToken();
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  /// Get stored authentication token
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await tokenStorage.getToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  /// Clear authentication data
  Future<Either<Failure, void>> clearAuth() async {
    try {
      await tokenStorage.clearToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
