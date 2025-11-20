import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/inventory_repository.dart';

/// Delete Inventory Item Use Case
class DeleteInventoryItem implements UseCase<void, DeleteInventoryItemParams> {
  final InventoryRepository repository;

  DeleteInventoryItem(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteInventoryItemParams params) async {
    return await repository.deleteItem(params.id);
  }
}

class DeleteInventoryItemParams extends Equatable {
  final String id;

  const DeleteInventoryItemParams({required this.id});

  @override
  List<Object?> get props => [id];
}
