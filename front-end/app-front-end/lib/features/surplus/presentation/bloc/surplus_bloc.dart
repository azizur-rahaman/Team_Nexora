import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/surplus_request.dart';
import '../../domain/usecases/create_surplus_request.dart' as usecases;
import '../../domain/usecases/get_all_surplus_items.dart';
import '../../domain/usecases/get_surplus_item_by_id.dart';
import '../../domain/usecases/increment_surplus_views.dart' as usecases;
import 'surplus_event.dart';
import 'surplus_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';

/// Surplus BLoC
/// Manages state for surplus items and requests
class SurplusBloc extends Bloc<SurplusEvent, SurplusState> {
  final GetAllSurplusItems getAllSurplusItems;
  final GetSurplusItemById getSurplusItemById;
  final usecases.CreateSurplusRequest createSurplusRequest;
  final usecases.IncrementSurplusViews incrementSurplusViews;

  SurplusBloc({
    required this.getAllSurplusItems,
    required this.getSurplusItemById,
    required this.createSurplusRequest,
    required this.incrementSurplusViews,
  }) : super(const SurplusInitial()) {
    on<LoadSurplusItems>(_onLoadSurplusItems);
    on<LoadSurplusItemById>(_onLoadSurplusItemById);
    on<FilterSurplusByType>(_onFilterSurplusByType);
    on<SearchSurplusItems>(_onSearchSurplusItems);
    on<CreateSurplusRequestEvent>(_onCreateSurplusRequest);
    on<IncrementSurplusViewsEvent>(_onIncrementSurplusViews);
  }

  Future<void> _onLoadSurplusItems(
    LoadSurplusItems event,
    Emitter<SurplusState> emit,
  ) async {
    emit(const SurplusLoading());
    final result = await getAllSurplusItems(NoParams());
    result.fold(
      (failure) => emit(const SurplusError(serverFailureMessage)),
      (items) => emit(SurplusLoaded(items: items)),
    );
  }

  Future<void> _onLoadSurplusItemById(
    LoadSurplusItemById event,
    Emitter<SurplusState> emit,
  ) async {
    emit(const SurplusLoading());
    final result = await getSurplusItemById(GetSurplusItemByIdParams(id: event.id));
    result.fold(
      (failure) => emit(const SurplusError(serverFailureMessage)),
      (item) => emit(SurplusItemDetailLoaded(item)),
    );
  }

  Future<void> _onFilterSurplusByType(
    FilterSurplusByType event,
    Emitter<SurplusState> emit,
  ) async {
    emit(const SurplusLoading());
    final result = await getAllSurplusItems(NoParams());
    result.fold(
      (failure) => emit(const SurplusError(serverFailureMessage)),
      (items) {
        final filtered = event.type != null
            ? items.where((item) => item.type == event.type).toList()
            : items;
        emit(SurplusLoaded(items: filtered, activeFilter: event.type));
      },
    );
  }

  Future<void> _onSearchSurplusItems(
    SearchSurplusItems event,
    Emitter<SurplusState> emit,
  ) async {
    emit(const SurplusLoading());
    final result = await getAllSurplusItems(NoParams());
    result.fold(
      (failure) => emit(const SurplusError(serverFailureMessage)),
      (items) {
        final query = event.query.toLowerCase();
        final filtered = items.where((item) {
          return item.title.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query) ||
              item.businessName.toLowerCase().contains(query);
        }).toList();
        emit(SurplusLoaded(items: filtered));
      },
    );
  }

  Future<void> _onCreateSurplusRequest(
    CreateSurplusRequestEvent event,
    Emitter<SurplusState> emit,
  ) async {
    emit(const SurplusLoading());
    final request = SurplusRequest(
      id: '',
      surplusItemId: event.surplusItemId,
      userId: event.userId,
      userName: 'User',
      userPhone: '01700000000',
      message: event.message,
      requestedPickupTime: event.requestedPickupTime,
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
    );

    final result = await createSurplusRequest(usecases.CreateSurplusRequestParams(request: request));
    result.fold(
      (failure) => emit(const SurplusError(serverFailureMessage)),
      (createdRequest) => emit(SurplusRequestCreated(createdRequest)),
    );
  }

  Future<void> _onIncrementSurplusViews(
    IncrementSurplusViewsEvent event,
    Emitter<SurplusState> emit,
  ) async {
    await incrementSurplusViews(usecases.IncrementSurplusViewsParams(id: event.id));
  }
}
