import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/inventory_item.dart';

/// Inventory Repository Interface
/// Defines contract for inventory data operations
abstract class InventoryRepository {
  /// Get all inventory items
  Future<Either<Failure, List<InventoryItem>>> getAllItems();

  /// Get a single inventory item by ID
  Future<Either<Failure, InventoryItem>> getItemById(String id);

  /// Get items by category
  Future<Either<Failure, List<InventoryItem>>> getItemsByCategory(
    InventoryCategory category,
  );

  /// Get items expiring soon
  Future<Either<Failure, List<InventoryItem>>> getExpiringSoonItems();

  /// Get expired items
  Future<Either<Failure, List<InventoryItem>>> getExpiredItems();

  /// Add new inventory item
  Future<Either<Failure, InventoryItem>> addItem(InventoryItem item);

  /// Update inventory item
  Future<Either<Failure, InventoryItem>> updateItem(InventoryItem item);

  /// Delete inventory item
  Future<Either<Failure, void>> deleteItem(String id);

  /// Search items by name
  Future<Either<Failure, List<InventoryItem>>> searchItems(String query);

  /// Filter and sort items
  Future<Either<Failure, List<InventoryItem>>> filterAndSortItems({
    List<InventoryCategory>? categories,
    ExpirationStatus? expirationStatus,
    String? sortBy, // 'name', 'expiration', 'quantity'
    bool? ascending,
  });
}
