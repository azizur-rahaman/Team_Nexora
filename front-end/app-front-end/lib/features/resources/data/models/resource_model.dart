import '../../domain/entities/resource.dart';

/// Resource Model
/// Data transfer object for Resource entity
class ResourceModel extends Resource {
  const ResourceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.category,
    required super.type,
    required super.imageUrl,
    super.videoUrl,
    required super.readTimeMinutes,
    required super.publishedDate,
    required super.tags,
    super.views,
    super.likes,
    super.isBookmarked,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      category: ResourceCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      type: ResourceType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      imageUrl: json['imageUrl'] as String,
      videoUrl: json['videoUrl'] as String?,
      readTimeMinutes: json['readTimeMinutes'] as int,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
      tags: List<String>.from(json['tags'] as List),
      views: json['views'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'category': category.name,
      'type': type.name,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'readTimeMinutes': readTimeMinutes,
      'publishedDate': publishedDate.toIso8601String(),
      'tags': tags,
      'views': views,
      'likes': likes,
      'isBookmarked': isBookmarked,
    };
  }

  factory ResourceModel.fromEntity(Resource resource) {
    return ResourceModel(
      id: resource.id,
      title: resource.title,
      description: resource.description,
      content: resource.content,
      category: resource.category,
      type: resource.type,
      imageUrl: resource.imageUrl,
      videoUrl: resource.videoUrl,
      readTimeMinutes: resource.readTimeMinutes,
      publishedDate: resource.publishedDate,
      tags: resource.tags,
      views: resource.views,
      likes: resource.likes,
      isBookmarked: resource.isBookmarked,
    );
  }
}
