import '../../domain/entities/consumption_log.dart';
import '../../domain/entities/consumption_trend.dart';

/// AI-powered consumption pattern analyzer service
/// Uses temporary data and algorithms for frontend-only operation
class ConsumptionAnalyzerService {
  /// Analyze weekly consumption trends
  List<ConsumptionTrend> analyzeWeeklyTrends(List<ConsumptionLog> logs) {
    if (logs.isEmpty) return [];

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    // Group logs by category
    final categoryGroups = <ConsumptionCategory, List<ConsumptionLog>>{};
    for (final log in logs) {
      if (log.date.isAfter(weekStart) && log.date.isBefore(weekEnd.add(const Duration(days: 1)))) {
        categoryGroups.putIfAbsent(log.category, () => []).add(log);
      }
    }

    // Calculate trends for each category
    final trends = <ConsumptionTrend>[];
    for (final entry in categoryGroups.entries) {
      final categoryLogs = entry.value;
      final totalQuantity = categoryLogs.fold<double>(0, (sum, log) => sum + log.quantity);
      final averagePerDay = totalQuantity / 7;

      // Calculate daily breakdown
      final dailyBreakdown = <DailyConsumption>[];
      for (var i = 0; i < 7; i++) {
        final date = weekStart.add(Duration(days: i));
        final dayLogs = categoryLogs.where((log) =>
            log.date.year == date.year &&
            log.date.month == date.month &&
            log.date.day == date.day);
        final dayQuantity = dayLogs.fold<double>(0, (sum, log) => sum + log.quantity);
        dailyBreakdown.add(DailyConsumption(
          date: date.toIso8601String().split('T')[0],
          quantity: dayQuantity,
          logCount: dayLogs.length,
        ));
      }

      // Calculate trend direction (compare with previous week simulation)
      final previousWeekAvg = averagePerDay * (0.85 + (entry.key.index * 0.1)); // Simulated
      final percentageChange = ((averagePerDay - previousWeekAvg) / previousWeekAvg) * 100;
      
      TrendDirection direction;
      if (percentageChange > 5) {
        direction = TrendDirection.increasing;
      } else if (percentageChange < -5) {
        direction = TrendDirection.decreasing;
      } else {
        direction = TrendDirection.stable;
      }

      trends.add(ConsumptionTrend(
        category: entry.key,
        weekStartDate: weekStart.toIso8601String().split('T')[0],
        weekEndDate: weekEnd.toIso8601String().split('T')[0],
        totalQuantity: totalQuantity,
        logCount: categoryLogs.length,
        averagePerDay: averagePerDay,
        direction: direction,
        percentageChange: percentageChange,
        dailyBreakdown: dailyBreakdown,
      ));
    }

    return trends;
  }

  /// Detect over and under consumption
  List<ConsumptionAlert> detectConsumptionAlerts(List<ConsumptionLog> logs) {
    final alerts = <ConsumptionAlert>[];
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    // Define baseline thresholds (in arbitrary units per week)
    final baselines = {
      ConsumptionCategory.dairy: 2000.0, // grams/week
      ConsumptionCategory.fruit: 1500.0,
      ConsumptionCategory.grain: 2500.0,
    };

    // Group logs by category for current week
    final categoryGroups = <ConsumptionCategory, List<ConsumptionLog>>{};
    for (final log in logs) {
      if (log.date.isAfter(weekStart)) {
        categoryGroups.putIfAbsent(log.category, () => []).add(log);
      }
    }

    // Check each category against baseline
    for (final entry in baselines.entries) {
      final category = entry.key;
      final baseline = entry.value;
      final categoryLogs = categoryGroups[category] ?? [];
      final actualQuantity = categoryLogs.fold<double>(0, (sum, log) => sum + log.quantity);
      final deviation = ((actualQuantity - baseline) / baseline) * 100;

      if (deviation.abs() >= 20) {
        final isOver = deviation > 0;
        alerts.add(ConsumptionAlert(
          id: 'alert-${category.name}-${now.millisecondsSinceEpoch}',
          category: category,
          type: isOver ? AlertType.overConsumption : AlertType.underConsumption,
          severity: deviation.abs() >= 50
              ? AlertSeverity.high
              : deviation.abs() >= 35
                  ? AlertSeverity.medium
                  : AlertSeverity.low,
          message: isOver
              ? '${category.label} consumption is ${deviation.toStringAsFixed(1)}% above normal'
              : '${category.label} consumption is ${deviation.abs().toStringAsFixed(1)}% below normal',
          actualQuantity: actualQuantity,
          baselineQuantity: baseline,
          deviation: deviation,
          detectedAt: now.toIso8601String(),
          recommendations: isOver
              ? [
                  'Consider reducing ${category.label.toLowerCase()} portions',
                  'Plan meals to use existing stock first',
                  'Check for expiring items',
                ]
              : [
                  'Increase ${category.label.toLowerCase()} in your diet',
                  'Add ${category.label.toLowerCase()} to shopping list',
                  'Try new ${category.label.toLowerCase()} recipes',
                ],
        ));
      }
    }

    return alerts;
  }

