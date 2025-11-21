import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/consumption_log.dart';
import '../../../domain/entities/consumption_trend.dart';

class ConsumptionTrendCard extends StatelessWidget {
  final ConsumptionTrend trend;
  final VoidCallback? onTap;

  const ConsumptionTrendCard({
    super.key,
    required this.trend,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSpacing.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.md),
              _buildStats(),
              const SizedBox(height: AppSpacing.md),
              _buildTrendIndicator(),
              const SizedBox(height: AppSpacing.md),
              _buildWeeklyChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: trend.category.accentColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          child: Icon(
            trend.category.icon,
            color: AppColors.primaryGreenDark,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trend.category.label,
                style: AppTypography.h3,
              ),
              Text(
                'Weekly Trend',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.neutralGray,
          ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Total',
            '${trend.totalQuantity.toStringAsFixed(1)}',
            Icons.shopping_basket_outlined,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Logs',
            '${trend.logCount}',
            Icons.list_alt,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Daily Avg',
            trend.averagePerDay.toStringAsFixed(1),
            Icons.calendar_today,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGray,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.neutralGray),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.h3.copyWith(fontSize: 18),
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: _getTrendColor().withOpacity(0.1),
        border: Border.all(
          color: _getTrendColor().withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Row(
        children: [
          Icon(
            _getTrendIcon(),
            color: _getTrendColor(),
            size: 20,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              trend.trendDescription,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralBlack,
                fontWeight: AppTypography.medium,
              ),
            ),
          ),
          if (trend.isSignificantChange)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.warningYellow,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: Text(
                'Significant',
                style: AppTypography.caption.copyWith(
                  color: AppColors.neutralWhite,
                  fontWeight: AppTypography.bold,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    if (trend.dailyBreakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxQuantity = trend.dailyBreakdown
        .map((d) => d.quantity)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Breakdown',
          style: AppTypography.bodySmall.copyWith(
            fontWeight: AppTypography.semiBold,
            color: AppColors.neutralDarkGray,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: trend.dailyBreakdown.map((daily) {
            final heightPercent = maxQuantity > 0 ? daily.quantity / maxQuantity : 0;
            final date = DateTime.parse(daily.date);
            final dayName = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    Text(
                      daily.quantity.toStringAsFixed(0),
                      style: AppTypography.caption.copyWith(
                        fontSize: 9,
                        color: AppColors.neutralGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      height: (60 * heightPercent.clamp(0.1, 1.0)).toDouble(),
                      decoration: BoxDecoration(
                        color: trend.category.accentColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayName,
                      style: AppTypography.caption.copyWith(
                        fontSize: 9,
                        color: AppColors.neutralDarkGray,
                        fontWeight: AppTypography.medium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getTrendColor() {
    switch (trend.direction) {
      case TrendDirection.increasing:
        return AppColors.successGreen;
      case TrendDirection.decreasing:
        return AppColors.secondaryOrange;
      case TrendDirection.stable:
        return AppColors.infoBlue;
    }
  }

  IconData _getTrendIcon() {
    switch (trend.direction) {
      case TrendDirection.increasing:
        return Icons.trending_up;
      case TrendDirection.decreasing:
        return Icons.trending_down;
      case TrendDirection.stable:
        return Icons.trending_flat;
    }
  }
}
