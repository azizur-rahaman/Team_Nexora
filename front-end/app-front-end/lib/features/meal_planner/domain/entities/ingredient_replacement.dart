class IngredientReplacement {
  final String id;
  final String originalIngredient;
  final String replacementIngredient;
  final double originalCost;
  final double replacementCost;
  final List<String> benefits; // e.g., 'Cheaper', 'Healthier', 'In Season'
  final double confidenceScore; // 0-1, AI confidence in this replacement
  final NutritionComparison? nutritionComparison;
  final String reason;

  const IngredientReplacement({
    required this.id,
    required this.originalIngredient,
    required this.replacementIngredient,
    required this.originalCost,
    required this.replacementCost,
    required this.benefits,
    required this.confidenceScore,
    this.nutritionComparison,
    required this.reason,
  });

  double get costSavings => originalCost - replacementCost;
  double get savingsPercentage => (costSavings / originalCost) * 100;
  bool get isCheaper => replacementCost < originalCost;
}

class NutritionComparison {
  final int originalCalories;
  final int replacementCalories;
  final double originalProtein;
  final double replacementProtein;
  final double originalFat;
  final double replacementFat;

  const NutritionComparison({
    required this.originalCalories,
    required this.replacementCalories,
    required this.originalProtein,
    required this.replacementProtein,
    required this.originalFat,
    required this.replacementFat,
  });

  int get caloriesDifference => replacementCalories - originalCalories;
  double get proteinDifference => replacementProtein - originalProtein;
  double get fatDifference => replacementFat - originalFat;
}
