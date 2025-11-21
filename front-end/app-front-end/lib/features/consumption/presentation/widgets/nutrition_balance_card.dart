import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_trend.dart';

class NutritionBalanceCard extends StatelessWidget {
  final NutritionBalance nutritionBalance;

  const NutritionBalanceCard({
    super.key,
    required this.nutritionBalance,
  });

  @override
  Widget build(BuildContext context) {
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
                    color: _getScoreColor(nutritionBalance.overallScore).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                  child: Icon(
                    Icons.health_and_safety,
                    color: _getScoreColor(nutritionBalance.overallScore),
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nutrition Score',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: AppTypography.semiBold,
                          color: AppColors.neutralBlack,
                        ),
                      ),
                      Text(
                        nutritionBalance.scoreDescription,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildScoreBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Overall Score Bar
            _buildScoreBar(),
            const SizedBox(height: AppSpacing.md),
            
            // Category Status
            Text(
              'Category Breakdown',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: AppTypography.semiBold,
                color: AppColors.neutralBlack,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...nutritionBalance.categoryStatus.entries.map((entry) => 
              _buildCategoryItem(entry.key, entry.value)
            ),
            
            // Imbalances
            if (nutritionBalance.imbalances.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _buildImbalancesSection(),
            ],
            
            // Recommendations
            if (nutritionBalance.recommendations.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _buildRecommendationsSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBadge() {
    final score = nutritionBalance.overallScore.toInt();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getScoreColor(nutritionBalance.overallScore),
            _getScoreColor(nutritionBalance.overallScore).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        boxShadow: [
          BoxShadow(
            color: _getScoreColor(nutritionBalance.overallScore).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$score',
        style: AppTypography.h2.copyWith(
          color: AppColors.neutralWhite,
          fontWeight: AppTypography.bold,
        ),
      ),
    );
  }

  Widget _buildScoreBar() {
    final score = nutritionBalance.overallScore / 100;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Balance',
              style: AppTypography.caption.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
            Text(
              '${nutritionBalance.overallScore.toInt()}/100',
              style: AppTypography.caption.copyWith(
                color: AppColors.neutralDarkGray,
                fontWeight: AppTypography.semiBold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
          child: LinearProgressIndicator(
            value: score,
            minHeight: 8,
            backgroundColor: AppColors.neutralGray.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              _getScoreColor(nutritionBalance.overallScore),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(NutritionCategory category, NutritionStatus status) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Row(
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 16,
            color: _getStatusColor(status),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              category.label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
          ),
          _buildStatusChip(status),
        ],
      ),
    );
  }

  Widget _buildStatusChip(NutritionStatus status) {
    String label;
    switch (status) {
      case NutritionStatus.deficient:
        label = 'Low';
        break;
      case NutritionStatus.low:
        label = 'Below';
        break;
      case NutritionStatus.adequate:
        label = 'Good';
        break;
      case NutritionStatus.high:
        label = 'High';
        break;
      case NutritionStatus.excessive:
        label = 'Too High';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: _getStatusColor(status),
          fontWeight: AppTypography.semiBold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildImbalancesSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.warningYellow.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: AppColors.warningYellow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: AppColors.warningYellow,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Imbalances Detected',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.neutralBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ...nutritionBalance.imbalances.take(3).map((imbalance) =>
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '• ${imbalance.message}',
                style: AppTypography.caption.copyWith(
                  color: AppColors.neutralDarkGray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primaryGreenLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: AppColors.primaryGreenLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Recommendations',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.neutralBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ...nutritionBalance.recommendations.take(3).map((rec) =>
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '• $rec',
                style: AppTypography.caption.copyWith(
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
        return AppColors.secondaryOrange;
      case NutritionStatus.adequate:
        return AppColors.successGreen;
      case NutritionStatus.high:
        return AppColors.warningYellow;
      case NutritionStatus.excessive:
        return AppColors.errorRed;
    }
  }

  IconData _getCategoryIcon(NutritionCategory category) {
    switch (category) {
      case NutritionCategory.vegetables:
        return Icons.eco;
      case NutritionCategory.fruits:
        return Icons.apple;
      case NutritionCategory.grains:
        return Icons.grain;
      case NutritionCategory.protein:
        return Icons.restaurant;
      case NutritionCategory.dairy:
        return Icons.local_drink;
      case NutritionCategory.fats:
        return Icons.opacity;
    }
  }
}
