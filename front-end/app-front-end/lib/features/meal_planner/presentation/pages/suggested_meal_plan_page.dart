import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/meal_plan.dart';
import '../../data/services/meal_planner_service.dart';

class SuggestedMealPlanPage extends StatefulWidget {
  final double budget;
  final List<String> dietaryPreferences;
  final int numberOfMeals;

  const SuggestedMealPlanPage({
    super.key,
    this.budget = 100.0,
    this.dietaryPreferences = const [],
    this.numberOfMeals = 3,
  });

  @override
  State<SuggestedMealPlanPage> createState() => _SuggestedMealPlanPageState();
}

class _SuggestedMealPlanPageState extends State<SuggestedMealPlanPage> {
  late MealPlan _mealPlan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generatePlan();
  }

  void _generatePlan() {
    setState(() {
      _isLoading = true;
    });

    // Simulate AI generation delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _mealPlan = MealPlannerService.generateMealPlan(
          budget: widget.budget,
          dietaryPreferences: widget.dietaryPreferences,
          numberOfMeals: widget.numberOfMeals,
        );
        _isLoading = false;
      });
    });
  }

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
          'Suggested Meal Plan',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryGreen),
            onPressed: _generatePlan,
            tooltip: 'Regenerate',
          ),
        ],
      ),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
      bottomNavigationBar: _isLoading ? null : _buildBottomButtons(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen.withOpacity(0.2),
                  AppColors.primaryGreenLight.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              size: 64,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const CircularProgressIndicator(
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'AI is creating your perfect meal plan...',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success Banner
          _buildSuccessBanner(),

          const SizedBox(height: AppSpacing.lg),

          // Budget Summary
          _buildBudgetSummary(),

          const SizedBox(height: AppSpacing.lg),

          // Daily Meal Plans
          Text(
            '7-Day Meal Plan',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.md),

          ..._mealPlan.dailyPlans.asMap().entries.map((entry) {
            return _buildDayMealPlan(entry.key + 1, entry.value);
          }),
        ],
      ),
    );
  }

  Widget _buildSuccessBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.successGreen.withOpacity(0.2),
            AppColors.primaryGreen.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.successGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.successGreen,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan Generated Successfully!',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: AppTypography.semiBold,
                    color: AppColors.successGreen,
                  ),
                ),
                Text(
                  _mealPlan.isWithinBudget
                      ? 'Within your budget of \$${widget.budget.toStringAsFixed(2)}'
                      : 'Slightly over budget - consider adjustments',
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

  Widget _buildBudgetSummary() {
    final isWithinBudget = _mealPlan.isWithinBudget;
    final progress = _mealPlan.estimatedCost / _mealPlan.totalBudget;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.neutralLightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Cost',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
              Text(
                '\$${_mealPlan.estimatedCost.toStringAsFixed(2)} / \$${_mealPlan.totalBudget.toStringAsFixed(2)}',
                style: AppTypography.h5.copyWith(
                  fontWeight: AppTypography.bold,
                  color: isWithinBudget ? AppColors.primaryGreen : AppColors.errorRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: progress > 1 ? 1 : progress,
            backgroundColor: AppColors.neutralLightGray,
            valueColor: AlwaysStoppedAnimation(
              isWithinBudget ? AppColors.primaryGreen : AppColors.errorRed,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          if (!isWithinBudget) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Over budget by \$${(_mealPlan.estimatedCost - _mealPlan.totalBudget).toStringAsFixed(2)}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.errorRed,
                fontWeight: AppTypography.semiBold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDayMealPlan(int dayNumber, DailyMealPlan dailyPlan) {
    final dayFormat = DateFormat('EEEE, MMM d');

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.neutralLightGray),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutralBlack.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusMD),
                topRight: Radius.circular(AppSpacing.radiusMD),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$dayNumber',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.neutralWhite,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      dayFormat.format(dailyPlan.date),
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${dailyPlan.totalCost.toStringAsFixed(2)}',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                    Text(
                      '${dailyPlan.totalCalories} cal',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.neutralGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Meals
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: dailyPlan.allMeals.map((meal) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildMealCard(meal),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(meal) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: _getMealTypeColor(meal.type),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                ),
                child: Icon(
                  _getMealTypeIcon(meal.type),
                  color: AppColors.neutralWhite,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  meal.name,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ),
              Text(
                '\$${meal.estimatedCost.toStringAsFixed(2)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            meal.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: 4,
            children: [
              _buildInfoChip(
                '${meal.prepTimeMinutes} min',
                Icons.access_time,
                AppColors.infoBlue,
              ),
              if (meal.nutrition != null)
                _buildInfoChip(
                  '${meal.nutrition!.calories} cal',
                  Icons.local_fire_department,
                  AppColors.secondaryOrange,
                ),
              _buildInfoChip(
                '${meal.servings} servings',
                Icons.people,
                AppColors.neutralGray,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 9,
              color: color,
              fontWeight: AppTypography.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        border: Border(
          top: BorderSide(color: AppColors.neutralLightGray),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                // Apply plan and navigate back to weekly planner
                context.go('/meal-planner');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(
                'Apply This Plan',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.neutralWhite,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () {
                context.push('/meal-planner/shopping');
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                side: const BorderSide(color: AppColors.primaryGreen),
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(
                'View Shopping List',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMealTypeColor(type) {
    switch (type.toString().split('.').last) {
      case 'breakfast':
        return AppColors.secondaryOrange;
      case 'lunch':
        return AppColors.infoBlue;
      case 'dinner':
        return AppColors.primaryGreen;
      default:
        return AppColors.warningYellow;
    }
  }

  IconData _getMealTypeIcon(type) {
    switch (type.toString().split('.').last) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.cookie;
    }
  }
}
