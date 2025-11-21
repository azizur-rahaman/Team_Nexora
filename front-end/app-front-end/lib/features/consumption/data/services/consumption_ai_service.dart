import 'dart:math';
import '../../domain/entities/consumption_log.dart';
import '../../domain/entities/consumption_trend.dart';

/// AI-powered consumption analysis service
/// Provides trend detection, waste prediction, and nutrition analysis
class ConsumptionAIService {
  final Random _random = Random();

  /// Analyze weekly consumption trends
  List<ConsumptionTrend> analyzeWeeklyTrends(List<ConsumptionLog> logs) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    // Group logs by category
    final categoryLogs = <ConsumptionCategory, List<ConsumptionLog>>{};
    for (final log in logs) {
      if (log.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          log.date.isBefore(weekEnd.add(const Duration(days: 1)))) {
        categoryLogs.putIfAbsent(log.category, () => []).add(log);
      }
    }

    // Generate trends for each category
    return categoryLogs.entries.map((entry) {
      final categoryLogs = entry.value;
      final totalQuantity = categoryLogs.fold<double>(
        0,
        (sum, log) => sum + log.quantity,
      );
      
      final dailyBreakdown = _generateDailyBreakdown(weekStart, categoryLogs);
      final avgPerDay = totalQuantity / 7;
      final previousWeekAvg = avgPerDay * (0.8 + _random.nextDouble() * 0.4);
      final percentageChange = ((avgPerDay - previousWeekAvg) / previousWeekAvg) * 100;

      return ConsumptionTrend(
        category: entry.key,
        weekStartDate: weekStart.toIso8601String(),
        weekEndDate: weekEnd.toIso8601String(),
        totalQuantity: totalQuantity,
        logCount: categoryLogs.length,
        averagePerDay: avgPerDay,
        direction: _getTrendDirection(percentageChange),
        percentageChange: percentageChange,
        dailyBreakdown: dailyBreakdown,
      );
    }).toList();
  }

  /// Detect over/under consumption
  List<ConsumptionAlert> detectConsumptionAlerts(List<ConsumptionLog> logs) {
    final alerts = <ConsumptionAlert>[];
    
    // Group by category and calculate baseline
    final categoryConsumption = <ConsumptionCategory, double>{};
    for (final log in logs) {
      categoryConsumption[log.category] = 
          (categoryConsumption[log.category] ?? 0) + log.quantity;
    }

    // Define baselines (these would come from user preferences or AI learning)
    final baselines = {
      ConsumptionCategory.dairy: 2000.0, // ml per week
      ConsumptionCategory.fruit: 1500.0, // g per week
      ConsumptionCategory.grain: 2000.0, // g per week
    };

    for (final entry in categoryConsumption.entries) {
      final baseline = baselines[entry.key] ?? 1000.0;
      final actual = entry.value;
      final deviation = ((actual - baseline) / baseline) * 100;

      if (deviation.abs() > 20) {
        final isOver = deviation > 0;
        alerts.add(ConsumptionAlert(
          id: 'alert_${entry.key}_${DateTime.now().millisecondsSinceEpoch}',
          category: entry.key,
          type: isOver ? AlertType.overConsumption : AlertType.underConsumption,
          severity: _getAlertSeverity(deviation.abs()),
          message: isOver
              ? '${entry.key.label} consumption is higher than usual'
              : '${entry.key.label} consumption is lower than usual',
          actualQuantity: actual,
          baselineQuantity: baseline,
          deviation: deviation,
          detectedAt: DateTime.now().toIso8601String(),
          recommendations: _getConsumptionRecommendations(entry.key, isOver),
        ));
      }
    }

    return alerts;
  }

  /// Predict waste in next 3-7 days
  List<WastePrediction> predictWaste(List<ConsumptionLog> logs) {
    final predictions = <WastePrediction>[];
    
    // Simulate waste predictions based on consumption patterns
    final itemsAtRisk = [
      {'name': 'Oat Milk', 'category': ConsumptionCategory.dairy, 'quantity': 500.0, 'unit': 'ml'},
      {'name': 'Strawberries', 'category': ConsumptionCategory.fruit, 'quantity': 200.0, 'unit': 'g'},
      {'name': 'Brown Rice', 'category': ConsumptionCategory.grain, 'quantity': 300.0, 'unit': 'g'},
    ];

    for (int i = 0; i < itemsAtRisk.length; i++) {
      final item = itemsAtRisk[i];
      final riskScore = 85.0 - (i * 15); // Decreasing risk
      final daysUntil = 3 + i;

      predictions.add(WastePrediction(
        id: 'waste_${i}_${DateTime.now().millisecondsSinceEpoch}',
        itemName: item['name'] as String,
        category: item['category'] as ConsumptionCategory,
        riskScore: riskScore,
        daysUntilLikelyWaste: daysUntil,
        expiryDate: DateTime.now().add(Duration(days: daysUntil)).toIso8601String(),
        primaryReason: _getWasteReason(riskScore),
        contributingFactors: [
          'Usage frequency below average',
          'Similar items wasted in past',
          'Approaching expiration date',
        ],
        preventionTips: [
          'Use in smoothie or breakfast bowl',
          'Share with neighbors or family',
          'Freeze for later use',
        ],
        estimatedWasteQuantity: item['quantity'] as double,
        unit: item['unit'] as String,
      ));
    }

    return predictions;
  }

  /// Detect nutrition imbalances
  NutritionBalance analyzeNutritionBalance(List<ConsumptionLog> logs) {
    final categoryIntake = <NutritionCategory, double>{};
    
    // Map consumption categories to nutrition categories
    for (final log in logs) {
      switch (log.category) {
        case ConsumptionCategory.dairy:
          categoryIntake[NutritionCategory.dairy] = 
              (categoryIntake[NutritionCategory.dairy] ?? 0) + log.quantity;
          break;
        case ConsumptionCategory.fruit:
          categoryIntake[NutritionCategory.fruits] = 
              (categoryIntake[NutritionCategory.fruits] ?? 0) + log.quantity;
          break;
        case ConsumptionCategory.grain:
          categoryIntake[NutritionCategory.grains] = 
              (categoryIntake[NutritionCategory.grains] ?? 0) + log.quantity;
          break;
      }
    }

    // Add missing categories with defaults
    categoryIntake.putIfAbsent(NutritionCategory.vegetables, () => 500.0);
    categoryIntake.putIfAbsent(NutritionCategory.protein, () => 400.0);
    categoryIntake.putIfAbsent(NutritionCategory.fats, () => 200.0);

    // Define recommended intake (arbitrary values for demo)
    final recommended = {
      NutritionCategory.vegetables: 1500.0,
      NutritionCategory.fruits: 1000.0,
      NutritionCategory.grains: 1200.0,
      NutritionCategory.protein: 800.0,
      NutritionCategory.dairy: 1000.0,
      NutritionCategory.fats: 300.0,
    };

    // Calculate status for each category
    final categoryStatus = <NutritionCategory, NutritionStatus>{};
    final imbalances = <NutritionImbalance>[];

    for (final category in NutritionCategory.values) {
      final actual = categoryIntake[category] ?? 0;
      final rec = recommended[category] ?? 1000.0;
      final percentage = (actual / rec) * 100;

      final status = _getNutritionStatus(percentage);
      categoryStatus[category] = status;

      if (status != NutritionStatus.adequate) {
        imbalances.add(NutritionImbalance(
          category: category,
          status: status,
          currentIntake: percentage,
          message: _getNutritionMessage(category, status),
          suggestions: _getNutritionSuggestions(category, status),
        ));
      }
    }

    final overallScore = _calculateNutritionScore(categoryStatus);

    return NutritionBalance(
      analysisDate: DateTime.now().toIso8601String(),
      categoryStatus: categoryStatus,
      imbalances: imbalances,
      overallScore: overallScore,
      recommendations: _getOverallRecommendations(imbalances),
    );
  }

  // Helper methods
  List<DailyConsumption> _generateDailyBreakdown(
    DateTime weekStart,
    List<ConsumptionLog> logs,
  ) {
    final daily = <DailyConsumption>[];
    
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dayLogs = logs.where((log) {
        return log.date.year == date.year &&
               log.date.month == date.month &&
               log.date.day == date.day;
      }).toList();

      final totalQuantity = dayLogs.fold<double>(
        0,
        (sum, log) => sum + log.quantity,
      );

      daily.add(DailyConsumption(
        date: date.toIso8601String(),
        quantity: totalQuantity,
        logCount: dayLogs.length,
      ));
    }

    return daily;
  }

  TrendDirection _getTrendDirection(double percentageChange) {
    if (percentageChange.abs() < 5) return TrendDirection.stable;
    return percentageChange > 0 ? TrendDirection.increasing : TrendDirection.decreasing;
  }

  AlertSeverity _getAlertSeverity(double deviation) {
    if (deviation >= 50) return AlertSeverity.critical;
    if (deviation >= 35) return AlertSeverity.high;
    if (deviation >= 20) return AlertSeverity.medium;
    return AlertSeverity.low;
  }

  List<String> _getConsumptionRecommendations(ConsumptionCategory category, bool isOver) {
    if (isOver) {
      return [
        'Consider reducing ${category.label.toLowerCase()} intake',
        'Share surplus with friends or food banks',
        'Freeze items for later use',
      ];
    } else {
      return [
        'Increase ${category.label.toLowerCase()} in your diet',
        'Try new recipes featuring ${category.label.toLowerCase()}',
        'Stock up on ${category.label.toLowerCase()} items',
      ];
    }
  }

  WastePredictionReason _getWasteReason(double riskScore) {
    if (riskScore >= 80) return WastePredictionReason.approachingExpiry;
    if (riskScore >= 60) return WastePredictionReason.lowUsageFrequency;
    return WastePredictionReason.historicalPattern;
  }

  NutritionStatus _getNutritionStatus(double percentage) {
    if (percentage < 40) return NutritionStatus.deficient;
    if (percentage < 70) return NutritionStatus.low;
    if (percentage <= 130) return NutritionStatus.adequate;
    if (percentage <= 150) return NutritionStatus.high;
    return NutritionStatus.excessive;
  }

  String _getNutritionMessage(NutritionCategory category, NutritionStatus status) {
    switch (status) {
      case NutritionStatus.deficient:
      case NutritionStatus.low:
        return 'Low ${category.label} intake detected';
      case NutritionStatus.high:
      case NutritionStatus.excessive:
        return 'High ${category.label} consumption detected';
      case NutritionStatus.adequate:
        return '${category.label} intake is balanced';
    }
  }

  List<String> _getNutritionSuggestions(NutritionCategory category, NutritionStatus status) {
    if (status == NutritionStatus.low || status == NutritionStatus.deficient) {
      return [
        'Add more ${category.label.toLowerCase()} to your meals',
        'Try ${category.label.toLowerCase()}-rich recipes',
      ];
    }
    return [
      'Consider reducing ${category.label.toLowerCase()}',
      'Balance with other food groups',
    ];
  }

  double _calculateNutritionScore(Map<NutritionCategory, NutritionStatus> status) {
    int totalPoints = 0;
    for (final s in status.values) {
      switch (s) {
        case NutritionStatus.adequate:
          totalPoints += 100;
          break;
        case NutritionStatus.low:
        case NutritionStatus.high:
          totalPoints += 70;
          break;
        case NutritionStatus.deficient:
        case NutritionStatus.excessive:
          totalPoints += 40;
          break;
      }
    }
    return totalPoints / status.length;
  }

  List<String> _getOverallRecommendations(List<NutritionImbalance> imbalances) {
    if (imbalances.isEmpty) {
      return ['Great job! Your nutrition is well balanced.'];
    }
    return [
      'Focus on balancing ${imbalances.first.category.label.toLowerCase()}',
      'Try meal planning to improve variety',
      'Consider consulting a nutritionist for personalized advice',
    ];
  }
}
