import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Category Filter Chip
/// A filter chip for selecting consumption categories
class CategoryFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;

  const CategoryFilterChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primaryGreen;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? color
              : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
          border: Border.all(
            color: isSelected 
                ? color
                : color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSpacing.iconSM,
              color: isSelected 
                  ? AppColors.neutralWhite
                  : color,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected 
                    ? AppColors.neutralWhite
                    : color,
                fontWeight: AppTypography.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
