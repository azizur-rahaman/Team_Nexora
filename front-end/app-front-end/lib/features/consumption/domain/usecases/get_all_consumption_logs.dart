import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/consumption_log.dart';
import '../repositories/consumption_repository.dart';

/// Get All Consumption Logs Use Case
class GetAllConsumptionLogs
    implements UseCase<List<ConsumptionLog>, ConsumptionLogsParams> {
  final ConsumptionRepository repository;

  GetAllConsumptionLogs(this.repository);

  @override
  Future<Either<Failure, List<ConsumptionLog>>> call(
    ConsumptionLogsParams params,
  ) async {
    return await repository.getAllLogs(
      page: params.page,
      limit: params.limit,
      category: params.category,
      startDate: params.startDate,
      endDate: params.endDate,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}

/// Parameters for getting consumption logs
class ConsumptionLogsParams {
  final int page;
  final int limit;
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? sortBy;
  final String? sortOrder;

  const ConsumptionLogsParams({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.sortOrder,
  });
}
