import '../../domain/entities/resource.dart';
import '../models/resource_model.dart';

/// Resource Data Source Abstract Interface
abstract class ResourceDataSource {
  Future<List<ResourceModel>> getAllResources();
  Future<ResourceModel> getResourceById(String id);
  Future<List<ResourceModel>> getResourcesByCategory(ResourceCategory category);
  Future<List<ResourceModel>> getResourcesByType(ResourceType type);
  Future<List<ResourceModel>> searchResources(String query);
  Future<List<ResourceModel>> filterAndSortResources({
    List<ResourceCategory>? categories,
    List<ResourceType>? types,
    String? sortBy,
    bool? ascending,
  });
  Future<ResourceModel> toggleBookmark(String id);
  Future<void> incrementViews(String id);
  Future<ResourceModel> toggleLike(String id);
}

/// Local Resource Data Source Implementation (Mock Data)
/// Replace with API implementation in production
class ResourceLocalDataSource implements ResourceDataSource {
  // In-memory storage for demo purposes
  final List<ResourceModel> _resources = ResourceSamples.items
      .map((item) => ResourceModel.fromEntity(item))
      .toList();

  @override
  Future<List<ResourceModel>> getAllResources() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_resources);
  }

  @override
  Future<ResourceModel> getResourceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _resources.firstWhere(
      (resource) => resource.id == id,
      orElse: () => throw Exception('Resource not found'),
    );
  }

  @override
  Future<List<ResourceModel>> getResourcesByCategory(
    ResourceCategory category,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _resources
        .where((resource) => resource.category == category)
        .toList();
  }

  @override
  Future<List<ResourceModel>> getResourcesByType(ResourceType type) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _resources.where((resource) => resource.type == type).toList();
  }

  @override
  Future<List<ResourceModel>> searchResources(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lowerQuery = query.toLowerCase();
    return _resources.where((resource) {
      return resource.title.toLowerCase().contains(lowerQuery) ||
          resource.description.toLowerCase().contains(lowerQuery) ||
          resource.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  @override
  Future<List<ResourceModel>> filterAndSortResources({
    List<ResourceCategory>? categories,
    List<ResourceType>? types,
    String? sortBy,
    bool? ascending,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filtered = List<ResourceModel>.from(_resources);

    // Filter by categories
    if (categories != null && categories.isNotEmpty) {
      filtered =
          filtered.where((r) => categories.contains(r.category)).toList();
    }

    // Filter by types
    if (types != null && types.isNotEmpty) {
      filtered = filtered.where((r) => types.contains(r.type)).toList();
    }

    // Sort
    if (sortBy != null) {
      filtered.sort((a, b) {
        int comparison;
        switch (sortBy) {
          case 'title':
            comparison = a.title.compareTo(b.title);
            break;
          case 'date':
            comparison = a.publishedDate.compareTo(b.publishedDate);
            break;
          case 'views':
            comparison = a.views.compareTo(b.views);
            break;
          case 'likes':
            comparison = a.likes.compareTo(b.likes);
            break;
          case 'readTime':
            comparison = a.readTimeMinutes.compareTo(b.readTimeMinutes);
            break;
          default:
            comparison = 0;
        }
        return ascending == true ? comparison : -comparison;
      });
    }

    return filtered;
  }

  @override
  Future<ResourceModel> toggleBookmark(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _resources.indexWhere((r) => r.id == id);
    if (index == -1) throw Exception('Resource not found');

    final resource = _resources[index];
    final updated = ResourceModel.fromEntity(
      resource.copyWith(isBookmarked: !resource.isBookmarked),
    );
    _resources[index] = updated;
    return updated;
  }

  @override
  Future<void> incrementViews(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _resources.indexWhere((r) => r.id == id);
    if (index == -1) throw Exception('Resource not found');

    final resource = _resources[index];
    final updated = ResourceModel.fromEntity(
      resource.copyWith(views: resource.views + 1),
    );
    _resources[index] = updated;
  }

  @override
  Future<ResourceModel> toggleLike(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _resources.indexWhere((r) => r.id == id);
    if (index == -1) throw Exception('Resource not found');

    final resource = _resources[index];
    // Simplified like toggle (in real app, track user likes separately)
    final updated = ResourceModel.fromEntity(
      resource.copyWith(likes: resource.likes + 1),
    );
    _resources[index] = updated;
    return updated;
  }
}
