import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Inventory Item Categories
enum InventoryCategory {
  dairy,
  fruit,
  vegetable,
  meat,
  grain,
  beverage,
  snack,
  frozen,
  canned,
  other,
}

extension InventoryCategoryX on InventoryCategory {
  String get label {
    switch (this) {
      case InventoryCategory.dairy:
        return 'Dairy';
      case InventoryCategory.fruit:
        return 'Fruit';
      case InventoryCategory.vegetable:
        return 'Vegetable';
      case InventoryCategory.meat:
        return 'Meat';
      case InventoryCategory.grain:
        return 'Grain';
      case InventoryCategory.beverage:
        return 'Beverage';
      case InventoryCategory.snack:
        return 'Snack';
      case InventoryCategory.frozen:
        return 'Frozen';
      case InventoryCategory.canned:
        return 'Canned';
      case InventoryCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case InventoryCategory.dairy:
        return Icons.local_drink_outlined;
      case InventoryCategory.fruit:
        return Icons.apple_outlined;
      case InventoryCategory.vegetable:
        return Icons.eco_outlined;
      case InventoryCategory.meat:
        return Icons.set_meal_outlined;
      case InventoryCategory.grain:
        return Icons.grass_outlined;
      case InventoryCategory.beverage:
        return Icons.coffee_outlined;
      case InventoryCategory.snack:
        return Icons.cookie_outlined;
      case InventoryCategory.frozen:
        return Icons.ac_unit_outlined;
      case InventoryCategory.canned:
        return Icons.lunch_dining_outlined;
      case InventoryCategory.other:
        return Icons.category_outlined;
    }
  }

  Color get accentColor {
    switch (this) {
      case InventoryCategory.dairy:
        return AppColors.primaryGreenLight;
      case InventoryCategory.fruit:
        return AppColors.secondaryOrangeLight;
      case InventoryCategory.vegetable:
        return const Color(0xFF66BB6A); // Success Green
      case InventoryCategory.meat:
        return const Color(0xFFE57373); // Light Red
      case InventoryCategory.grain:
        return const Color(0xFFB8D4C5); // Muted Herb
      case InventoryCategory.beverage:
        return const Color(0xFF64B5F6); // Light Blue
      case InventoryCategory.snack:
        return const Color(0xFFFFD54F); // Amber
      case InventoryCategory.frozen:
        return const Color(0xFF81D4FA); // Light Cyan
      case InventoryCategory.canned:
        return const Color(0xFFFFB74D); // Light Orange
      case InventoryCategory.other:
        return AppColors.neutralGray;
    }
  }
}

/// Expiration Status
enum ExpirationStatus {
  fresh,    // More than 7 days
  warning,  // 3-7 days
  urgent,   // 1-2 days
  expired,  // 0 or negative days
}

extension ExpirationStatusX on ExpirationStatus {
  String get label {
    switch (this) {
      case ExpirationStatus.fresh:
        return 'Fresh';
      case ExpirationStatus.warning:
        return 'Expiring Soon';
      case ExpirationStatus.urgent:
        return 'Use Today';
      case ExpirationStatus.expired:
        return 'Expired';
    }
  }

  Color get color {
    switch (this) {
      case ExpirationStatus.fresh:
        return AppColors.successGreen;
      case ExpirationStatus.warning:
        return AppColors.warningYellow;
      case ExpirationStatus.urgent:
        return AppColors.secondaryOrange;
      case ExpirationStatus.expired:
        return AppColors.errorRed;
    }
  }

  IconData get icon {
    switch (this) {
      case ExpirationStatus.fresh:
        return Icons.check_circle_outline;
      case ExpirationStatus.warning:
        return Icons.warning_amber_outlined;
      case ExpirationStatus.urgent:
        return Icons.notification_important_outlined;
      case ExpirationStatus.expired:
        return Icons.cancel_outlined;
    }
  }
}

/// Inventory Item Entity
class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.purchaseDate,
    required this.expirationDate,
    this.notes,
    this.imageUrl,
    this.barcode,
  });

  final String id;
  final String name;
  final double quantity;
  final String unit; // e.g., "kg", "L", "pcs", "pack"
  final InventoryCategory category;
  final DateTime purchaseDate;
  final DateTime expirationDate;
  final String? notes;
  final String? imageUrl;
  final String? barcode;

  /// Calculate days until expiration
  int get daysUntilExpiration {
    final now = DateTime.now();
    final difference = expirationDate.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }

  /// Get expiration status
  ExpirationStatus get expirationStatus {
    final days = daysUntilExpiration;
    if (days < 0) return ExpirationStatus.expired;
    if (days <= 2) return ExpirationStatus.urgent;
    if (days <= 7) return ExpirationStatus.warning;
    return ExpirationStatus.fresh;
  }

  /// Check if item is expired
  bool get isExpired => daysUntilExpiration < 0;

  /// Check if item is expiring soon (within 7 days)
  bool get isExpiringSoon => daysUntilExpiration >= 0 && daysUntilExpiration <= 7;

  /// Copy with method for immutability
  InventoryItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    InventoryCategory? category,
    DateTime? purchaseDate,
    DateTime? expirationDate,
    String? notes,
    String? imageUrl,
    String? barcode,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expirationDate: expirationDate ?? this.expirationDate,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      barcode: barcode ?? this.barcode,
    );
  }
}

