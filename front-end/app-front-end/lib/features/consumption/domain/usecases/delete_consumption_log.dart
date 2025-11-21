import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/consumption_repository.dart';

/// Delete Consumption Log Use Case
class DeleteConsumptionLog implements UseCase<void, String> {
  final ConsumptionRepository repository;

  DeleteConsumptionLog(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    if (id.trim().isEmpty) {
      return Left(ValidationFailure('Log ID cannot be empty'));
    }

    return await repository.deleteLog(id);
  }
}
