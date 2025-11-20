import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/resource.dart';

/// Resource Repository Interface
/// Abstract contract for resource data operations
abstract class ResourceRepository {
  /// Get all resources
  Future<Either<Failure, List<Resource>>> getAllResources();

  /// Get resource by ID
  Future<Either<Failure, Resource>> getResourceById(String id);

  /// Get resources by category
  Future<Either<Failure, List<Resource>>> getResourcesByCategory(
    ResourceCategory category,
  );

  /// Get resources by type
  Future<Either<Failure, List<Resource>>> getResourcesByType(
    ResourceType type,
  );

  /// Search resources by query
  Future<Either<Failure, List<Resource>>> searchResources(String query);

  /// Filter and sort resources
  Future<Either<Failure, List<Resource>>> filterAndSortResources({
    List<ResourceCategory>? categories,
    List<ResourceType>? types,
    String? sortBy,
    bool? ascending,
  });

  /// Toggle bookmark status
  Future<Either<Failure, Resource>> toggleBookmark(String id);

  /// Increment views
  Future<Either<Failure, void>> incrementViews(String id);

  /// Toggle like
  Future<Either<Failure, Resource>> toggleLike(String id);
}
