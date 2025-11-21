class Meal {
  final String id;
  final String name;
  final String description;
  final MealType type;
  final List<String> ingredients;
  final List<String> inventoryItems; // Items from user's inventory
  final double estimatedCost;
  final int prepTimeMinutes;
  final int servings;
  final String? imageUrl;
  final List<String> tags; // e.g., 'vegetarian', 'quick', 'budget-friendly'
  final NutritionInfo? nutrition;

  const Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.ingredients,
    required this.inventoryItems,
    required this.estimatedCost,
    required this.prepTimeMinutes,
    required this.servings,
    this.imageUrl,
    this.tags = const [],
    this.nutrition,
  });

  Meal copyWith({
    String? id,
    String? name,
    String? description,
    MealType? type,
    List<String>? ingredients,
    List<String>? inventoryItems,
    double? estimatedCost,
    int? prepTimeMinutes,
    int? servings,
    String? imageUrl,
    List<String>? tags,
    NutritionInfo? nutrition,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      ingredients: ingredients ?? this.ingredients,
      inventoryItems: inventoryItems ?? this.inventoryItems,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      servings: servings ?? this.servings,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      nutrition: nutrition ?? this.nutrition,
    );
  }
}

enum MealType {
  breakfast,
  lunch,
  dinner,
  snack;

  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }
}

class NutritionInfo {
  final int calories;
  final double protein; // grams
  final double carbs; // grams
  final double fat; // grams
  final double fiber; // grams

  const NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });
}
