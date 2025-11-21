import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_trend.dart';

class CategoryImbalanceScreen extends StatelessWidget {
  const CategoryImbalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for nutrition categories
    final categoryData = {
      NutritionCategory.protein: 65.0, // percentage of recommended
      NutritionCategory.vegetables: 45.0, // Under-consumed
      NutritionCategory.fruits: 85.0,
      NutritionCategory.grains: 95.0,
      NutritionCategory.dairy: 55.0, // Under-consumed
      NutritionCategory.fats: 110.0, // Over-consumed
    };

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
          'Nutrition Balance',
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
              'Category Balance Analysis',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Balanced nutrition across food groups',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Circular Radial Chart
            Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: CustomPaint(
                  painter: RadialChartPainter(categoryData),
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Category Stats
            Text(
              'Category Breakdown',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.md),
            
            ...categoryData.entries.map((entry) {
              return _buildCategoryRow(entry.key, entry.value);
            }),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Under-consumed Items
            _buildUnderConsumedSection(categoryData),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Recommendations
            _buildRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(NutritionCategory category, double percentage) {
    final isBalanced = percentage >= 80 && percentage <= 120;
    final isUnder = percentage < 80;
    final status = isBalanced ? 'Balanced' : isUnder ? 'Under' : 'Over';
    final statusColor = isBalanced 
        ? AppColors.successGreen 
        : isUnder 
            ? AppColors.warningYellow 
            : AppColors.secondaryOrange;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.label,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                ),
                child: Text(
                  status,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.neutralWhite,
                    fontWeight: AppTypography.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (percentage / 100).clamp(0.0, 1.2),
                    backgroundColor: AppColors.neutralLightGray,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: AppTypography.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnderConsumedSection(Map<NutritionCategory, double> data) {
    final underConsumed = data.entries
        .where((entry) => entry.value < 80)
        .toList();

    if (underConsumed.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.successGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          border: Border.all(
            color: AppColors.successGreen.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.successGreen,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'All categories are balanced!',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.successGreen,
                  fontWeight: AppTypography.medium,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.warning_amber_outlined,
              color: AppColors.warningYellow,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Under-Consumed Items',
              style: AppTypography.h5.copyWith(
                color: AppColors.warningYellow,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...underConsumed.map((entry) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.warningYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
            ),
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
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '${entry.key.label}: Only ${entry.value.toStringAsFixed(0)}% of recommended intake',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralDarkGray,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecommendations() {
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
                'Recommendations',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...[
            'Add more vegetables to your daily meals',
            'Include dairy products like milk or yogurt',
            'Maintain your current protein intake',
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

class RadialChartPainter extends CustomPainter {
  final Map<NutritionCategory, double> data;

  RadialChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius * 0.5;

    final categories = data.entries.toList();
    final sweepAngle = 2 * math.pi / categories.length;

    for (var i = 0; i < categories.length; i++) {
      final entry = categories[i];
      final startAngle = i * sweepAngle - math.pi / 2;
      final percentage = entry.value / 100;
      final barLength = (radius - innerRadius) * percentage.clamp(0.0, 1.2);

      final color = _getCategoryColor(entry.key, percentage);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final path = Path();
      path.moveTo(
        center.dx + innerRadius * math.cos(startAngle),
        center.dy + innerRadius * math.sin(startAngle),
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius + barLength),
        startAngle,
        sweepAngle * 0.9,
        false,
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle + sweepAngle * 0.9,
        -sweepAngle * 0.9,
        false,
      );
      path.close();

      canvas.drawPath(path, paint);

      // Draw label
      final labelAngle = startAngle + sweepAngle / 2;
      final labelRadius = radius + 20;
      final labelX = center.dx + labelRadius * math.cos(labelAngle);
      final labelY = center.dy + labelRadius * math.sin(labelAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: entry.key.label.substring(0, 3).toUpperCase(),
          style: const TextStyle(
            color: AppColors.neutralBlack,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
      );
    }

    // Draw center circle with score
    final centerPaint = Paint()
      ..color = AppColors.neutralWhite
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius - 5, centerPaint);

    final avgPercentage = data.values.reduce((a, b) => a + b) / data.length;
    final scorePainter = TextPainter(
      text: TextSpan(
        text: '${avgPercentage.toStringAsFixed(0)}%',
        style: const TextStyle(
          color: AppColors.primaryGreen,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    scorePainter.layout();
    scorePainter.paint(
      canvas,
      Offset(
        center.dx - scorePainter.width / 2,
        center.dy - scorePainter.height / 2 - 10,
      ),
    );

    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'Balance',
        style: TextStyle(
          color: AppColors.neutralGray,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();
    labelPainter.paint(
      canvas,
      Offset(
        center.dx - labelPainter.width / 2,
        center.dy + 10,
      ),
    );
  }

  Color _getCategoryColor(NutritionCategory category, double percentage) {
    if (percentage < 0.8) return AppColors.warningYellow;
    if (percentage > 1.2) return AppColors.secondaryOrange;
    return AppColors.successGreen;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
