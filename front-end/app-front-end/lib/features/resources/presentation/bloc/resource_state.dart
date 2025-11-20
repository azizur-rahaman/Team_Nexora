import 'package:equatable/equatable.dart';
import '../../domain/entities/resource.dart';

/// Resource States
abstract class ResourceState extends Equatable {
  const ResourceState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ResourceInitial extends ResourceState {
  const ResourceInitial();
}

/// Loading state
class ResourceLoading extends ResourceState {
  const ResourceLoading();
}

/// Resources loaded successfully
class ResourcesLoaded extends ResourceState {
  final List<Resource> resources;

  const ResourcesLoaded(this.resources);

  @override
  List<Object> get props => [resources];
}

/// Single resource loaded
class ResourceDetailLoaded extends ResourceState {
  final Resource resource;

  const ResourceDetailLoaded(this.resource);

  @override
  List<Object> get props => [resource];
}

/// Empty state (no resources found)
class ResourcesEmpty extends ResourceState {
  const ResourcesEmpty();
}

/// Error state
class ResourceError extends ResourceState {
  final String message;

  const ResourceError(this.message);

  @override
  List<Object> get props => [message];
}

/// Bookmark toggled
class ResourceBookmarkToggled extends ResourceState {
  final Resource resource;

  const ResourceBookmarkToggled(this.resource);

  @override
  List<Object> get props => [resource];
}
