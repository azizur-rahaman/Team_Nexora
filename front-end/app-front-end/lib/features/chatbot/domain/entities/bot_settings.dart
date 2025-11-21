class BotSettings {
  final bool nutritionFocus;
  final DietMode dietMode;
  final bool leftoverIdeas;
  final bool wasteReduction;
  final bool mealPlanSuggestions;
  final bool seasonalRecommendations;
  final bool budgetOptimization;
  final NotificationPreference notifications;

  const BotSettings({
    this.nutritionFocus = true,
    this.dietMode = DietMode.balanced,
    this.leftoverIdeas = true,
    this.wasteReduction = true,
    this.mealPlanSuggestions = true,
    this.seasonalRecommendations = true,
    this.budgetOptimization = false,
    this.notifications = NotificationPreference.important,
  });

  BotSettings copyWith({
    bool? nutritionFocus,
    DietMode? dietMode,
    bool? leftoverIdeas,
    bool? wasteReduction,
    bool? mealPlanSuggestions,
    bool? seasonalRecommendations,
    bool? budgetOptimization,
    NotificationPreference? notifications,
  }) {
    return BotSettings(
      nutritionFocus: nutritionFocus ?? this.nutritionFocus,
      dietMode: dietMode ?? this.dietMode,
      leftoverIdeas: leftoverIdeas ?? this.leftoverIdeas,
      wasteReduction: wasteReduction ?? this.wasteReduction,
      mealPlanSuggestions: mealPlanSuggestions ?? this.mealPlanSuggestions,
      seasonalRecommendations: seasonalRecommendations ?? this.seasonalRecommendations,
      budgetOptimization: budgetOptimization ?? this.budgetOptimization,
      notifications: notifications ?? this.notifications,
    );
  }
}

enum DietMode {
  balanced,
  vegetarian,
  vegan,
  lowCarb,
  highProtein,
  ketogenic;

  String get displayName {
    switch (this) {
      case DietMode.balanced:
        return 'Balanced';
      case DietMode.vegetarian:
        return 'Vegetarian';
      case DietMode.vegan:
        return 'Vegan';
      case DietMode.lowCarb:
        return 'Low Carb';
      case DietMode.highProtein:
        return 'High Protein';
      case DietMode.ketogenic:
        return 'Ketogenic';
    }
  }
}

enum NotificationPreference {
  all,
  important,
  none;

  String get displayName {
    switch (this) {
      case NotificationPreference.all:
        return 'All Messages';
      case NotificationPreference.important:
        return 'Important Only';
      case NotificationPreference.none:
        return 'None';
    }
  }
}
