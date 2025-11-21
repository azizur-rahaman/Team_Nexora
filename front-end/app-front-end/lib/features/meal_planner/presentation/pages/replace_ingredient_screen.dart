import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/ingredient_replacement.dart';
import '../../data/services/meal_planner_service.dart';

class ReplaceIngredientScreen extends StatefulWidget {
  const ReplaceIngredientScreen({super.key});

  @override
  State<ReplaceIngredientScreen> createState() => _ReplaceIngredientScreenState();
}

class _ReplaceIngredientScreenState extends State<ReplaceIngredientScreen> {
  late List<IngredientReplacement> _replacements;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _replacements = MealPlannerService.getReplacementSuggestions();
  }

  IngredientReplacement get _currentReplacement => _replacements[_currentIndex];

  @override
  Widget build(BuildContext context) {
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
          'Ingredient Suggestions',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          if (_replacements.length > 1) _buildProgressIndicator(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AI Suggestion Badge
                  _buildAIBadge(),

                  const SizedBox(height: AppSpacing.lg),

                  // Comparison Cards
                  _buildComparisonSection(),

                  const SizedBox(height: AppSpacing.xl),

                  // Benefits
                  _buildBenefitsSection(),

                  const SizedBox(height: AppSpacing.xl),

                  // Nutrition Comparison (if available)
                  if (_currentReplacement.nutritionComparison != null)
                    _buildNutritionComparison(),

                  const SizedBox(height: AppSpacing.xl),

                  // Reason
                  _buildReasonSection(),
                ],
              ),
            ),
          ),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGray.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: AppColors.neutralLightGray),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Suggestion ${_currentIndex + 1} of ${_replacements.length}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
          Row(
            children: List.generate(_replacements.length, (index) {
              return Container(
                margin: const EdgeInsets.only(left: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == _currentIndex
                      ? AppColors.primaryGreen
                      : AppColors.neutralLightGray,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAIBadge() {
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
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: AppColors.primaryGreen,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Recommendation',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: AppTypography.semiBold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Text(
                  '${(_currentReplacement.confidenceScore * 100).toStringAsFixed(0)}% confidence',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection() {
    return Row(
      children: [
        // Original Ingredient
        Expanded(
          child: _buildIngredientCard(
            _currentReplacement.originalIngredient,
            _currentReplacement.originalCost,
            'Current',
            AppColors.neutralGray,
            false,
          ),
        ),

        // Arrow
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Icon(
            Icons.arrow_forward,
            color: AppColors.primaryGreen,
            size: 32,
          ),
        ),

        // Replacement Ingredient
        Expanded(
          child: _buildIngredientCard(
            _currentReplacement.replacementIngredient,
            _currentReplacement.replacementCost,
            'Suggested',
            AppColors.primaryGreen,
            true,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientCard(
    String name,
    double cost,
    String label,
    Color color,
    bool isHighlighted,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isHighlighted ? color.withOpacity(0.1) : AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: color,
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
            ),
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                fontSize: 9,
                color: AppColors.neutralWhite,
                fontWeight: AppTypography.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            name,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: AppTypography.semiBold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '\$${cost.toStringAsFixed(2)}',
            style: AppTypography.h4.copyWith(
              fontWeight: AppTypography.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why This Replacement?',
          style: AppTypography.h5,
        ),
        const SizedBox(height: AppSpacing.md),

        // Savings Highlight
        if (_currentReplacement.isCheaper)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.successGreen.withOpacity(0.2),
                  AppColors.successGreen.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              border: Border.all(color: AppColors.successGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.savings,
                  color: AppColors.successGreen,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Save \$${_currentReplacement.costSavings.toStringAsFixed(2)}',
                        style: AppTypography.h5.copyWith(
                          fontWeight: AppTypography.bold,
                          color: AppColors.successGreen,
                        ),
                      ),
                      Text(
                        '${_currentReplacement.savingsPercentage.toStringAsFixed(0)}% cheaper',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: AppSpacing.md),

        // Benefits List
        ..._currentReplacement.benefits.map((benefit) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _buildBenefitItem(benefit),
          );
        }),
      ],
    );
  }

  Widget _buildBenefitItem(String benefit) {
    final icon = _getBenefitIcon(benefit);
    final color = _getBenefitColor(benefit);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              benefit,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: AppTypography.semiBold,
                color: color,
              ),
            ),
          ),
          Icon(Icons.check_circle, color: color, size: 20),
        ],
      ),
    );
  }

  Widget _buildNutritionComparison() {
    final nutrition = _currentReplacement.nutritionComparison!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutrition Comparison',
          style: AppTypography.h5,
        ),
        const SizedBox(height: AppSpacing.md),

        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.neutralLightGray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          child: Column(
            children: [
              _buildNutritionRow(
                'Calories',
                nutrition.originalCalories,
                nutrition.replacementCalories,
                'cal',
              ),
              const Divider(),
              _buildNutritionRow(
                'Protein',
                nutrition.originalProtein,
                nutrition.replacementProtein,
                'g',
              ),
              const Divider(),
              _buildNutritionRow(
                'Fat',
                nutrition.originalFat,
                nutrition.replacementFat,
                'g',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionRow(String label, num original, num replacement, String unit) {
    final difference = replacement - original;
    final isPositive = difference > 0;
    final color = label == 'Protein' && isPositive
        ? AppColors.successGreen
        : label == 'Fat' && !isPositive
            ? AppColors.successGreen
            : AppColors.neutralGray;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: AppTypography.semiBold,
            ),
          ),
          Row(
            children: [
              Text(
                '$original$unit',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.arrow_forward,
                size: 12,
                color: AppColors.neutralGray,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$replacement$unit',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: AppTypography.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReasonSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.infoBlue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.infoBlue, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'AI Analysis',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.infoBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _currentReplacement.reason,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.neutralDarkGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        border: Border(
          top: BorderSide(color: AppColors.neutralLightGray),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentIndex > 0)
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentIndex--;
                  });
                },
                icon: const Icon(Icons.chevron_left),
                color: AppColors.primaryGreen,
              ),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Skip this suggestion
                  if (_currentIndex < _replacements.length - 1) {
                    setState(() {
                      _currentIndex++;
                    });
                  } else {
                    context.pop();
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  side: const BorderSide(color: AppColors.neutralGray),
                ),
                child: Text(
                  'Skip',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  // Apply replacement
                  _showReplacementApplied();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
                child: Text(
                  'Replace',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.neutralWhite,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ),
            ),
            if (_currentIndex < _replacements.length - 1)
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentIndex++;
                  });
                },
                icon: const Icon(Icons.chevron_right),
                color: AppColors.primaryGreen,
              ),
          ],
        ),
      ),
    );
  }

  void _showReplacementApplied() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Replaced ${_currentReplacement.originalIngredient} with ${_currentReplacement.replacementIngredient}',
        ),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Move to next or close
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_currentIndex < _replacements.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        context.pop();
      }
    });
  }

  IconData _getBenefitIcon(String benefit) {
    if (benefit.toLowerCase().contains('cheap') || benefit.toLowerCase().contains('save')) {
      return Icons.savings;
    } else if (benefit.toLowerCase().contains('health') || benefit.toLowerCase().contains('nutrition')) {
      return Icons.favorite;
    } else if (benefit.toLowerCase().contains('sustain') || benefit.toLowerCase().contains('eco')) {
      return Icons.eco;
    } else if (benefit.toLowerCase().contains('season')) {
      return Icons.calendar_today;
    }
    return Icons.check_circle;
  }

  Color _getBenefitColor(String benefit) {
    if (benefit.toLowerCase().contains('cheap') || benefit.toLowerCase().contains('save')) {
      return AppColors.successGreen;
    } else if (benefit.toLowerCase().contains('health') || benefit.toLowerCase().contains('nutrition')) {
      return AppColors.errorRed;
    } else if (benefit.toLowerCase().contains('sustain') || benefit.toLowerCase().contains('eco')) {
      return AppColors.primaryGreen;
    }
    return AppColors.infoBlue;
  }
}
