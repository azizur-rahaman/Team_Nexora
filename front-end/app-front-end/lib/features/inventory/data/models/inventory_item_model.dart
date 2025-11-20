import '../../domain/entities/inventory_item.dart';

/// Inventory Item Model - extends entity for JSON serialization
class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.unit,
    required super.category,
    required super.purchaseDate,
    required super.expirationDate,
    super.notes,
    super.imageUrl,
    super.barcode,
  });

  /// From JSON
  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      category: InventoryCategory.values.firstWhere(
        (e) => e.toString() == 'InventoryCategory.${json['category']}',
      ),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      expirationDate: DateTime.parse(json['expirationDate'] as String),
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      barcode: json['barcode'] as String?,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'category': category.toString().split('.').last,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'notes': notes,
      'imageUrl': imageUrl,
      'barcode': barcode,
    };
  }

  /// From Entity
  factory InventoryItemModel.fromEntity(InventoryItem entity) {
    return InventoryItemModel(
      id: entity.id,
      name: entity.name,
      quantity: entity.quantity,
      unit: entity.unit,
      category: entity.category,
      purchaseDate: entity.purchaseDate,
      expirationDate: entity.expirationDate,
      notes: entity.notes,
      imageUrl: entity.imageUrl,
      barcode: entity.barcode,
    );
  }
}