  /// Predict waste likely in 3-7 days
  List<WastePrediction> predictWaste(List<ConsumptionLog> logs) {
    final predictions = <WastePrediction>[];
    final now = DateTime.now();

    // Simulate inventory items with usage patterns
    final inventoryItems = _getSimulatedInventory();

    for (final item in inventoryItems) {
      // Calculate usage frequency from logs
      final itemLogs = logs.where((log) =>
          log.itemName.toLowerCase().contains(item['name'].toString().toLowerCase()));
      
      final daysSinceLastUse = itemLogs.isEmpty
          ? 14
          : now.difference(itemLogs.first.date).inDays;
      
      final usageFrequency = itemLogs.length / 30.0; // Uses per month
      final expiryDate = DateTime.parse(item['expiryDate'] as String);
      final daysUntilExpiry = expiryDate.difference(now).inDays;

      // Calculate risk score (0-100)
      double riskScore = 0;
      WastePredictionReason primaryReason;
      final factors = <String>[];

      // Factor 1: Usage frequency (40% weight)
      if (usageFrequency < 1) {
        riskScore += 40;
        factors.add('Low usage frequency (${usageFrequency.toStringAsFixed(1)} times/month)');
      } else if (usageFrequency < 3) {
        riskScore += 20;
        factors.add('Moderate usage');
      }

      // Factor 2: Expiry proximity (40% weight)
      if (daysUntilExpiry <= 3) {
        riskScore += 40;
        factors.add('Expires in ${daysUntilExpiry} days');
      } else if (daysUntilExpiry <= 7) {
        riskScore += 25;
        factors.add('Approaching expiry');
      }

      // Factor 3: Days since last use (20% weight)
      if (daysSinceLastUse > 7) {
        riskScore += 20;
        factors.add('Not used in ${daysSinceLastUse} days');
      } else if (daysSinceLastUse > 3) {
        riskScore += 10;
      }

      // Determine primary reason
      if (daysUntilExpiry <= 3 && usageFrequency < 1) {
        primaryReason = WastePredictionReason.approachingExpiry;
      } else if (usageFrequency < 1) {
        primaryReason = WastePredictionReason.lowUsageFrequency;
      } else if (daysSinceLastUse > 7) {
        primaryReason = WastePredictionReason.historicalPattern;
      } else {
        primaryReason = WastePredictionReason.excessiveStock;
      }

      // Only add if risk is significant
      if (riskScore >= 30 && daysUntilExpiry >= 3 && daysUntilExpiry <= 7) {
        predictions.add(WastePrediction(
          id: 'waste-${item['id']}',
          itemName: item['name'] as String,
          category: item['category'] as ConsumptionCategory,
          riskScore: riskScore,
          daysUntilLikelyWaste: daysUntilExpiry,
          expiryDate: expiryDate.toIso8601String().split('T')[0],
          primaryReason: primaryReason,
          contributingFactors: factors,
          preventionTips: _getPreventionTips(item['category'] as ConsumptionCategory, primaryReason),
          estimatedWasteQuantity: item['quantity'] as double,
          unit: item['unit'] as String,
        ));
      }
    }

    // Sort by risk score descending
    predictions.sort((a, b) => b.riskScore.compareTo(a.riskScore));
    return predictions;
  }

