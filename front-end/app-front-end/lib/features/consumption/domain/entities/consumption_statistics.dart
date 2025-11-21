import 'package:equatable/equatable.dart';

/// Consumption Statistics Entity
/// Aggregated consumption data for analytics
class ConsumptionStatistics extends Equatable {
  final String period;
  final int totalLogs;
  final Map<String, CategoryStats> byCategory;
  final List<TopItem> topItems;
  final double averageLogsPerDay;

  const ConsumptionStatistics({
    required this.period,
    required this.totalLogs,
    required this.byCategory,
    required this.topItems,
    required this.averageLogsPerDay,
  });

  @override
  List<Object?> get props => [
        period,
        totalLogs,
        byCategory,
        topItems,
        averageLogsPerDay,
      ];

  /// Get total percentage for all categories (should be 100)
  double get totalPercentage {
    return byCategory.values.fold(0.0, (sum, stats) => sum + stats.percentage);
  }

  /// Get most consumed category
  String? get topCategory {
    if (byCategory.isEmpty) return null;
    
    var maxEntry = byCategory.entries.first;
    for (var entry in byCategory.entries) {
      if (entry.value.count > maxEntry.value.count) {
        maxEntry = entry;
      }
    }
    return maxEntry.key;
  }
}

/// Category Statistics
class CategoryStats extends Equatable {
  final int count;
  final double percentage;

  const CategoryStats({
    required this.count,
    required this.percentage,
  });

  @override
  List<Object?> get props => [count, percentage];
}

/// Top Consumed Item
class TopItem extends Equatable {
  final String itemName;
  final int count;
  final double totalQuantity;
  final String unit;

  const TopItem({
    required this.itemName,
    required this.count,
    required this.totalQuantity,
    required this.unit,
  });

  @override
  List<Object?> get props => [itemName, count, totalQuantity, unit];

  /// Get formatted total quantity
  String get formattedTotal => '$totalQuantity $unit';
}
