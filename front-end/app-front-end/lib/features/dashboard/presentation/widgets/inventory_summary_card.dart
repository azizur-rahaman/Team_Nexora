import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class InventorySummaryCard extends StatelessWidget {
  const InventorySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.neutralWhite,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Inventory Summary',
                  style: AppTypography.h5.copyWith(
                    color: AppColors.neutralWhite,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Statistics Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    label: 'Total Items',
                    value: '48',
                    icon: Icons.food_bank_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.neutralWhite.withOpacity(0.3),
                ),
                Expanded(
                  child: _buildStatItem(
                    label: 'Expiring Soon',
                    value: '7',
                    icon: Icons.warning_amber_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.neutralWhite.withOpacity(0.3),
                ),
                Expanded(
                  child: _buildStatItem(
                    label: 'Saved',
                    value: '156',
                    icon: Icons.eco_outlined,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Eco Impact
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.neutralWhite.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.eco,
                    color: AppColors.neutralWhite,
                    size: AppSpacing.iconSM,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'You\'ve saved 12.5 kg of food this month! 🌱',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.neutralWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.neutralWhite.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.h3.copyWith(
            color: AppColors.neutralWhite,
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.neutralWhite.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