/// Sample Inventory Items for Testing
class InventoryItemSamples {
  static final List<InventoryItem> items = [
    InventoryItem(
      id: 'inv-001',
      name: 'Fresh Milk',
      quantity: 2,
      unit: 'L',
      category: InventoryCategory.dairy,
      purchaseDate: DateTime.now().subtract(const Duration(days: 3)),
      expirationDate: DateTime.now().add(const Duration(days: 2)),
      notes: 'Organic whole milk from local farm',
    ),
    InventoryItem(
      id: 'inv-002',
      name: 'Strawberries',
      quantity: 500,
      unit: 'g',
      category: InventoryCategory.fruit,
      purchaseDate: DateTime.now().subtract(const Duration(days: 1)),
      expirationDate: DateTime.now().add(const Duration(days: 1)),
      notes: 'Fresh organic strawberries',
    ),
    InventoryItem(
      id: 'inv-003',
      name: 'Greek Yogurt',
      quantity: 4,
      unit: 'pcs',
      category: InventoryCategory.dairy,
      purchaseDate: DateTime.now().subtract(const Duration(days: 2)),
      expirationDate: DateTime.now().add(const Duration(days: 3)),
      notes: 'Low-fat Greek yogurt',
    ),
    InventoryItem(
      id: 'inv-004',
      name: 'Chicken Breast',
      quantity: 1.5,
      unit: 'kg',
      category: InventoryCategory.meat,
      purchaseDate: DateTime.now().subtract(const Duration(days: 1)),
      expirationDate: DateTime.now().add(const Duration(days: 2)),
      notes: 'Free-range chicken breast',
    ),
    InventoryItem(
      id: 'inv-005',
      name: 'Lettuce',
      quantity: 1,
      unit: 'head',
      category: InventoryCategory.vegetable,
      purchaseDate: DateTime.now().subtract(const Duration(days: 2)),
      expirationDate: DateTime.now().add(const Duration(days: 1)),
      notes: 'Romaine lettuce',
    ),
    InventoryItem(
      id: 'inv-006',
      name: 'Whole Wheat Bread',
      quantity: 1,
      unit: 'loaf',
      category: InventoryCategory.grain,
      purchaseDate: DateTime.now().subtract(const Duration(days: 1)),
      expirationDate: DateTime.now().add(const Duration(days: 5)),
      notes: '100% whole wheat',
    ),
    InventoryItem(
      id: 'inv-007',
      name: 'Orange Juice',
      quantity: 1,
      unit: 'L',
      category: InventoryCategory.beverage,
      purchaseDate: DateTime.now().subtract(const Duration(days: 5)),
      expirationDate: DateTime.now().add(const Duration(days: 10)),
      notes: 'Fresh squeezed orange juice',
    ),
    InventoryItem(
      id: 'inv-008',
      name: 'Frozen Peas',
      quantity: 500,
      unit: 'g',
      category: InventoryCategory.frozen,
      purchaseDate: DateTime.now().subtract(const Duration(days: 30)),
      expirationDate: DateTime.now().add(const Duration(days: 335)),
      notes: 'Organic frozen peas',
    ),
  ];

  static InventoryItem get featured => items.first;
}

/// Inventory Category Badge Widget
class InventoryCategoryBadge extends StatelessWidget {
  const InventoryCategoryBadge({
    super.key,
    required this.category,
    this.size = BadgeSize.medium,
  });

  final InventoryCategory category;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    final fontSize = size == BadgeSize.small ? 10.0 : 12.0;
    final iconSize = size == BadgeSize.small ? 12.0 : 16.0;
    final padding = size == BadgeSize.small 
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 6);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: category.accentColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: category.accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            category.icon,
            size: iconSize,
            color: category.accentColor,
          ),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: AppTypography.bodySmall.copyWith(
              color: category.accentColor,
              fontWeight: AppTypography.semiBold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

/// Expiration Status Badge Widget
class ExpirationStatusBadge extends StatelessWidget {
  const ExpirationStatusBadge({
    super.key,
    required this.item,
    this.size = BadgeSize.medium,
  });

  final InventoryItem item;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    final status = item.expirationStatus;
    final days = item.daysUntilExpiration;
    final fontSize = size == BadgeSize.small ? 10.0 : 12.0;
    final iconSize = size == BadgeSize.small ? 12.0 : 16.0;
    final padding = size == BadgeSize.small 
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 6);

    String displayText;
    if (days < 0) {
      displayText = 'Expired';
    } else if (days == 0) {
      displayText = 'Today';
    } else if (days == 1) {
      displayText = 'Tomorrow';
    } else {
      displayText = '$days days';
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: status.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: iconSize,
            color: status.color,
          ),
          const SizedBox(width: 4),
          Text(
            displayText,
            style: AppTypography.bodySmall.copyWith(
              color: status.color,
              fontWeight: AppTypography.semiBold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

enum BadgeSize { small, medium }
