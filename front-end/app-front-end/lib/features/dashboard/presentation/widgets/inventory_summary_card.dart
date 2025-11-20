import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class InventorySummaryCard extends StatelessWidget {
  const InventorySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreen.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.neutralWhite.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Reflective overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.neutralWhite.withOpacity(0.25),
                    AppColors.neutralWhite.withOpacity(0.0),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusMD),
                  topRight: Radius.circular(AppSpacing.radiusMD),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
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
                      child: const HugeIcon(
                        icon: HugeIcons.strokeRoundedPackage,
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
                const SizedBox(height: AppSpacing.md),
                
                // Statistics Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        label: 'Total Items',
                        value: '48',
                        icon: HugeIcons.strokeRoundedBread01,
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
                        icon: HugeIcons.strokeRoundedAlertCircle,
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
                        icon: HugeIcons.strokeRoundedLeaf01,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required dynamic icon,
  }) {
    return Column(
      children: [
        HugeIcon(
          icon: icon,
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
