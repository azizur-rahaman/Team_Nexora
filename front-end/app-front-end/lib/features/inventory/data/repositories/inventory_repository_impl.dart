import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_data_source.dart';
import '../models/inventory_item_model.dart';

/// Inventory Repository Implementation
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryDataSource dataSource;

  InventoryRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<InventoryItem>>> getAllItems() async {
    try {
      final items = await dataSource.getAllItems();
      return Right(items);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> getItemById(String id) async {
    try {
      final item = await dataSource.getItemById(id);
      return Right(item);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<InventoryItem>>> getItemsByCategory(
    InventoryCategory category,
  ) async {
    try {
      final items = await dataSource.getItemsByCategory(category);
      return Right(items);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<InventoryItem>>> getExpiringSoonItems() async {
    try {
      final items = await dataSource.getExpiringSoonItems();
      return Right(items);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<InventoryItem>>> getExpiredItems() async {
    try {
      final items = await dataSource.getExpiredItems();
      return Right(items);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> addItem(InventoryItem item) async {
    try {
      final model = InventoryItemModel.fromEntity(item);
      final result = await dataSource.addItem(model);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> updateItem(InventoryItem item) async {
    try {
      final model = InventoryItemModel.fromEntity(item);
      final result = await dataSource.updateItem(model);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    try {
      await dataSource.deleteItem(id);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<InventoryItem>>> searchItems(String query) async {
    try {
      final items = await dataSource.searchItems(query);
      return Right(items);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<InventoryItem>>> filterAndSortItems({
    List<InventoryCategory>? categories,
    ExpirationStatus? expirationStatus,
    String? sortBy,
    bool? ascending,
  }) async {
    try {
      final items = await dataSource.filterAndSortItems(
        categories: categories,
        expirationStatus: expirationStatus,
        sortBy: sortBy,
        ascending: ascending,
      );
      return Right(items);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
