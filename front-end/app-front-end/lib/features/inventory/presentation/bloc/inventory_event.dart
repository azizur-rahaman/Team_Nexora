import 'package:equatable/equatable.dart';
import '../../domain/entities/inventory_item.dart';

/// Inventory Events
abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

/// Load All Inventory Items
class LoadInventoryItems extends InventoryEvent {
  const LoadInventoryItems();
}

/// Load Item by ID
class LoadInventoryItemById extends InventoryEvent {
  final String id;

  const LoadInventoryItemById(this.id);

  @override
  List<Object?> get props => [id];
}

/// Add Inventory Item
class AddInventoryItemEvent extends InventoryEvent {
  final InventoryItem item;

  const AddInventoryItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Update Inventory Item
class UpdateInventoryItemEvent extends InventoryEvent {
  final InventoryItem item;

  const UpdateInventoryItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Delete Inventory Item
class DeleteInventoryItemEvent extends InventoryEvent {
  final String id;

  const DeleteInventoryItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Filter and Sort Items
class FilterInventoryItemsEvent extends InventoryEvent {
  final List<InventoryCategory>? categories;
  final ExpirationStatus? expirationStatus;
  final String? sortBy;
  final bool? ascending;

  const FilterInventoryItemsEvent({
    this.categories,
    this.expirationStatus,
    this.sortBy,
    this.ascending,
  });

  @override
  List<Object?> get props => [categories, expirationStatus, sortBy, ascending];
}

/// Search Items
class SearchInventoryItems extends InventoryEvent {
  final String query;

  const SearchInventoryItems(this.query);

  @override
  List<Object?> get props => [query];
}

/// Reset to All Items
class ResetInventoryFilter extends InventoryEvent {
  const ResetInventoryFilter();
}
