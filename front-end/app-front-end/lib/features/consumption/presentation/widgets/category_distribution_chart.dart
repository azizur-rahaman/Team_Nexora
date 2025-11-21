import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Category Distribution Chart
/// Displays consumption data by category with visual bars
class CategoryDistributionChart extends StatelessWidget {
  final Map<String, double> categoryData;
  final Map<String, Color> categoryColors;

  const CategoryDistributionChart({
    super.key,
    required this.categoryData,
    required this.categoryColors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSpacing.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Distribution',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (categoryData.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    'No data available',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                ),
              )
            else
              _buildCategoryBars(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBars() {
    final total = categoryData.values.fold(0.0, (sum, value) => sum + value);
    final maxValue = categoryData.values.reduce(math.max);
    
    return Column(
      children: categoryData.entries.map((entry) {
        final percentage = (entry.value / total * 100);
        final barWidth = maxValue > 0 ? entry.value / maxValue : 0.0;
        final color = categoryColors[entry.key] ?? AppColors.primaryGreen;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: AppTypography.medium,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
                child: LinearProgressIndicator(
                  value: barWidth,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
