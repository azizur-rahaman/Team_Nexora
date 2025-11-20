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

class ConsumptionLog {
  const ConsumptionLog({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.date,
    this.notes,
  });

  final String id;
  final String itemName;
  final double quantity;
  final String unit;
  final ConsumptionCategory category;
  final DateTime date;
  final String? notes;

  ConsumptionLog copyWith({
    String? itemName,
    double? quantity,
    String? unit,
    ConsumptionCategory? category,
    DateTime? date,
    String? notes,
  }) {
    return ConsumptionLog(
      id: id,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
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
        ),
        ConsumptionLog(
          id: 'log-002',
          itemName: 'Blueberries',
          quantity: 150,
          unit: 'g',
          category: ConsumptionCategory.fruit,
          date: DateTime.now().subtract(const Duration(days: 1)),
          notes: 'Smoothie batch for 2 servings.',
        ),
        ConsumptionLog(
          id: 'log-003',
          itemName: 'Wholegrain Pasta',
          quantity: 200,
          unit: 'g',
          category: ConsumptionCategory.grain,
          date: DateTime.now().subtract(const Duration(days: 2)),
          notes: 'Cooked for dinner prep.',
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
