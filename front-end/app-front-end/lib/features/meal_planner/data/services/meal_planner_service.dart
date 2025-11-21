import 'package:khaddo/features/meal_planner/domain/entities/ingredient_replacement.dart';
import 'package:khaddo/features/meal_planner/domain/entities/meal.dart';
import 'package:khaddo/features/meal_planner/domain/entities/meal_plan.dart';
import 'package:khaddo/features/meal_planner/domain/entities/shopping_item.dart';


class MealPlannerService {
  // Generate AI meal plan based on preferences
  static MealPlan generateMealPlan({
    required double budget,
    required List<String> dietaryPreferences,
    required int numberOfMeals,
    int days = 7,
  }) {
    final startDate = DateTime.now();
    final dailyPlans = <DailyMealPlan>[];

    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      dailyPlans.add(_generateDailyPlan(date, dietaryPreferences, numberOfMeals));
    }

    final totalCost = dailyPlans.fold(0.0, (sum, plan) => sum + plan.totalCost);

    return MealPlan(
      id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
      name: 'AI Generated Plan',
      startDate: startDate,
      endDate: startDate.add(Duration(days: days - 1)),
      dailyPlans: dailyPlans,
      totalBudget: budget,
      estimatedCost: totalCost,
      dietaryPreferences: dietaryPreferences,
      numberOfMeals: numberOfMeals,
    );
  }

  static DailyMealPlan _generateDailyPlan(
    DateTime date,
    List<String> preferences,
    int numberOfMeals,
  ) {
    return DailyMealPlan(
      date: date,
      breakfast: numberOfMeals >= 1 ? _getSampleMeal(MealType.breakfast, preferences) : null,
      lunch: numberOfMeals >= 2 ? _getSampleMeal(MealType.lunch, preferences) : null,
      dinner: numberOfMeals >= 3 ? _getSampleMeal(MealType.dinner, preferences) : null,
    );
  }

  static Meal _getSampleMeal(MealType type, List<String> preferences) {
    final isVegetarian = preferences.contains('vegetarian');
    
    switch (type) {
      case MealType.breakfast:
        return isVegetarian
            ? _getSampleBreakfastVegetarian()
            : _getSampleBreakfastRegular();
      case MealType.lunch:
        return isVegetarian
            ? _getSampleLunchVegetarian()
            : _getSampleLunchRegular();
      case MealType.dinner:
        return isVegetarian
            ? _getSampleDinnerVegetarian()
            : _getSampleDinnerRegular();
      case MealType.snack:
        return _getSampleSnack();
    }
  }

  static Meal _getSampleBreakfastRegular() {
    return const Meal(
      id: 'meal_breakfast_1',
      name: 'Scrambled Eggs & Toast',
      description: 'Classic breakfast with eggs, whole wheat toast, and fresh tomatoes',
      type: MealType.breakfast,
      ingredients: ['Eggs', 'Whole wheat bread', 'Tomatoes', 'Butter', 'Salt', 'Pepper'],
      inventoryItems: ['Eggs', 'Bread'],
      estimatedCost: 3.50,
      prepTimeMinutes: 15,
      servings: 2,
      tags: ['quick', 'protein-rich'],
      nutrition: NutritionInfo(
        calories: 320,
        protein: 18,
        carbs: 28,
        fat: 14,
        fiber: 4,
      ),
    );
  }

  static Meal _getSampleBreakfastVegetarian() {
    return const Meal(
      id: 'meal_breakfast_2',
      name: 'Oatmeal with Berries',
      description: 'Hearty oatmeal topped with fresh berries and honey',
      type: MealType.breakfast,
      ingredients: ['Oats', 'Milk', 'Blueberries', 'Strawberries', 'Honey', 'Almonds'],
      inventoryItems: ['Oats', 'Milk'],
      estimatedCost: 2.80,
      prepTimeMinutes: 10,
      servings: 2,
      tags: ['vegetarian', 'healthy', 'fiber-rich'],
      nutrition: NutritionInfo(
        calories: 280,
        protein: 8,
        carbs: 42,
        fat: 6,
        fiber: 6,
      ),
    );
  }

  static Meal _getSampleLunchRegular() {
    return const Meal(
      id: 'meal_lunch_1',
      name: 'Grilled Chicken Salad',
      description: 'Fresh garden salad with grilled chicken breast',
      type: MealType.lunch,
      ingredients: ['Chicken breast', 'Lettuce', 'Cucumbers', 'Tomatoes', 'Olive oil', 'Lemon'],
      inventoryItems: ['Chicken breast', 'Lettuce'],
      estimatedCost: 5.20,
      prepTimeMinutes: 25,
      servings: 2,
      tags: ['protein-rich', 'low-carb'],
      nutrition: NutritionInfo(
        calories: 380,
        protein: 35,
        carbs: 12,
        fat: 18,
        fiber: 3,
      ),
    );
  }

  static Meal _getSampleLunchVegetarian() {
    return const Meal(
      id: 'meal_lunch_2',
      name: 'Quinoa Buddha Bowl',
      description: 'Nutritious bowl with quinoa, roasted vegetables, and tahini dressing',
      type: MealType.lunch,
      ingredients: ['Quinoa', 'Sweet potato', 'Chickpeas', 'Spinach', 'Tahini', 'Lemon'],
      inventoryItems: ['Quinoa', 'Sweet potato'],
      estimatedCost: 4.50,
      prepTimeMinutes: 30,
      servings: 2,
      tags: ['vegetarian', 'vegan', 'protein-rich'],
      nutrition: NutritionInfo(
        calories: 420,
        protein: 14,
        carbs: 58,
        fat: 12,
        fiber: 10,
      ),
    );
  }

  static Meal _getSampleDinnerRegular() {
    return const Meal(
      id: 'meal_dinner_1',
      name: 'Baked Salmon with Vegetables',
      description: 'Oven-baked salmon with roasted seasonal vegetables',
      type: MealType.dinner,
      ingredients: ['Salmon fillet', 'Broccoli', 'Carrots', 'Potatoes', 'Garlic', 'Herbs'],
      inventoryItems: ['Salmon', 'Broccoli'],
      estimatedCost: 8.90,
      prepTimeMinutes: 35,
      servings: 2,
      tags: ['omega-3', 'healthy'],
      nutrition: NutritionInfo(
        calories: 520,
        protein: 42,
        carbs: 35,
        fat: 22,
        fiber: 6,
      ),
    );
  }

  static Meal _getSampleDinnerVegetarian() {
    return const Meal(
      id: 'meal_dinner_2',
      name: 'Vegetable Stir-Fry',
      description: 'Colorful vegetable stir-fry with tofu and rice',
      type: MealType.dinner,
      ingredients: ['Tofu', 'Bell peppers', 'Broccoli', 'Rice', 'Soy sauce', 'Ginger'],
      inventoryItems: ['Tofu', 'Rice'],
      estimatedCost: 5.60,
      prepTimeMinutes: 25,
      servings: 2,
      tags: ['vegetarian', 'vegan', 'quick'],
      nutrition: NutritionInfo(
        calories: 450,
        protein: 18,
        carbs: 62,
        fat: 14,
        fiber: 8,
      ),
    );
  }

  static Meal _getSampleSnack() {
    return const Meal(
      id: 'meal_snack_1',
      name: 'Greek Yogurt with Nuts',
      description: 'Protein-rich snack with Greek yogurt and mixed nuts',
      type: MealType.snack,
      ingredients: ['Greek yogurt', 'Almonds', 'Walnuts', 'Honey'],
      inventoryItems: ['Greek yogurt'],
      estimatedCost: 2.20,
      prepTimeMinutes: 5,
      servings: 1,
      tags: ['quick', 'protein-rich'],
      nutrition: NutritionInfo(
        calories: 180,
        protein: 12,
        carbs: 15,
        fat: 8,
        fiber: 2,
      ),
    );
  }

  // Get shopping list from meal plan
  static ShoppingList generateShoppingList(MealPlan mealPlan) {
    final items = <ShoppingItem>[
      const ShoppingItem(
        id: 'item_1',
        name: 'Eggs',
        quantity: 12,
        unit: 'pieces',
        estimatedPrice: 4.50,
        category: 'Dairy & Eggs',
        isInInventory: true,
      ),
      const ShoppingItem(
        id: 'item_2',
        name: 'Whole wheat bread',
        quantity: 1,
        unit: 'loaf',
        estimatedPrice: 3.20,
        category: 'Bakery',
        usedInMeals: ['Scrambled Eggs & Toast'],
      ),
      const ShoppingItem(
        id: 'item_3',
        name: 'Chicken breast',
        quantity: 500,
        unit: 'grams',
        estimatedPrice: 7.80,
        category: 'Meat & Poultry',
        usedInMeals: ['Grilled Chicken Salad'],
      ),
      const ShoppingItem(
        id: 'item_4',
        name: 'Lettuce',
        quantity: 1,
        unit: 'head',
        estimatedPrice: 2.50,
        category: 'Vegetables',
        usedInMeals: ['Grilled Chicken Salad'],
      ),
      const ShoppingItem(
        id: 'item_5',
        name: 'Tomatoes',
        quantity: 4,
        unit: 'pieces',
        estimatedPrice: 3.60,
        category: 'Vegetables',
        usedInMeals: ['Scrambled Eggs & Toast', 'Grilled Chicken Salad'],
      ),
      const ShoppingItem(
        id: 'item_6',
        name: 'Salmon fillet',
        quantity: 400,
        unit: 'grams',
        estimatedPrice: 12.90,
        category: 'Seafood',
        usedInMeals: ['Baked Salmon with Vegetables'],
      ),
      const ShoppingItem(
        id: 'item_7',
        name: 'Broccoli',
        quantity: 300,
        unit: 'grams',
        estimatedPrice: 2.80,
        category: 'Vegetables',
        usedInMeals: ['Baked Salmon with Vegetables', 'Vegetable Stir-Fry'],
      ),
      const ShoppingItem(
        id: 'item_8',
        name: 'Quinoa',
        quantity: 250,
        unit: 'grams',
        estimatedPrice: 4.20,
        category: 'Grains',
        usedInMeals: ['Quinoa Buddha Bowl'],
      ),
      const ShoppingItem(
        id: 'item_9',
        name: 'Greek yogurt',
        quantity: 500,
        unit: 'grams',
        estimatedPrice: 5.50,
        category: 'Dairy & Eggs',
        usedInMeals: ['Greek Yogurt with Nuts'],
      ),
      const ShoppingItem(
        id: 'item_10',
        name: 'Mixed nuts',
        quantity: 200,
        unit: 'grams',
        estimatedPrice: 6.40,
        category: 'Snacks',
        usedInMeals: ['Greek Yogurt with Nuts'],
      ),
    ];

    return ShoppingList(
      id: 'shopping_${DateTime.now().millisecondsSinceEpoch}',
      mealPlanId: mealPlan.id,
      items: items,
      createdAt: DateTime.now(),
    );
  }

  // Get ingredient replacement suggestions
  static List<IngredientReplacement> getReplacementSuggestions() {
    return const [
      IngredientReplacement(
        id: 'replace_1',
        originalIngredient: 'Salmon fillet',
        replacementIngredient: 'Mackerel fillet',
        originalCost: 12.90,
        replacementCost: 7.20,
        benefits: ['Cheaper', 'Same omega-3', 'Sustainable'],
        confidenceScore: 0.92,
        reason: 'Mackerel provides similar nutritional benefits at a lower cost and is more sustainable',
        nutritionComparison: NutritionComparison(
          originalCalories: 280,
          replacementCalories: 260,
          originalProtein: 25,
          replacementProtein: 24,
          originalFat: 18,
          replacementFat: 16,
        ),
      ),
      IngredientReplacement(
        id: 'replace_2',
        originalIngredient: 'Chicken breast',
        replacementIngredient: 'Chicken thighs',
        originalCost: 7.80,
        replacementCost: 5.40,
        benefits: ['Cheaper', 'More flavor', 'Juicier'],
        confidenceScore: 0.88,
        reason: 'Chicken thighs are more affordable and flavorful while providing similar protein',
        nutritionComparison: NutritionComparison(
          originalCalories: 165,
          replacementCalories: 209,
          originalProtein: 31,
          replacementProtein: 26,
          originalFat: 3.6,
          replacementFat: 11,
        ),
      ),
      IngredientReplacement(
        id: 'replace_3',
        originalIngredient: 'Whole wheat bread',
        replacementIngredient: 'Homemade bread',
        originalCost: 3.20,
        replacementCost: 1.80,
        benefits: ['Cheaper', 'No preservatives', 'Fresher'],
        confidenceScore: 0.75,
        reason: 'Making bread at home is more economical and allows you to control ingredients',
        nutritionComparison: NutritionComparison(
          originalCalories: 80,
          replacementCalories: 75,
          originalProtein: 4,
          replacementProtein: 3.5,
          originalFat: 1,
          replacementFat: 0.5,
        ),
      ),
    ];
  }
}
