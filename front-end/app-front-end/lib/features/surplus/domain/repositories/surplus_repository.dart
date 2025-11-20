import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/surplus_item.dart';
import '../entities/surplus_request.dart';

/// Surplus Repository Interface
/// Abstract contract for surplus data operations
abstract class SurplusRepository {
  /// Get all available surplus items
  Future<Either<Failure, List<SurplusItem>>> getAllSurplusItems();

  /// Get surplus item by ID
  Future<Either<Failure, SurplusItem>> getSurplusItemById(String id);

  /// Get surplus items by type (donation/discounted)
  Future<Either<Failure, List<SurplusItem>>> getSurplusItemsByType(
    SurplusType type,
  );

  /// Search surplus items
  Future<Either<Failure, List<SurplusItem>>> searchSurplusItems(String query);

  /// Filter surplus items
  Future<Either<Failure, List<SurplusItem>>> filterSurplusItems({
    SurplusType? type,
    String? businessType,
    double? maxDistance,
    String? sortBy,
    bool? ascending,
  });

  /// Create surplus request/claim
  Future<Either<Failure, SurplusRequest>> createSurplusRequest(
    SurplusRequest request,
  );

  /// Get user's requests
  Future<Either<Failure, List<SurplusRequest>>> getUserRequests(String userId);

  /// Increment views
  Future<Either<Failure, void>> incrementViews(String id);
}
