import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/consumption_log.dart';
import '../entities/consumption_statistics.dart';

/// Consumption Repository Contract
/// Defines the contract for consumption data operations
abstract class ConsumptionRepository {
  /// Get all consumption logs with optional filters
  Future<Either<Failure, List<ConsumptionLog>>> getAllLogs({
    int page = 1,
    int limit = 20,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    String? sortOrder,
  });

  /// Get a specific consumption log by ID
  Future<Either<Failure, ConsumptionLog>> getLogById(String id);

  /// Create a new consumption log
  Future<Either<Failure, ConsumptionLog>> createLog({
    required String itemName,
    required double quantity,
    required String unit,
    required String category,
    required DateTime date,
    String? notes,
  });

  /// Update an existing consumption log
  Future<Either<Failure, ConsumptionLog>> updateLog({
    required String id,
    String? itemName,
    double? quantity,
    String? unit,
    String? category,
    DateTime? date,
    String? notes,
  });

  /// Delete a consumption log
  Future<Either<Failure, void>> deleteLog(String id);

  /// Get consumption statistics
  Future<Either<Failure, ConsumptionStatistics>> getStatistics({
    String period = 'month',
    DateTime? startDate,
    DateTime? endDate,
  });
}
