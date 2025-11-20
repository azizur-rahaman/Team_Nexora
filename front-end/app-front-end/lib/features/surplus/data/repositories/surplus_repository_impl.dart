import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/surplus_item.dart';
import '../../domain/entities/surplus_request.dart';
import '../../domain/repositories/surplus_repository.dart';
import '../datasources/surplus_data_source.dart';

/// Surplus Repository Implementation
/// Handles data operations and error handling for surplus items
class SurplusRepositoryImpl implements SurplusRepository {
  final SurplusDataSource dataSource;

  SurplusRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<SurplusItem>>> getAllSurplusItems() async {
    try {
      final items = await dataSource.getAllSurplusItems();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SurplusItem>> getSurplusItemById(String id) async {
    try {
      final item = await dataSource.getSurplusItemById(id);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SurplusItem>>> getSurplusItemsByType(SurplusType type) async {
    try {
      final items = await dataSource.getSurplusItemsByType(type);
      return Right(items);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SurplusItem>>> searchSurplusItems(String query) async {
    try {
      final items = await dataSource.searchSurplusItems(query);
      return Right(items);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SurplusItem>>> filterSurplusItems({
    SurplusType? type,
    String? businessType,
    double? maxDistance,
    String? sortBy,
    bool? ascending,
  }) async {
    try {
      final items = await dataSource.filterSurplusItems(
        type: type,
        maxDistance: maxDistance?.toInt(),
      );
      return Right(items);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SurplusRequest>> createSurplusRequest(SurplusRequest request) async {
    try {
      final requestModel = await dataSource.createSurplusRequest(
        request as dynamic,
      );
      return Right(requestModel);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SurplusRequest>>> getUserRequests(String userId) async {
    try {
      final requests = await dataSource.getUserRequests(userId);
      return Right(requests);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> incrementViews(String id) async {
    try {
      await dataSource.incrementViews(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
