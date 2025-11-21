import 'meal.dart';

class MealPlan {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<DailyMealPlan> dailyPlans;
  final double totalBudget;
  final double estimatedCost;
  final List<String> dietaryPreferences;
  final int numberOfMeals;

  const MealPlan({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.dailyPlans,
    required this.totalBudget,
    required this.estimatedCost,
    this.dietaryPreferences = const [],
    required this.numberOfMeals,
  });

  bool get isWithinBudget => estimatedCost <= totalBudget;
  double get budgetRemaining => totalBudget - estimatedCost;
  int get daysCount => dailyPlans.length;
}

class DailyMealPlan {
  final DateTime date;
  final Meal? breakfast;
  final Meal? lunch;
  final Meal? dinner;
  final List<Meal> snacks;

  const DailyMealPlan({
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snacks = const [],
  });

  double get totalCost {
    double cost = 0;
    if (breakfast != null) cost += breakfast!.estimatedCost;
    if (lunch != null) cost += lunch!.estimatedCost;
    if (dinner != null) cost += dinner!.estimatedCost;
    for (var snack in snacks) {
      cost += snack.estimatedCost;
    }
    return cost;
  }

  int get totalCalories {
    int calories = 0;
    if (breakfast != null && breakfast!.nutrition != null) {
      calories += breakfast!.nutrition!.calories;
    }
    if (lunch != null && lunch!.nutrition != null) {
      calories += lunch!.nutrition!.calories;
    }
    if (dinner != null && dinner!.nutrition != null) {
      calories += dinner!.nutrition!.calories;
    }
    for (var snack in snacks) {
      if (snack.nutrition != null) {
        calories += snack.nutrition!.calories;
      }
    }
    return calories;
  }

  List<Meal> get allMeals {
    final meals = <Meal>[];
    if (breakfast != null) meals.add(breakfast!);
    if (lunch != null) meals.add(lunch!);
    if (dinner != null) meals.add(dinner!);
    meals.addAll(snacks);
    return meals;
  }
}
