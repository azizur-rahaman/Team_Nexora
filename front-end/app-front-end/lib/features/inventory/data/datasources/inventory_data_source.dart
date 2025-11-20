import '../models/inventory_item_model.dart';
import '../../domain/entities/inventory_item.dart';

/// Abstract Data Source Interface
abstract class InventoryDataSource {
  Future<List<InventoryItemModel>> getAllItems();
  Future<InventoryItemModel> getItemById(String id);
  Future<List<InventoryItemModel>> getItemsByCategory(InventoryCategory category);
  Future<List<InventoryItemModel>> getExpiringSoonItems();
  Future<List<InventoryItemModel>> getExpiredItems();
  Future<InventoryItemModel> addItem(InventoryItemModel item);
  Future<InventoryItemModel> updateItem(InventoryItemModel item);
  Future<void> deleteItem(String id);
  Future<List<InventoryItemModel>> searchItems(String query);
  Future<List<InventoryItemModel>> filterAndSortItems({
    List<InventoryCategory>? categories,
    ExpirationStatus? expirationStatus,
    String? sortBy,
    bool? ascending,
  });
}

/// Mock Local Data Source Implementation (for now - can be replaced with actual API/database)
class InventoryLocalDataSource implements InventoryDataSource {
  // In-memory storage for mock data
  final List<InventoryItemModel> _items = InventoryItemSamples.items
      .map((item) => InventoryItemModel.fromEntity(item))
      .toList();

  @override
  Future<List<InventoryItemModel>> getAllItems() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return List.from(_items);
  }

  @override
  Future<InventoryItemModel> getItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _items.firstWhere((item) => item.id == id);
  }

  @override
  Future<List<InventoryItemModel>> getItemsByCategory(InventoryCategory category) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _items.where((item) => item.category == category).toList();
  }

  @override
  Future<List<InventoryItemModel>> getExpiringSoonItems() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _items.where((item) => item.isExpiringSoon).toList();
  }

  @override
  Future<List<InventoryItemModel>> getExpiredItems() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _items.where((item) => item.isExpired).toList();
  }

  @override
  Future<InventoryItemModel> addItem(InventoryItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _items.add(item);
    return item;
  }

  @override
  Future<InventoryItemModel> updateItem(InventoryItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
    return item;
  }

  @override
  Future<void> deleteItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<InventoryItemModel>> searchItems(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lowercaseQuery = query.toLowerCase();
    return _items
        .where((item) => item.name.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  @override
  Future<List<InventoryItemModel>> filterAndSortItems({
    List<InventoryCategory>? categories,
    ExpirationStatus? expirationStatus,
    String? sortBy,
    bool? ascending,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    var filtered = List<InventoryItemModel>.from(_items);

    // Filter by categories
    if (categories != null && categories.isNotEmpty) {
      filtered = filtered.where((item) => categories.contains(item.category)).toList();
    }

    // Filter by expiration status
    if (expirationStatus != null) {
      filtered = filtered.where((item) => item.expirationStatus == expirationStatus).toList();
    }

    // Sort
    if (sortBy != null) {
      filtered.sort((a, b) {
        int comparison;
        switch (sortBy) {
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          case 'expiration':
            comparison = a.expirationDate.compareTo(b.expirationDate);
            break;
          case 'quantity':
            comparison = a.quantity.compareTo(b.quantity);
            break;
          default:
            comparison = 0;
        }
        return (ascending ?? true) ? comparison : -comparison;
      });
    }

    return filtered;
  }
}
