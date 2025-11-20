import 'package:equatable/equatable.dart';
import '../../domain/entities/resource.dart';

/// Resource Events
abstract class ResourceEvent extends Equatable {
  const ResourceEvent();

  @override
  List<Object?> get props => [];
}

/// Load all resources
class LoadResources extends ResourceEvent {
  const LoadResources();
}

/// Load resource by ID
class LoadResourceById extends ResourceEvent {
  final String id;

  const LoadResourceById(this.id);

  @override
  List<Object> get props => [id];
}

/// Filter resources
class FilterResourcesEvent extends ResourceEvent {
  final List<ResourceCategory>? categories;
  final List<ResourceType>? types;
  final String? sortBy;
  final bool? ascending;

  const FilterResourcesEvent({
    this.categories,
    this.types,
    this.sortBy,
    this.ascending,
  });

  @override
  List<Object?> get props => [categories, types, sortBy, ascending];
}

/// Reset filter
class ResetResourceFilter extends ResourceEvent {
  const ResetResourceFilter();
}

/// Toggle bookmark
class ToggleResourceBookmark extends ResourceEvent {
  final String id;

  const ToggleResourceBookmark(this.id);

  @override
  List<Object> get props => [id];
}

/// Increment views
class IncrementResourceViews extends ResourceEvent {
  final String id;

  const IncrementResourceViews(this.id);

  @override
  List<Object> get props => [id];
}

/// Search resources
class SearchResourcesEvent extends ResourceEvent {
  final String query;

  const SearchResourcesEvent(this.query);

  @override
  List<Object> get props => [query];
}
