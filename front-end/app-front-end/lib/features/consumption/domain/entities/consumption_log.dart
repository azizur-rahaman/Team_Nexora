import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

enum ConsumptionCategory { dairy, fruit, grain }

extension ConsumptionCategoryX on ConsumptionCategory {
  String get label {
    switch (this) {
      case ConsumptionCategory.dairy:
        return 'Dairy';
      case ConsumptionCategory.fruit:
        return 'Fruit';
      case ConsumptionCategory.grain:
        return 'Grain';
    }
  }

  /// Parse from string for API communication
  static ConsumptionCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'dairy':
        return ConsumptionCategory.dairy;
      case 'fruit':
        return ConsumptionCategory.fruit;
      case 'grain':
        return ConsumptionCategory.grain;
      default:
        throw ArgumentError('Invalid category: $value');
    }
  }

  IconData get icon {
    switch (this) {
      case ConsumptionCategory.dairy:
        return Icons.local_drink_outlined;
      case ConsumptionCategory.fruit:
        return Icons.energy_savings_leaf_outlined;
      case ConsumptionCategory.grain:
        return Icons.grass_outlined;
    }
  }

  Color get accentColor {
    switch (this) {
      case ConsumptionCategory.dairy:
        return AppColors.primaryGreenLight;
      case ConsumptionCategory.fruit:
        return AppColors.secondaryOrangeLight;
      case ConsumptionCategory.grain:
        return const Color(0xFFB8D4C5); // muted herb tone
    }
  }
}

class ConsumptionLog extends Equatable {
  const ConsumptionLog({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.date,
    this.notes,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String itemName;
  final double quantity;
  final String unit;
  final ConsumptionCategory category;
  final DateTime date;
  final String? notes;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        itemName,
        quantity,
        unit,
        category,
        date,
        notes,
        userId,
        createdAt,
        updatedAt,
      ];

  /// Get formatted quantity with unit
  String get formattedQuantity => '$quantity $unit';

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if the log is from today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  ConsumptionLog copyWith({
    String? itemName,
    double? quantity,
    String? unit,
    ConsumptionCategory? category,
    DateTime? date,
    String? notes,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConsumptionLog(
      id: id,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ConsumptionLogSamples {
  static List<ConsumptionLog> get logs => [
        ConsumptionLog(
          id: 'log-001',
          itemName: 'Oat Milk',
          quantity: 0.5,
          unit: 'L',
          category: ConsumptionCategory.dairy,
          date: DateTime.now().subtract(const Duration(hours: 3)),
          notes: 'Used in breakfast cereal.',
          userId: 'user-123',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        ConsumptionLog(
          id: 'log-002',
          itemName: 'Blueberries',
          quantity: 150,
          unit: 'g',
          category: ConsumptionCategory.fruit,
          date: DateTime.now().subtract(const Duration(days: 1)),
          notes: 'Smoothie batch for 2 servings.',
          userId: 'user-123',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ConsumptionLog(
          id: 'log-003',
          itemName: 'Wholegrain Pasta',
          quantity: 200,
          unit: 'g',
          category: ConsumptionCategory.grain,
          date: DateTime.now().subtract(const Duration(days: 2)),
          notes: 'Cooked for dinner prep.',
          userId: 'user-123',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

  static ConsumptionLog get featured => logs.first;
}

class ConsumptionCategoryBadge extends StatelessWidget {
  const ConsumptionCategoryBadge({
    super.key,
    required this.category,
  });

  final ConsumptionCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: category.accentColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            category.icon,
            size: 16,
            color: AppColors.primaryGreenDark,
          ),
          const SizedBox(width: 6),
          Text(
            category.label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.primaryGreenDark,
              fontWeight: AppTypography.medium,
            ),
          ),
        ],
      ),
    );
  }
}
