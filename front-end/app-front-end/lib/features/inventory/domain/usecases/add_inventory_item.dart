import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';

/// Add Inventory Item Use Case
class AddInventoryItem implements UseCase<InventoryItem, AddInventoryItemParams> {
  final InventoryRepository repository;

  AddInventoryItem(this.repository);

  @override
  Future<Either<Failure, InventoryItem>> call(AddInventoryItemParams params) async {
    return await repository.addItem(params.item);
  }
}

class AddInventoryItemParams extends Equatable {
  final InventoryItem item;

  const AddInventoryItemParams({required this.item});

  @override
  List<Object?> get props => [item];
}
