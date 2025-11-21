import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/consumption_statistics.dart';
import '../repositories/consumption_repository.dart';

/// Get Consumption Statistics Use Case
class GetConsumptionStatistics
    implements UseCase<ConsumptionStatistics, StatisticsParams> {
  final ConsumptionRepository repository;

  GetConsumptionStatistics(this.repository);

  @override
  Future<Either<Failure, ConsumptionStatistics>> call(
    StatisticsParams params,
  ) async {
    return await repository.getStatistics(
      period: params.period,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

/// Parameters for getting statistics
class StatisticsParams {
  final String period;
  final DateTime? startDate;
  final DateTime? endDate;

  const StatisticsParams({
    this.period = 'month',
    this.startDate,
    this.endDate,
  });
}
