import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/meal.dart';
import '../../domain/entities/meal_plan.dart';
import '../../data/services/meal_planner_service.dart';

class WeeklyMealPlannerPage extends StatefulWidget {
  const WeeklyMealPlannerPage({super.key});

  @override
  State<WeeklyMealPlannerPage> createState() => _WeeklyMealPlannerPageState();
}

class _WeeklyMealPlannerPageState extends State<WeeklyMealPlannerPage> {
  late MealPlan _mealPlan;
  DateTime _weekStart = DateTime.now();

  @override
  void initState() {
    super.initState();
    _mealPlan = MealPlannerService.generateMealPlan(
      budget: 200.0,
      dietaryPreferences: [],
      numberOfMeals: 3,
      days: 7,
    );
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
          'Weekly Meal Planner',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: AppColors.primaryGreen),
            onPressed: () {
              // Navigate to AI Meal Plan Generator
            },
            tooltip: 'Generate AI Plan',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week Navigation
            _buildWeekNavigation(),

            const SizedBox(height: AppSpacing.lg),

            // Budget Summary
            _buildBudgetSummary(),

            const SizedBox(height: AppSpacing.lg),

            // 7-day Calendar Grid
            _buildCalendarGrid(),

            const SizedBox(height: AppSpacing.xl),

            // Quick Actions
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekNavigation() {
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final dateFormat = DateFormat('MMM d');

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.primaryGreen),
            onPressed: () {
              setState(() {
                _weekStart = _weekStart.subtract(const Duration(days: 7));
              });
            },
          ),
          Text(
            '${dateFormat.format(_weekStart)} - ${dateFormat.format(weekEnd)}',
            style: AppTypography.h5.copyWith(color: AppColors.primaryGreen),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.primaryGreen),
            onPressed: () {
              setState(() {
                _weekStart = _weekStart.add(const Duration(days: 7));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSummary() {
    final remaining = _mealPlan.budgetRemaining;
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
                'Weekly Budget',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
              Text(
                '\$${_mealPlan.totalBudget.toStringAsFixed(2)}',
                style: AppTypography.h5.copyWith(
                  fontWeight: AppTypography.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.neutralLightGray,
            valueColor: AlwaysStoppedAnimation(
              progress > 1 ? AppColors.errorRed : AppColors.primaryGreen,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: \$${_mealPlan.estimatedCost.toStringAsFixed(2)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
              Text(
                'Remaining: \$${remaining.toStringAsFixed(2)}',
                style: AppTypography.bodySmall.copyWith(
                  color: remaining >= 0 ? AppColors.successGreen : AppColors.errorRed,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week\'s Meals',
          style: AppTypography.h5,
        ),
        const SizedBox(height: AppSpacing.md),
        ..._mealPlan.dailyPlans.map((dailyPlan) => _buildDayCard(dailyPlan)),
      ],
    );
  }

  Widget _buildDayCard(DailyMealPlan dailyPlan) {
    final dayFormat = DateFormat('EEE, MMM d');
    final isToday = _isToday(dailyPlan.date);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        border: Border.all(
          color: isToday ? AppColors.primaryGreen : AppColors.neutralLightGray,
          width: isToday ? 2 : 1,
        ),
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
              color: isToday
                  ? AppColors.primaryGreen.withOpacity(0.1)
                  : AppColors.neutralLightGray.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusLG),
                topRight: Radius.circular(AppSpacing.radiusLG),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                        ),
                        child: Text(
                          'Today',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.neutralWhite,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                      ),
                    if (isToday) const SizedBox(width: AppSpacing.sm),
                    Text(
                      dayFormat.format(dailyPlan.date),
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$${dailyPlan.totalCost.toStringAsFixed(2)}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ],
            ),
          ),

          // Meal Slots
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                if (dailyPlan.breakfast != null)
                  _buildMealSlot(MealType.breakfast, dailyPlan.breakfast!),
                if (dailyPlan.lunch != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _buildMealSlot(MealType.lunch, dailyPlan.lunch!),
                ],
                if (dailyPlan.dinner != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _buildMealSlot(MealType.dinner, dailyPlan.dinner!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSlot(MealType type, Meal meal) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: _getMealTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: _getMealTypeColor(type).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal Icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: _getMealTypeColor(type),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
            ),
            child: Icon(
              _getMealTypeIcon(type),
              color: AppColors.neutralWhite,
              size: 16,
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // Meal Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      type.displayName,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.neutralGray,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getMealTypeColor(type),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                      ),
                      child: Text(
                        '${meal.prepTimeMinutes} min',
                        style: AppTypography.caption.copyWith(
                          fontSize: 9,
                          color: AppColors.neutralWhite,
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  meal.name,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
                const SizedBox(height: 4),
                // Inventory tags
                if (meal.inventoryItems.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: meal.inventoryItems.take(3).map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                        ),
                        child: Text(
                          item,
                          style: AppTypography.caption.copyWith(
                            fontSize: 9,
                            color: AppColors.primaryGreen,
                            fontWeight: AppTypography.semiBold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),

          // Cost
          Text(
            '\$${meal.estimatedCost.toStringAsFixed(2)}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: AppTypography.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        _buildActionButton(
          'Generate New Plan',
          Icons.auto_awesome,
          AppColors.primaryGreen,
          () {
            // Navigate to AI generator
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildActionButton(
          'View Shopping List',
          Icons.shopping_cart,
          AppColors.infoBlue,
          () {
            // Navigate to shopping list
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  Color _getMealTypeColor(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return AppColors.secondaryOrange;
      case MealType.lunch:
        return AppColors.infoBlue;
      case MealType.dinner:
        return AppColors.primaryGreen;
      case MealType.snack:
        return AppColors.warningYellow;
    }
  }

  IconData _getMealTypeIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
      case MealType.snack:
        return Icons.cookie;
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
