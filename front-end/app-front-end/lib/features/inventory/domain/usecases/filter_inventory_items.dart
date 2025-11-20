import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';

/// Filter and Sort Inventory Items Use Case
class FilterInventoryItems implements UseCase<List<InventoryItem>, FilterInventoryItemsParams> {
  final InventoryRepository repository;

  FilterInventoryItems(this.repository);

  @override
  Future<Either<Failure, List<InventoryItem>>> call(FilterInventoryItemsParams params) async {
    return await repository.filterAndSortItems(
      categories: params.categories,
      expirationStatus: params.expirationStatus,
      sortBy: params.sortBy,
      ascending: params.ascending,
    );
  }
}

class FilterInventoryItemsParams extends Equatable {
  final List<InventoryCategory>? categories;
  final ExpirationStatus? expirationStatus;
  final String? sortBy;
  final bool? ascending;

  const FilterInventoryItemsParams({
    this.categories,
    this.expirationStatus,
    this.sortBy,
    this.ascending,
  });

  @override
  List<Object?> get props => [categories, expirationStatus, sortBy, ascending];
}
