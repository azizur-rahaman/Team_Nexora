import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/consumption_trend.dart';

class WastePredictionCard extends StatelessWidget {
  final List<WastePrediction> predictions;
  final VoidCallback? onViewAll;

  const WastePredictionCard({
    super.key,
    required this.predictions,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty) {
      return _buildEmptyState();
    }

    // Sort by risk score (highest first)
    final sortedPredictions = List<WastePrediction>.from(predictions)
      ..sort((a, b) => b.riskScore.compareTo(a.riskScore));

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
            _buildHeader(sortedPredictions.length),
            const SizedBox(height: AppSpacing.md),
            ...sortedPredictions.take(3).map((prediction) => _buildPredictionItem(prediction)),
            if (sortedPredictions.length > 3) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildViewAllButton(sortedPredictions.length),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.errorRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: AppColors.errorRed,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Waste Predictions',
                style: AppTypography.h3,
              ),
              Text(
                '$count ${count == 1 ? 'item' : 'items'} at risk (3-7 days)',
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

  Widget _buildPredictionItem(WastePrediction prediction) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _getRiskColor(prediction.riskLevel).withOpacity(0.05),
        border: Border.all(
          color: _getRiskColor(prediction.riskLevel).withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prediction.itemName,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: AppTypography.semiBold,
                        color: AppColors.neutralBlack,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${prediction.estimatedWasteQuantity} ${prediction.unit}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.neutralGray,
                      ),
                    ),
                  ],
                ),
              ),
              _buildRiskBadge(prediction),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRiskIndicator(prediction),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: _getRiskColor(prediction.riskLevel),
              ),
              const SizedBox(width: 4),
              Text(
                '${prediction.daysUntilLikelyWaste} days until likely waste',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralDarkGray,
                ),
              ),
            ],
          ),
          if (prediction.preventionTips.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
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
                      prediction.preventionTips.first,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.neutralDarkGray,
                        fontStyle: FontStyle.italic,
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getRiskColor(prediction.riskLevel),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${prediction.riskScore.toStringAsFixed(0)}%',
            style: AppTypography.caption.copyWith(
              color: AppColors.neutralWhite,
              fontWeight: AppTypography.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskIndicator(WastePrediction prediction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Risk Level',
              style: AppTypography.caption.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
            Text(
              prediction.riskDescription,
              style: AppTypography.caption.copyWith(
                color: _getRiskColor(prediction.riskLevel),
                fontWeight: AppTypography.medium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
          child: LinearProgressIndicator(
            value: prediction.riskScore / 100,
            backgroundColor: AppColors.neutralLightGray,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getRiskColor(prediction.riskLevel),
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildViewAllButton(int count) {
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
              'View All $count Predictions',
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
              'No Waste Predicted!',
              style: AppTypography.h3,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Great job! No items are at risk of waste in the next 7 days.',
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

  Color _getRiskColor(WasteRiskLevel level) {
    switch (level) {
      case WasteRiskLevel.low:
        return AppColors.successGreen;
      case WasteRiskLevel.medium:
        return AppColors.warningYellow;
      case WasteRiskLevel.high:
        return AppColors.secondaryOrange;
      case WasteRiskLevel.critical:
        return AppColors.errorRed;
    }
  }
}
