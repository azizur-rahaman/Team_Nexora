import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/consumption_trend.dart';

class NutritionBalanceCard extends StatelessWidget {
  final NutritionBalance balance;
  final VoidCallback? onTap;

  const NutritionBalanceCard({
    super.key,
    required this.balance,
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
              _buildScoreIndicator(),
              const SizedBox(height: AppSpacing.md),
              _buildCategoryStatus(),
              if (balance.imbalances.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                _buildImbalances(),
              ],
              if (balance.recommendations.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                _buildRecommendations(),
              ],
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
            color: AppColors.primaryGreenLight.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          child: const Icon(
            Icons.local_dining_outlined,
            color: AppColors.primaryGreen,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nutrition Balance',
                style: AppTypography.h3,
              ),
              Text(
                balance.scoreDescription,
                style: AppTypography.bodySmall.copyWith(
                  color: _getScoreColor(balance.overallScore),
                  fontWeight: AppTypography.medium,
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

  Widget _buildScoreIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Score',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralDarkGray,
              ),
            ),
            Text(
              '${balance.overallScore.toStringAsFixed(0)}/100',
              style: AppTypography.h3.copyWith(
                color: _getScoreColor(balance.overallScore),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
          child: LinearProgressIndicator(
            value: balance.overallScore / 100,
            backgroundColor: AppColors.neutralLightGray,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getScoreColor(balance.overallScore),
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutrition Categories',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: AppTypography.semiBold,
            color: AppColors.neutralBlack,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: balance.categoryStatus.entries
              .map((entry) => _buildCategoryChip(entry.key, entry.value))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(NutritionCategory category, NutritionStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        border: Border.all(
          color: _getStatusColor(status).withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: 14,
            color: _getStatusColor(status),
          ),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: AppTypography.caption.copyWith(
              color: AppColors.neutralBlack,
              fontWeight: AppTypography.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImbalances() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.warning_amber_outlined,
              size: 16,
              color: AppColors.warningYellow,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Imbalances Detected',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: AppTypography.semiBold,
                color: AppColors.neutralBlack,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...balance.imbalances.take(2).map(
          (imbalance) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.warningYellow,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    imbalance.message,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralDarkGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primaryGreenLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tips_and_updates_outlined,
                size: 16,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Recommendations',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ...balance.recommendations.take(2).map(
            (rec) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '• $rec',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralDarkGray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.successGreen;
    if (score >= 60) return AppColors.primaryGreen;
    if (score >= 40) return AppColors.warningYellow;
    return AppColors.errorRed;
  }

  Color _getStatusColor(NutritionStatus status) {
    switch (status) {
      case NutritionStatus.deficient:
        return AppColors.errorRed;
      case NutritionStatus.low:
        return AppColors.warningYellow;
      case NutritionStatus.adequate:
        return AppColors.successGreen;
      case NutritionStatus.high:
        return AppColors.infoBlue;
      case NutritionStatus.excessive:
        return AppColors.secondaryOrange;
    }
  }

  IconData _getStatusIcon(NutritionStatus status) {
    switch (status) {
      case NutritionStatus.deficient:
      case NutritionStatus.low:
        return Icons.arrow_downward;
      case NutritionStatus.adequate:
        return Icons.check;
      case NutritionStatus.high:
      case NutritionStatus.excessive:
        return Icons.arrow_upward;
    }
  }
}
