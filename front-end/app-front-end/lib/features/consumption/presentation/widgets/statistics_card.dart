import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Statistics Card Widget
/// Displays consumption statistics in a card format
class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final String? subtitle;
  final VoidCallback? onTap;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSpacing.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColors.primaryGreen).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                    ),
                    child: Icon(
                      icon,
                      size: AppSpacing.iconMD,
                      color: iconColor ?? AppColors.primaryGreen,
                    ),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: AppSpacing.iconXS,
                      color: AppColors.neutralGray,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                value,
                style: AppTypography.h2.copyWith(
                  color: AppColors.neutralBlack,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.successGreen,
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
