import 'package:equatable/equatable.dart';
import 'consumption_log.dart';

/// Represents weekly consumption trends for a specific category
class ConsumptionTrend extends Equatable {
  final ConsumptionCategory category;
  final String weekStartDate; // ISO 8601 format
  final String weekEndDate;
  final double totalQuantity;
  final int logCount;
  final double averagePerDay;
  final TrendDirection direction;
  final double percentageChange; // Compared to previous week
  final List<DailyConsumption> dailyBreakdown;

  const ConsumptionTrend({
    required this.category,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.totalQuantity,
    required this.logCount,
    required this.averagePerDay,
    required this.direction,
    required this.percentageChange,
    required this.dailyBreakdown,
  });

  @override
  List<Object?> get props => [
        category,
        weekStartDate,
        weekEndDate,
        totalQuantity,
        logCount,
        averagePerDay,
        direction,
        percentageChange,
        dailyBreakdown,
      ];

  String get trendDescription {
    if (percentageChange.abs() < 5) {
      return 'Stable consumption';
    } else if (direction == TrendDirection.increasing) {
      return 'Increasing by ${percentageChange.toStringAsFixed(1)}%';
    } else {
      return 'Decreasing by ${percentageChange.abs().toStringAsFixed(1)}%';
    }
  }

  bool get isSignificantChange => percentageChange.abs() >= 15;
}

enum TrendDirection { increasing, decreasing, stable }

/// Daily consumption data within a week
class DailyConsumption extends Equatable {
  final String date; // ISO 8601 format
  final double quantity;
  final int logCount;

  const DailyConsumption({
    required this.date,
    required this.quantity,
    required this.logCount,
  });

  @override
  List<Object?> get props => [date, quantity, logCount];
}

/// Over/Under consumption alert
class ConsumptionAlert extends Equatable {
  final String id;
  final ConsumptionCategory category;
  final AlertType type;
  final AlertSeverity severity;
  final String message;
  final double actualQuantity;
  final double baselineQuantity;
  final double deviation; // Percentage deviation from baseline
  final String detectedAt;
  final List<String> recommendations;

  const ConsumptionAlert({
    required this.id,
    required this.category,
    required this.type,
    required this.severity,
    required this.message,
    required this.actualQuantity,
    required this.baselineQuantity,
    required this.deviation,
    required this.detectedAt,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        type,
        severity,
        message,
        actualQuantity,
        baselineQuantity,
        deviation,
        detectedAt,
        recommendations,
      ];
}

enum AlertType { overConsumption, underConsumption, wastePrediction, nutritionImbalance }

enum AlertSeverity { low, medium, high, critical }

extension AlertSeverityX on AlertSeverity {
  String get label {
    switch (this) {
      case AlertSeverity.low:
        return 'Low';
      case AlertSeverity.medium:
        return 'Medium';
      case AlertSeverity.high:
        return 'High';
      case AlertSeverity.critical:
        return 'Critical';
    }
  }
}

/// Waste prediction for specific items
class WastePrediction extends Equatable {
  final String id;
  final String itemName;
  final ConsumptionCategory category;
  final double riskScore; // 0-100
  final int daysUntilLikelyWaste; // 3-7 days
  final String expiryDate;
  final WastePredictionReason primaryReason;
  final List<String> contributingFactors;
  final List<String> preventionTips;
  final double estimatedWasteQuantity;
  final String unit;

  const WastePrediction({
    required this.id,
    required this.itemName,
    required this.category,
    required this.riskScore,
    required this.daysUntilLikelyWaste,
    required this.expiryDate,
    required this.primaryReason,
    required this.contributingFactors,
    required this.preventionTips,
    required this.estimatedWasteQuantity,
    required this.unit,
  });

  @override
  List<Object?> get props => [
        id,
        itemName,
        category,
        riskScore,
        daysUntilLikelyWaste,
        expiryDate,
        primaryReason,
        contributingFactors,
        preventionTips,
        estimatedWasteQuantity,
        unit,
      ];

  WasteRiskLevel get riskLevel {
    if (riskScore >= 80) return WasteRiskLevel.critical;
    if (riskScore >= 60) return WasteRiskLevel.high;
    if (riskScore >= 40) return WasteRiskLevel.medium;
    return WasteRiskLevel.low;
  }

  String get riskDescription {
    switch (riskLevel) {
      case WasteRiskLevel.critical:
        return 'Very likely to be wasted';
      case WasteRiskLevel.high:
        return 'High waste probability';
      case WasteRiskLevel.medium:
        return 'Moderate waste risk';
      case WasteRiskLevel.low:
        return 'Low waste risk';
    }
  }
}

enum WastePredictionReason {
  lowUsageFrequency,
  approachingExpiry,
  historicalPattern,
  excessiveStock,
  seasonalDecline
}

enum WasteRiskLevel { low, medium, high, critical }

/// Nutrition balance analysis
class NutritionBalance extends Equatable {
  final String analysisDate;
  final Map<NutritionCategory, NutritionStatus> categoryStatus;
  final List<NutritionImbalance> imbalances;
  final double overallScore; // 0-100
  final List<String> recommendations;

  const NutritionBalance({
    required this.analysisDate,
    required this.categoryStatus,
    required this.imbalances,
    required this.overallScore,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [
        analysisDate,
        categoryStatus,
        imbalances,
        overallScore,
        recommendations,
      ];

  String get scoreDescription {
    if (overallScore >= 80) return 'Excellent balance';
    if (overallScore >= 60) return 'Good balance';
    if (overallScore >= 40) return 'Needs improvement';
    return 'Poor balance';
  }
}

enum NutritionCategory {
  vegetables,
  fruits,
  grains,
  protein,
  dairy,
  fats,
}

extension NutritionCategoryX on NutritionCategory {
  String get label {
    switch (this) {
      case NutritionCategory.vegetables:
        return 'Vegetables';
      case NutritionCategory.fruits:
        return 'Fruits';
      case NutritionCategory.grains:
        return 'Grains';
      case NutritionCategory.protein:
        return 'Protein';
      case NutritionCategory.dairy:
        return 'Dairy';
      case NutritionCategory.fats:
        return 'Fats';
    }
  }
}

enum NutritionStatus { deficient, low, adequate, high, excessive }

class NutritionImbalance extends Equatable {
  final NutritionCategory category;
  final NutritionStatus status;
  final double currentIntake; // Percentage of recommended
  final String message;
  final List<String> suggestions;

  const NutritionImbalance({
    required this.category,
    required this.status,
    required this.currentIntake,
    required this.message,
    required this.suggestions,
  });

  @override
  List<Object?> get props => [category, status, currentIntake, message, suggestions];
}
