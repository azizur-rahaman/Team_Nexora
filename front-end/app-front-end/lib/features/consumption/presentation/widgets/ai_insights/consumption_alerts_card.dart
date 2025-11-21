import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/consumption_trend.dart';

class ConsumptionAlertsCard extends StatelessWidget {
  final List<ConsumptionAlert> alerts;
  final VoidCallback? onViewAll;

  const ConsumptionAlertsCard({
    super.key,
    required this.alerts,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
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
            _buildHeader(),
            const SizedBox(height: AppSpacing.md),
            ...alerts.take(3).map((alert) => _buildAlertItem(alert)),
            if (alerts.length > 3) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildViewAllButton(),
            ],
          ],
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
            color: AppColors.warningYellow.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          child: const Icon(
            Icons.notification_important_outlined,
            color: AppColors.warningYellow,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consumption Alerts',
                style: AppTypography.h3,
              ),
              Text(
                '${alerts.length} active ${alerts.length == 1 ? 'alert' : 'alerts'}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertItem(ConsumptionAlert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _getSeverityColor(alert.severity).withOpacity(0.05),
        border: Border.all(
          color: _getSeverityColor(alert.severity).withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getAlertIcon(alert.type),
                color: _getSeverityColor(alert.severity),
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  alert.message,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: AppTypography.semiBold,
                    color: AppColors.neutralBlack,
                  ),
                ),
              ),
              _buildSeverityBadge(alert.severity),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Deviation: ${alert.deviation.toStringAsFixed(1)}% from baseline',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
          if (alert.recommendations.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            ...alert.recommendations.take(2).map(
              (rec) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 14,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        rec,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralDarkGray,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(AlertSeverity severity) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getSeverityColor(severity),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Text(
        severity.label.toUpperCase(),
        style: AppTypography.caption.copyWith(
          color: AppColors.neutralWhite,
          fontWeight: AppTypography.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildViewAllButton() {
    return InkWell(
      onTap: onViewAll,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.neutralLightGray,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View All ${alerts.length} Alerts',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: AppTypography.semiBold,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.arrow_forward,
              color: AppColors.primaryGreen,
              size: 16,
            ),
          ],
        ),
      ),
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
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.successGreen.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'All Clear!',
              style: AppTypography.h3,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'No consumption alerts at the moment',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.low:
        return AppColors.infoBlue;
      case AlertSeverity.medium:
        return AppColors.warningYellow;
      case AlertSeverity.high:
        return AppColors.secondaryOrange;
      case AlertSeverity.critical:
        return AppColors.errorRed;
    }
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.overConsumption:
        return Icons.trending_up;
      case AlertType.underConsumption:
        return Icons.trending_down;
      case AlertType.wastePrediction:
        return Icons.delete_outline;
      case AlertType.nutritionImbalance:
        return Icons.bar_chart;
    }
  }
}
