import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_log.dart';
import '../../domain/entities/consumption_trend.dart';

class WastePredictionCard extends StatelessWidget {
  final List<WastePrediction> predictions;

  const WastePredictionCard({
    super.key,
    required this.predictions,
  });

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty) {
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                  child: const Icon(
                    Icons.warning_amber,
                    color: AppColors.errorRed,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Waste Risk Alert',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: AppTypography.semiBold,
                          color: AppColors.neutralBlack,
                        ),
                      ),
                      Text(
                        '${predictions.length} items at risk in 3-7 days',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...predictions.take(5).map((prediction) => _buildPredictionItem(prediction)),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionItem(WastePrediction prediction) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: _getRiskColor(prediction.riskLevel).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: _getRiskColor(prediction.riskLevel).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                prediction.category.icon,
                color: AppColors.neutralDarkGray,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  prediction.itemName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: AppTypography.semiBold,
                    color: AppColors.neutralBlack,
                  ),
                ),
              ),
              _buildRiskBadge(prediction),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.neutralGray,
              ),
              const SizedBox(width: 4),
              Text(
                'Likely waste in ${prediction.daysUntilLikelyWaste} days',
                style: AppTypography.caption.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
              const Spacer(),
              Text(
                '${prediction.estimatedWasteQuantity.toStringAsFixed(0)} ${prediction.unit}',
                style: AppTypography.caption.copyWith(
                  color: AppColors.neutralDarkGray,
                  fontWeight: AppTypography.medium,
                ),
              ),
            ],
          ),
          if (prediction.contributingFactors.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: prediction.contributingFactors.take(2).map((factor) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutralGray.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                  child: Text(
                    factor,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.neutralDarkGray,
                      fontSize: 10,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (prediction.preventionTips.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      prediction.preventionTips.first,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primaryGreenDark,
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

  Widget _buildRiskBadge(WastePrediction prediction) {
    final color = _getRiskColor(prediction.riskLevel);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getRiskIcon(prediction.riskLevel),
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${prediction.riskScore.toInt()}%',
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: AppTypography.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(WasteRiskLevel level) {
    switch (level) {
      case WasteRiskLevel.critical:
        return AppColors.errorRed;
      case WasteRiskLevel.high:
        return AppColors.secondaryOrange;
      case WasteRiskLevel.medium:
        return AppColors.warningYellow;
      case WasteRiskLevel.low:
        return AppColors.successGreen;
    }
  }

  IconData _getRiskIcon(WasteRiskLevel level) {
    switch (level) {
      case WasteRiskLevel.critical:
        return Icons.error;
      case WasteRiskLevel.high:
        return Icons.warning;
      case WasteRiskLevel.medium:
        return Icons.info;
      case WasteRiskLevel.low:
        return Icons.check_circle;
    }
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
              Icons.check_circle,
              size: 64,
              color: AppColors.successGreen.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No Waste Risk!',
              style: AppTypography.h3.copyWith(
                color: AppColors.successGreen,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'All items are being used efficiently',
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
