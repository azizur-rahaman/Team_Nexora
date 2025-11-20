import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_resources.dart';
import '../../domain/usecases/get_resource_by_id.dart';
import '../../domain/usecases/filter_resources.dart';
import '../../domain/usecases/toggle_bookmark.dart';
import '../../domain/usecases/increment_views.dart';
import 'resource_event.dart';
import 'resource_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final GetAllResources getAllResources;
  final GetResourceById getResourceById;
  final FilterResources filterResources;
  final ToggleBookmark toggleBookmark;
  final IncrementViews incrementViews;

  ResourceBloc({
    required this.getAllResources,
    required this.getResourceById,
    required this.filterResources,
    required this.toggleBookmark,
    required this.incrementViews,
  }) : super(const ResourceInitial()) {
    on<LoadResources>(_onLoadResources);
    on<LoadResourceById>(_onLoadResourceById);
    on<FilterResourcesEvent>(_onFilterResources);
    on<ResetResourceFilter>(_onResetFilter);
    on<ToggleResourceBookmark>(_onToggleBookmark);
    on<IncrementResourceViews>(_onIncrementViews);
  }

  Future<void> _onLoadResources(
    LoadResources event,
    Emitter<ResourceState> emit,
  ) async {
    emit(const ResourceLoading());
    final failureOrResources = await getAllResources(NoParams());

    failureOrResources.fold(
      (failure) => emit(const ResourceError(serverFailureMessage)),
      (resources) {
        if (resources.isEmpty) {
          emit(const ResourcesEmpty());
        } else {
          emit(ResourcesLoaded(resources));
        }
      },
    );
  }

  Future<void> _onLoadResourceById(
    LoadResourceById event,
    Emitter<ResourceState> emit,
  ) async {
    emit(const ResourceLoading());
    final failureOrResource =
        await getResourceById(GetResourceByIdParams(id: event.id));

    failureOrResource.fold(
      (failure) => emit(const ResourceError(serverFailureMessage)),
      (resource) => emit(ResourceDetailLoaded(resource)),
    );
  }

  Future<void> _onFilterResources(
    FilterResourcesEvent event,
    Emitter<ResourceState> emit,
  ) async {
    emit(const ResourceLoading());
    final failureOrResources = await filterResources(
      FilterResourcesParams(
        categories: event.categories,
        types: event.types,
        sortBy: event.sortBy,
        ascending: event.ascending,
      ),
    );

    failureOrResources.fold(
      (failure) => emit(const ResourceError(serverFailureMessage)),
      (resources) {
        if (resources.isEmpty) {
          emit(const ResourcesEmpty());
        } else {
          emit(ResourcesLoaded(resources));
        }
      },
    );
  }

  Future<void> _onResetFilter(
    ResetResourceFilter event,
    Emitter<ResourceState> emit,
  ) async {
    add(const LoadResources());
  }

  Future<void> _onToggleBookmark(
    ToggleResourceBookmark event,
    Emitter<ResourceState> emit,
  ) async {
    final failureOrResource =
        await toggleBookmark(ToggleBookmarkParams(id: event.id));

    failureOrResource.fold(
      (failure) => emit(const ResourceError(serverFailureMessage)),
      (resource) {
        emit(ResourceBookmarkToggled(resource));
        // Reload resources after toggling bookmark
        add(const LoadResources());
      },
    );
  }

  Future<void> _onIncrementViews(
    IncrementResourceViews event,
    Emitter<ResourceState> emit,
  ) async {
    await incrementViews(IncrementViewsParams(id: event.id));
    // Don't emit state, this is a silent operation
  }
}
