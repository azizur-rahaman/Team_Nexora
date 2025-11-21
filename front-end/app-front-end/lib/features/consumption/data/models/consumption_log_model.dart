import '../../domain/entities/consumption_log.dart';

/// Consumption Log Model
/// Data transfer object for API communication
class ConsumptionLogModel extends ConsumptionLog {
  const ConsumptionLogModel({
    required super.id,
    required super.itemName,
    required super.quantity,
    required super.unit,
    required super.category,
    required super.date,
    super.notes,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from JSON
  factory ConsumptionLogModel.fromJson(Map<String, dynamic> json) {
    return ConsumptionLogModel(
      id: json['id'] as String,
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      category: ConsumptionCategoryX.fromString(json['category'] as String),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'quantity': quantity,
      'unit': unit,
      'category': category.name,
      'date': date.toIso8601String(),
      'notes': notes,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create request body for creating/updating log
  Map<String, dynamic> toRequestBody() {
    final Map<String, dynamic> body = {
      'itemName': itemName,
      'quantity': quantity,
      'unit': unit,
      'category': category.name,
      'date': date.toIso8601String(),
    };
    
    if (notes != null && notes!.isNotEmpty) {
      body['notes'] = notes;
    }
    
    return body;
  }

  /// Create model from entity
  factory ConsumptionLogModel.fromEntity(ConsumptionLog log) {
    return ConsumptionLogModel(
      id: log.id,
      itemName: log.itemName,
      quantity: log.quantity,
      unit: log.unit,
      category: log.category,
      date: log.date,
      notes: log.notes,
      userId: log.userId,
      createdAt: log.createdAt,
      updatedAt: log.updatedAt,
    );
  }
}
