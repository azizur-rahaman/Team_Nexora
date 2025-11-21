import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/consumption_log.dart';
import '../repositories/consumption_repository.dart';

/// Create Consumption Log Use Case
class CreateConsumptionLog
    implements UseCase<ConsumptionLog, CreateConsumptionLogParams> {
  final ConsumptionRepository repository;

  CreateConsumptionLog(this.repository);

  @override
  Future<Either<Failure, ConsumptionLog>> call(
    CreateConsumptionLogParams params,
  ) async {
    // Validate params
    if (params.itemName.trim().isEmpty) {
      return Left(ValidationFailure('Item name cannot be empty'));
    }
    
    if (params.quantity <= 0) {
      return Left(ValidationFailure('Quantity must be greater than 0'));
    }
    
    if (params.unit.trim().isEmpty) {
      return Left(ValidationFailure('Unit cannot be empty'));
    }
    
    if (params.date.isAfter(DateTime.now())) {
      return Left(ValidationFailure('Date cannot be in the future'));
    }

    return await repository.createLog(
      itemName: params.itemName,
      quantity: params.quantity,
      unit: params.unit,
      category: params.category,
      date: params.date,
      notes: params.notes,
    );
  }
}

/// Parameters for creating a consumption log
class CreateConsumptionLogParams {
  final String itemName;
  final double quantity;
  final String unit;
  final String category;
  final DateTime date;
  final String? notes;

  const CreateConsumptionLogParams({
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.date,
    this.notes,
  });
}
