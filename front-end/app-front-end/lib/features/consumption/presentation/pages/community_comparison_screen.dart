import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class CommunityComparisonScreen extends StatelessWidget {
  const CommunityComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final userWaste = 450.0; // grams per week
    final communityAverage = 620.0; // grams per week
    final percentDifference = ((userWaste - communityAverage) / communityAverage * 100);
    final isBetter = percentDifference < 0;

    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.neutralBlack),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Community Comparison',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'How You Compare',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your waste vs community average',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Comparison Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isBetter
                      ? [
                          AppColors.successGreen.withOpacity(0.1),
                          AppColors.primaryGreenLight.withOpacity(0.05),
                        ]
                      : [
                          AppColors.warningYellow.withOpacity(0.1),
                          AppColors.secondaryOrangeLight.withOpacity(0.05),
                        ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                border: Border.all(
                  color: isBetter
                      ? AppColors.successGreen.withOpacity(0.3)
                      : AppColors.warningYellow.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isBetter ? Icons.trending_down : Icons.trending_up,
                    size: 48,
                    color: isBetter ? AppColors.successGreen : AppColors.warningYellow,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${percentDifference.abs().toStringAsFixed(1)}%',
                    style: AppTypography.h1.copyWith(
                      fontSize: 48,
                      color: isBetter ? AppColors.successGreen : AppColors.warningYellow,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    isBetter ? 'Below Average' : 'Above Average',
                    style: AppTypography.bodyLarge.copyWith(
                      color: isBetter ? AppColors.successGreen : AppColors.warningYellow,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    isBetter
                        ? 'Great job! You\'re wasting less than average'
                        : 'Room for improvement - try reducing waste',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Bar Chart Comparison
            Text(
              'Weekly Waste Comparison',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildComparisonBars(userWaste, communityAverage),

            const SizedBox(height: AppSpacing.xl),

            // Detailed Stats
            Text(
              'Detailed Breakdown',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildStatRow('Your Waste', '$userWaste g/week', AppColors.primaryGreen),
            const SizedBox(height: AppSpacing.sm),
            _buildStatRow('Community Avg', '$communityAverage g/week', AppColors.neutralGray),
            const SizedBox(height: AppSpacing.sm),
            _buildStatRow(
              'Difference',
              '${(userWaste - communityAverage).abs().toStringAsFixed(0)} g',
              isBetter ? AppColors.successGreen : AppColors.warningYellow,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Leaderboard Position
            _buildLeaderboardCard(),

            const SizedBox(height: AppSpacing.xl),

            // Tips Section
            if (!isBetter) _buildImprovementTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonBars(double userWaste, double communityAverage) {
    final maxValue = [userWaste, communityAverage].reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Column(
        children: [
          _buildBar('You', userWaste, maxValue, AppColors.primaryGreen),
          const SizedBox(height: AppSpacing.lg),
          _buildBar('Community', communityAverage, maxValue, AppColors.neutralGray),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double value, double maxValue, Color color) {
    final percentage = value / maxValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: AppTypography.semiBold,
              ),
            ),
            Text(
              '${value.toStringAsFixed(0)}g',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: AppTypography.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Stack(
          children: [
            // Background bar
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.neutralLightGray,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
            ),
            // Value bar
            FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                ),
                child: Center(
                  child: Text(
                    '${(percentage * 100).toStringAsFixed(0)}%',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralWhite,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium,
          ),
          Text(
            value,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: AppTypography.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.infoBlue.withOpacity(0.1),
            AppColors.primaryGreenLight.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.infoBlue,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: AppColors.neutralWhite,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Rank',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '#127 out of 500 users',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: AppTypography.bold,
                    color: AppColors.infoBlue,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.neutralGray,
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementTips() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withOpacity(0.1),
            AppColors.primaryGreenLight.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tips_and_updates_outlined,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Tips to Improve',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...[
            'Plan your meals to avoid over-purchasing',
            'Store food properly to extend shelf life',
            'Use leftovers creatively in new recipes',
            'Share surplus with neighbors or food banks',
          ].map((tip) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        tip,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralDarkGray,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
