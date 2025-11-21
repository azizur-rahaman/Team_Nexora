import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_log.dart';
import '../../domain/entities/consumption_trend.dart';

class ConsumptionTrendCard extends StatelessWidget {
  final List<ConsumptionTrend> trends;

  const ConsumptionTrendCard({
    super.key,
    required this.trends,
  });

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) {
      return _buildEmptyState();
    }

    return Card(
      elevation: AppSpacing.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Week\'s Consumption',
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: AppTypography.semiBold,
                color: AppColors.neutralBlack,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Analysis of your food consumption patterns',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...trends.map((trend) => _buildTrendItem(trend)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(ConsumptionTrend trend) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: trend.category.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: trend.category.accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                trend.category.icon,
                color: AppColors.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trend.category.label,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: AppTypography.semiBold,
                        color: AppColors.neutralBlack,
                      ),
                    ),
                    Text(
                      trend.trendDescription,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.neutralGray,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTrendIndicator(trend),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _buildMetric(
                '${trend.totalQuantity.toStringAsFixed(0)}',
                'Total',
              ),
              const SizedBox(width: AppSpacing.md),
              _buildMetric(
                '${trend.logCount}',
                'Entries',
              ),
              const SizedBox(width: AppSpacing.md),
              _buildMetric(
                '${trend.averagePerDay.toStringAsFixed(1)}',
                'Avg/Day',
              ),
            ],
          ),
          if (trend.isSignificantChange) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.warningYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.warningYellow,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Significant change from last week',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.neutralDarkGray,
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

  Widget _buildTrendIndicator(ConsumptionTrend trend) {
    IconData icon;
    Color color;
    
    switch (trend.direction) {
      case TrendDirection.increasing:
        icon = Icons.trending_up;
        color = AppColors.successGreen;
        break;
      case TrendDirection.decreasing:
        icon = Icons.trending_down;
        color = AppColors.errorRed;
        break;
      case TrendDirection.stable:
        icon = Icons.trending_flat;
        color = AppColors.neutralGray;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '${trend.percentageChange > 0 ? '+' : ''}${trend.percentageChange.toStringAsFixed(1)}%',
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: AppTypography.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: AppTypography.semiBold,
            color: AppColors.neutralBlack,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.neutralGray,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: AppSpacing.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(
              Icons.trending_up,
              size: 64,
              color: AppColors.neutralGray.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No Trends Yet',
              style: AppTypography.h3.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Start logging your consumption to see patterns',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
