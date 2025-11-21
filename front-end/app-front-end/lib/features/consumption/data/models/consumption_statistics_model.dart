import '../../domain/entities/consumption_statistics.dart';

/// Consumption Statistics Model
/// Data transfer object for statistics API response
class ConsumptionStatisticsModel extends ConsumptionStatistics {
  const ConsumptionStatisticsModel({
    required super.period,
    required super.totalLogs,
    required super.byCategory,
    required super.topItems,
    required super.averageLogsPerDay,
  });

  /// Create model from JSON
  factory ConsumptionStatisticsModel.fromJson(Map<String, dynamic> json) {
    // Parse category stats
    final Map<String, CategoryStats> categoryStats = {};
    final byCategoryJson = json['byCategory'] as Map<String, dynamic>;
    
    byCategoryJson.forEach((key, value) {
      categoryStats[key] = CategoryStatsModel.fromJson(value);
    });

    // Parse top items
    final topItemsList = (json['topItems'] as List)
        .map((item) => TopItemModel.fromJson(item))
        .toList();

    return ConsumptionStatisticsModel(
      period: json['period'] as String,
      totalLogs: json['totalLogs'] as int,
      byCategory: categoryStats,
      topItems: topItemsList,
      averageLogsPerDay: (json['averageLogsPerDay'] as num).toDouble(),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> categoryJson = {};
    byCategory.forEach((key, value) {
      categoryJson[key] = (value as CategoryStatsModel).toJson();
    });

    return {
      'period': period,
      'totalLogs': totalLogs,
      'byCategory': categoryJson,
      'topItems': topItems.map((item) => (item as TopItemModel).toJson()).toList(),
      'averageLogsPerDay': averageLogsPerDay,
    };
  }
}

/// Category Statistics Model
class CategoryStatsModel extends CategoryStats {
  const CategoryStatsModel({
    required super.count,
    required super.percentage,
  });

  factory CategoryStatsModel.fromJson(Map<String, dynamic> json) {
    return CategoryStatsModel(
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'percentage': percentage,
    };
  }
}

/// Top Item Model
class TopItemModel extends TopItem {
  const TopItemModel({
    required super.itemName,
    required super.count,
    required super.totalQuantity,
    required super.unit,
  });

  factory TopItemModel.fromJson(Map<String, dynamic> json) {
    return TopItemModel(
      itemName: json['itemName'] as String,
      count: json['count'] as int,
      totalQuantity: (json['totalQuantity'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'count': count,
      'totalQuantity': totalQuantity,
      'unit': unit,
    };
  }
}
