import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/resource.dart';
import '../../domain/repositories/resource_repository.dart';
import '../datasources/resource_data_source.dart';

/// Resource Repository Implementation
class ResourceRepositoryImpl implements ResourceRepository {
  final ResourceDataSource dataSource;

  ResourceRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Resource>>> getAllResources() async {
    try {
      final resources = await dataSource.getAllResources();
      return Right(resources);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Resource>> getResourceById(String id) async {
    try {
      final resource = await dataSource.getResourceById(id);
      return Right(resource);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Resource>>> getResourcesByCategory(
    ResourceCategory category,
  ) async {
    try {
      final resources = await dataSource.getResourcesByCategory(category);
      return Right(resources);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Resource>>> getResourcesByType(
    ResourceType type,
  ) async {
    try {
      final resources = await dataSource.getResourcesByType(type);
      return Right(resources);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Resource>>> searchResources(String query) async {
    try {
      final resources = await dataSource.searchResources(query);
      return Right(resources);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Resource>>> filterAndSortResources({
    List<ResourceCategory>? categories,
    List<ResourceType>? types,
    String? sortBy,
    bool? ascending,
  }) async {
    try {
      final resources = await dataSource.filterAndSortResources(
        categories: categories,
        types: types,
        sortBy: sortBy,
        ascending: ascending,
      );
      return Right(resources);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Resource>> toggleBookmark(String id) async {
    try {
      final resource = await dataSource.toggleBookmark(id);
      return Right(resource);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> incrementViews(String id) async {
    try {
      await dataSource.incrementViews(id);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Resource>> toggleLike(String id) async {
    try {
      final resource = await dataSource.toggleLike(id);
      return Right(resource);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
