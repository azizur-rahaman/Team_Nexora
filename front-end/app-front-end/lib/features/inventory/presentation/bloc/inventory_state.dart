import 'package:equatable/equatable.dart';
import '../../domain/entities/inventory_item.dart';

/// Inventory States
abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class InventoryInitial extends InventoryState {
  const InventoryInitial();
}

/// Loading State
class InventoryLoading extends InventoryState {
  const InventoryLoading();
}

/// Loaded State - List of Items
class InventoryLoaded extends InventoryState {
  final List<InventoryItem> items;

  const InventoryLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Single Item Loaded
class InventoryItemLoaded extends InventoryState {
  final InventoryItem item;

  const InventoryItemLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

/// Item Added Successfully
class InventoryItemAdded extends InventoryState {
  final InventoryItem item;

  const InventoryItemAdded(this.item);

  @override
  List<Object?> get props => [item];
}

/// Item Updated Successfully
class InventoryItemUpdated extends InventoryState {
  final InventoryItem item;

  const InventoryItemUpdated(this.item);

  @override
  List<Object?> get props => [item];
}

/// Item Deleted Successfully
class InventoryItemDeleted extends InventoryState {
  const InventoryItemDeleted();
}

/// Error State
class InventoryError extends InventoryState {
  final String message;

  const InventoryError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty State (no items found)
class InventoryEmpty extends InventoryState {
  const InventoryEmpty();
}
