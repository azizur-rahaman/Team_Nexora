import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_inventory_items.dart';
import '../../domain/usecases/add_inventory_item.dart';
import '../../domain/usecases/update_inventory_item.dart';
import '../../domain/usecases/delete_inventory_item.dart';
import '../../domain/usecases/filter_inventory_items.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetAllInventoryItems getAllItems;
  final AddInventoryItem addItem;
  final UpdateInventoryItem updateItem;
  final DeleteInventoryItem deleteItem;
  final FilterInventoryItems filterItems;

  InventoryBloc({
    required this.getAllItems,
    required this.addItem,
    required this.updateItem,
    required this.deleteItem,
    required this.filterItems,
  }) : super(const InventoryInitial()) {
    on<LoadInventoryItems>(_onLoadInventoryItems);
    on<AddInventoryItemEvent>(_onAddInventoryItem);
    on<UpdateInventoryItemEvent>(_onUpdateInventoryItem);
    on<DeleteInventoryItemEvent>(_onDeleteInventoryItem);
    on<FilterInventoryItemsEvent>(_onFilterInventoryItems);
    on<ResetInventoryFilter>(_onResetInventoryFilter);
  }

  Future<void> _onLoadInventoryItems(
    LoadInventoryItems event,
    Emitter<InventoryState> emit,
  ) async {
    emit(const InventoryLoading());
    final failureOrItems = await getAllItems(NoParams());
    
    failureOrItems.fold(
      (failure) => emit(const InventoryError(serverFailureMessage)),
      (items) {
        if (items.isEmpty) {
          emit(const InventoryEmpty());
        } else {
          emit(InventoryLoaded(items));
        }
      },
    );
  }

  Future<void> _onAddInventoryItem(
    AddInventoryItemEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(const InventoryLoading());
    final failureOrItem = await addItem(AddInventoryItemParams(item: event.item));
    
    failureOrItem.fold(
      (failure) => emit(const InventoryError(serverFailureMessage)),
      (item) {
        emit(InventoryItemAdded(item));
        // Reload all items after adding
        add(const LoadInventoryItems());
      },
    );
  }

  Future<void> _onUpdateInventoryItem(
    UpdateInventoryItemEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(const InventoryLoading());
    final failureOrItem = await updateItem(UpdateInventoryItemParams(item: event.item));
    
    failureOrItem.fold(
      (failure) => emit(const InventoryError(serverFailureMessage)),
      (item) {
        emit(InventoryItemUpdated(item));
        // Reload all items after updating
        add(const LoadInventoryItems());
      },
    );
  }

  Future<void> _onDeleteInventoryItem(
    DeleteInventoryItemEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(const InventoryLoading());
    final failureOrVoid = await deleteItem(DeleteInventoryItemParams(id: event.id));
    
    failureOrVoid.fold(
      (failure) => emit(const InventoryError(serverFailureMessage)),
      (_) {
        emit(const InventoryItemDeleted());
        // Reload all items after deleting
        add(const LoadInventoryItems());
      },
    );
  }

  Future<void> _onFilterInventoryItems(
    FilterInventoryItemsEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(const InventoryLoading());
    final failureOrItems = await filterItems(
      FilterInventoryItemsParams(
        categories: event.categories,
        expirationStatus: event.expirationStatus,
        sortBy: event.sortBy,
        ascending: event.ascending,
      ),
    );
    
    failureOrItems.fold(
      (failure) => emit(const InventoryError(serverFailureMessage)),
      (items) {
        if (items.isEmpty) {
          emit(const InventoryEmpty());
        } else {
          emit(InventoryLoaded(items));
        }
      },
    );
  }

  Future<void> _onResetInventoryFilter(
    ResetInventoryFilter event,
    Emitter<InventoryState> emit,
  ) async {
    add(const LoadInventoryItems());
  }
}