  /// Detect nutrition imbalances
  NutritionBalance analyzeNutritionBalance(List<ConsumptionLog> logs) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 7));

    // Filter logs for last 7 days
    final recentLogs = logs.where((log) => log.date.isAfter(weekStart)).toList();

    // Map consumption categories to nutrition categories
    final nutritionIntake = <NutritionCategory, double>{
      NutritionCategory.vegetables: 0,
      NutritionCategory.fruits: 0,
      NutritionCategory.grains: 0,
      NutritionCategory.protein: 0,
      NutritionCategory.dairy: 0,
      NutritionCategory.fats: 0,
    };

    // Calculate intake (simplified mapping)
    for (final log in recentLogs) {
      switch (log.category) {
        case ConsumptionCategory.fruit:
          nutritionIntake[NutritionCategory.fruits] = 
              (nutritionIntake[NutritionCategory.fruits] ?? 0) + log.quantity;
          break;
        case ConsumptionCategory.grain:
          nutritionIntake[NutritionCategory.grains] = 
              (nutritionIntake[NutritionCategory.grains] ?? 0) + log.quantity;
          break;
        case ConsumptionCategory.dairy:
          nutritionIntake[NutritionCategory.dairy] = 
              (nutritionIntake[NutritionCategory.dairy] ?? 0) + log.quantity;
          break;
      }
    }

    // Define recommended weekly intake (in grams)
    final recommendations = {
      NutritionCategory.vegetables: 2500.0,
      NutritionCategory.fruits: 1500.0,
      NutritionCategory.grains: 2000.0,
      NutritionCategory.protein: 1000.0,
      NutritionCategory.dairy: 1800.0,
      NutritionCategory.fats: 400.0,
    };

    // Calculate status for each category
    final categoryStatus = <NutritionCategory, NutritionStatus>{};
    final imbalances = <NutritionImbalance>[];
    double totalScore = 0;

    for (final entry in recommendations.entries) {
      final category = entry.key;
      final recommended = entry.value;
      final actual = nutritionIntake[category] ?? 0;
      final percentage = (actual / recommended) * 100;

      NutritionStatus status;
      double categoryScore;

      if (percentage < 30) {
        status = NutritionStatus.deficient;
        categoryScore = 20;
      } else if (percentage < 60) {
        status = NutritionStatus.low;
        categoryScore = 50;
      } else if (percentage >= 60 && percentage <= 130) {
        status = NutritionStatus.adequate;
        categoryScore = 100;
      } else if (percentage <= 180) {
        status = NutritionStatus.high;
        categoryScore = 70;
      } else {
        status = NutritionStatus.excessive;
        categoryScore = 40;
      }

      categoryStatus[category] = status;
      totalScore += categoryScore;

      // Add imbalance if not adequate
      if (status != NutritionStatus.adequate) {
        imbalances.add(NutritionImbalance(
          category: category,
          status: status,
          currentIntake: percentage,
          message: _getImbalanceMessage(category, status, percentage),
          suggestions: _getNutritionSuggestions(category, status),
        ));
      }
    }

    final overallScore = totalScore / recommendations.length;

    return NutritionBalance(
      analysisDate: now.toIso8601String().split('T')[0],
      categoryStatus: categoryStatus,
      imbalances: imbalances,
      overallScore: overallScore,
      recommendations: _getOverallRecommendations(imbalances),
    );
  }

  // Helper methods

  List<Map<String, dynamic>> _getSimulatedInventory() {
    final now = DateTime.now();
    return [
      {
        'id': 'inv-001',
        'name': 'Strawberries',
        'category': ConsumptionCategory.fruit,
        'quantity': 250.0,
        'unit': 'g',
        'expiryDate': now.add(const Duration(days: 4)).toIso8601String(),
      },
      {
        'id': 'inv-002',
        'name': 'Oat Milk',
        'category': ConsumptionCategory.dairy,
        'quantity': 500.0,
        'unit': 'ml',
        'expiryDate': now.add(const Duration(days: 6)).toIso8601String(),
      },
      {
        'id': 'inv-003',
        'name': 'Quinoa',
        'category': ConsumptionCategory.grain,
        'quantity': 300.0,
        'unit': 'g',
        'expiryDate': now.add(const Duration(days: 5)).toIso8601String(),
      },
      {
        'id': 'inv-004',
        'name': 'Blueberries',
        'category': ConsumptionCategory.fruit,
        'quantity': 150.0,
        'unit': 'g',
        'expiryDate': now.add(const Duration(days: 3)).toIso8601String(),
      },
    ];
  }

  List<String> _getPreventionTips(ConsumptionCategory category, WastePredictionReason reason) {
    final tips = <String>[];

    switch (reason) {
      case WastePredictionReason.approachingExpiry:
        tips.add('Use this item in the next 1-2 days');
        tips.add('Consider freezing if possible');
        tips.add('Share with neighbors if you can\'t use it');
        break;
      case WastePredictionReason.lowUsageFrequency:
        tips.add('Plan meals featuring this item');
        tips.add('Look up quick recipes');
        tips.add('Reduce purchase quantity next time');
        break;
      case WastePredictionReason.historicalPattern:
        tips.add('Set reminders to use this item');
        tips.add('Move to front of fridge/pantry');
        tips.add('Meal prep with this ingredient');
        break;
      case WastePredictionReason.excessiveStock:
        tips.add('Donate excess to food banks');
        tips.add('Share with community');
        tips.add('Adjust shopping habits');
        break;
      case WastePredictionReason.seasonalDecline:
        tips.add('Stock up before season ends');
        tips.add('Preserve or freeze');
        break;
    }

    return tips;
  }

  String _getImbalanceMessage(NutritionCategory category, NutritionStatus status, double percentage) {
    switch (status) {
      case NutritionStatus.deficient:
        return '${category.label} critically low at ${percentage.toStringAsFixed(0)}% of recommended intake';
      case NutritionStatus.low:
        return '${category.label} below recommended at ${percentage.toStringAsFixed(0)}%';
      case NutritionStatus.high:
        return '${category.label} slightly above recommended at ${percentage.toStringAsFixed(0)}%';
      case NutritionStatus.excessive:
        return '${category.label} significantly above recommended at ${percentage.toStringAsFixed(0)}%';
      case NutritionStatus.adequate:
        return '${category.label} at optimal levels';
    }
  }

  List<String> _getNutritionSuggestions(NutritionCategory category, NutritionStatus status) {
    if (status == NutritionStatus.deficient || status == NutritionStatus.low) {
      switch (category) {
        case NutritionCategory.vegetables:
          return ['Add salads to meals', 'Include vegetables in every dish', 'Try veggie smoothies'];
        case NutritionCategory.fruits:
          return ['Have fruit with breakfast', 'Fruit snacks between meals', 'Add to desserts'];
        case NutritionCategory.grains:
          return ['Include whole grains', 'Try quinoa and brown rice', 'Whole grain bread'];
        case NutritionCategory.protein:
          return ['Add protein to each meal', 'Try plant-based proteins', 'Nuts and legumes'];
        case NutritionCategory.dairy:
          return ['Dairy with breakfast', 'Yogurt snacks', 'Milk alternatives'];
        case NutritionCategory.fats:
          return ['Healthy fats like avocado', 'Nuts and seeds', 'Olive oil in cooking'];
      }
    } else {
      return [
        'Reduce portion sizes',
        'Balance with other food groups',
        'Consider variety in diet',
      ];
    }
  }

  List<String> _getOverallRecommendations(List<NutritionImbalance> imbalances) {
    if (imbalances.isEmpty) {
      return ['Great job maintaining nutritional balance!', 'Continue your current eating patterns'];
    }

    final recommendations = <String>['Focus on balanced meals'];
    
    final deficientCategories = imbalances
        .where((i) => i.status == NutritionStatus.deficient || i.status == NutritionStatus.low)
        .map((i) => i.category.label.toLowerCase())
        .toList();

    if (deficientCategories.isNotEmpty) {
      recommendations.add('Increase: ${deficientCategories.join(', ')}');
    }

    recommendations.add('Meal plan to address imbalances');
    recommendations.add('Track progress weekly');

    return recommendations;
  }
}
