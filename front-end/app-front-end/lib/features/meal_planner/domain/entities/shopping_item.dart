class ShoppingItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final double estimatedPrice;
  final String category;
  final bool isPurchased;
  final bool isInInventory; // Already have this item
  final List<String> usedInMeals; // Which meals need this ingredient

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.estimatedPrice,
    required this.category,
    this.isPurchased = false,
    this.isInInventory = false,
    this.usedInMeals = const [],
  });

  ShoppingItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    double? estimatedPrice,
    String? category,
    bool? isPurchased,
    bool? isInInventory,
    List<String>? usedInMeals,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      category: category ?? this.category,
      isPurchased: isPurchased ?? this.isPurchased,
      isInInventory: isInInventory ?? this.isInInventory,
      usedInMeals: usedInMeals ?? this.usedInMeals,
    );
  }
}

class ShoppingList {
  final String id;
  final String mealPlanId;
  final List<ShoppingItem> items;
  final DateTime createdAt;

  const ShoppingList({
    required this.id,
    required this.mealPlanId,
    required this.items,
    required this.createdAt,
  });

  double get totalCost {
    return items.fold(0, (sum, item) => sum + item.estimatedPrice);
  }

  double get remainingCost {
    return items
        .where((item) => !item.isPurchased && !item.isInInventory)
        .fold(0, (sum, item) => sum + item.estimatedPrice);
  }

  int get purchasedCount {
    return items.where((item) => item.isPurchased).length;
  }

  int get totalCount => items.length;

  double get progress {
    if (totalCount == 0) return 0;
    return purchasedCount / totalCount;
  }
}
