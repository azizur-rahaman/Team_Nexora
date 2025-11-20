import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/inventory_item.dart';

/// Inventory Filter Bar Widget
/// Shows active filters and quick category/status filters
class InventoryFilterBar extends StatelessWidget {
  const InventoryFilterBar({
    super.key,
    this.selectedCategories,
    this.selectedStatus,
    this.onCategoryTap,
    this.onStatusTap,
    this.onClearFilters,
  });

  final List<InventoryCategory>? selectedCategories;
  final ExpirationStatus? selectedStatus;
  final Function(InventoryCategory)? onCategoryTap;
  final Function(ExpirationStatus)? onStatusTap;
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    final hasFilters = (selectedCategories != null && selectedCategories!.isNotEmpty) ||
        selectedStatus != null;

    if (!hasFilters) {
      return const SizedBox.shrink();
    }

    return Container(
      color: AppColors.neutralWhite,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Filters',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onClearFilters,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedDelete02,
                      size: 14,
                      color: AppColors.errorRed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Clear All',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.errorRed,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              // Status Filter Chip
              if (selectedStatus != null)
                Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selectedStatus!.icon,
                        size: 14,
                        color: selectedStatus!.color,
                      ),
                      const SizedBox(width: 4),
                      Text(selectedStatus!.label),
                    ],
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => onStatusTap?.call(selectedStatus!),
                  backgroundColor: selectedStatus!.color.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: selectedStatus!.color,
                    fontSize: 12,
                  ),
                ),

              // Category Filter Chips
              if (selectedCategories != null)
                ...selectedCategories!.map((category) {
                  return Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category.icon,
                          size: 14,
                          color: category.accentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(category.label),
                      ],
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => onCategoryTap?.call(category),
                    backgroundColor: category.accentColor.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: category.accentColor,
                      fontSize: 12,
                    ),
                  );
                }),
            ],
          ),
        ],
      ),
    );
  }
}
