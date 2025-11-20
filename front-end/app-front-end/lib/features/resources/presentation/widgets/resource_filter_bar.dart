import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/resource.dart';

/// Resource Filter Bar
/// Horizontal scrollable filter chips for categories and types
class ResourceFilterBar extends StatelessWidget {
  final List<ResourceCategory>? selectedCategories;
  final List<ResourceType>? selectedTypes;
  final Function(ResourceCategory) onCategoryTap;
  final Function(ResourceType) onTypeTap;
  final VoidCallback onClearFilters;
  final bool hasActiveFilters;

  const ResourceFilterBar({
    super.key,
    this.selectedCategories,
    this.selectedTypes,
    required this.onCategoryTap,
    required this.onTypeTap,
    required this.onClearFilters,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      color: AppColors.neutralWhite,
      child: Column(
        children: [
          // Categories Row
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                // All Categories Chip
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedGridView,
                          size: 16,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'All',
                          style: TextStyle(
                            color: (selectedCategories == null ||
                                    selectedCategories!.isEmpty)
                                ? AppColors.primaryGreen
                                : AppColors.neutralDarkGray,
                          ),
                        ),
                      ],
                    ),
                    selected: selectedCategories == null ||
                        selectedCategories!.isEmpty,
                    onSelected: (_) {
                      onClearFilters();
                    },
                    selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                    checkmarkColor: AppColors.primaryGreen,
                  ),
                ),

                // Category Chips
                ...ResourceCategory.values.map((category) {
                  final isSelected = selectedCategories?.contains(category) ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: FilterChip(
                      avatar: HugeIcon(
                        icon: category.icon,
                        size: 16,
                        color: isSelected
                            ? category.color
                            : AppColors.neutralDarkGray,
                      ),
                      label: Text(category.label),
                      selected: isSelected,
                      onSelected: (_) => onCategoryTap(category),
                      selectedColor: category.color.withOpacity(0.2),
                      checkmarkColor: category.color,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? category.color
                            : AppColors.neutralDarkGray,
                        fontWeight: isSelected
                            ? AppTypography.semiBold
                            : AppTypography.regular,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Type Filters (if any selected)
          if (hasActiveFilters) ...[
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  // Type Chips
                  ...ResourceType.values.map((type) {
                    final isSelected = selectedTypes?.contains(type) ?? false;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: ChoiceChip(
                        avatar: HugeIcon(
                          icon: type.icon,
                          size: 14,
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.neutralGray,
                        ),
                        label: Text(type.label),
                        selected: isSelected,
                        onSelected: (_) => onTypeTap(type),
                        selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.neutralDarkGray,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),

                  // Clear All Button
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: TextButton.icon(
                      onPressed: onClearFilters,
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedDelete02,
                        size: 14,
                        color: AppColors.errorRed,
                      ),
                      label: Text(
                        'Clear All',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.errorRed,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
