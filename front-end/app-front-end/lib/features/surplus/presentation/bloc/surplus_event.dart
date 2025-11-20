import 'package:equatable/equatable.dart';
import '../../domain/entities/surplus_item.dart';

/// Surplus Events
abstract class SurplusEvent extends Equatable {
  const SurplusEvent();

  @override
  List<Object?> get props => [];
}

/// Load all available surplus items
class LoadSurplusItems extends SurplusEvent {
  const LoadSurplusItems();
}

/// Load surplus item by ID
class LoadSurplusItemById extends SurplusEvent {
  final String id;

  const LoadSurplusItemById(this.id);

  @override
  List<Object?> get props => [id];
}

/// Filter surplus items by type
class FilterSurplusByType extends SurplusEvent {
  final SurplusType? type;

  const FilterSurplusByType(this.type);

  @override
  List<Object?> get props => [type];
}

/// Search surplus items
class SearchSurplusItems extends SurplusEvent {
  final String query;

  const SearchSurplusItems(this.query);

  @override
  List<Object?> get props => [query];
}

/// Create a surplus request
class CreateSurplusRequestEvent extends SurplusEvent {
  final String surplusItemId;
  final String userId;
  final String? message;
  final DateTime requestedPickupTime;

  const CreateSurplusRequestEvent({
    required this.surplusItemId,
    required this.userId,
    this.message,
    required this.requestedPickupTime,
  });

  @override
  List<Object?> get props => [surplusItemId, userId, message, requestedPickupTime];
}

/// Increment item views
class IncrementSurplusViewsEvent extends SurplusEvent {
  final String id;

  const IncrementSurplusViewsEvent(this.id);

  @override
  List<Object?> get props => [id];
}
