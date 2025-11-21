import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class BudgetInputPage extends StatefulWidget {
  final List<String> dietaryPreferences;
  final int numberOfMeals;

  const BudgetInputPage({
    super.key,
    this.dietaryPreferences = const [],
    this.numberOfMeals = 3,
  });

  @override
  State<BudgetInputPage> createState() => _BudgetInputPageState();
}

class _BudgetInputPageState extends State<BudgetInputPage> {
  final TextEditingController _budgetController = TextEditingController(text: '100');
  double _currentBudget = 100.0;
  final double _minBudget = 20.0;
  final double _maxBudget = 500.0;

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
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
          'Set Your Budget',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Container(
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
                    Icons.lightbulb_outline,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Set a realistic weekly budget for groceries',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Budget Display
            Center(
              child: Column(
                children: [
                  Text(
                    'Weekly Budget',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                      border: Border.all(
                        color: AppColors.primaryGreen.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _currentBudget.toStringAsFixed(0),
                          style: AppTypography.h1.copyWith(
                            fontSize: 72,
                            color: AppColors.primaryGreen,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Budget Slider
            Text(
              'Adjust Budget',
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
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primaryGreen,
                      inactiveTrackColor: AppColors.neutralLightGray,
                      thumbColor: AppColors.primaryGreen,
                      overlayColor: AppColors.primaryGreen.withOpacity(0.2),
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                    ),
                    child: Slider(
                      value: _currentBudget,
                      min: _minBudget,
                      max: _maxBudget,
                      divisions: 96, // $5 increments
                      onChanged: (value) {
                        setState(() {
                          _currentBudget = value;
                          _budgetController.text = value.toStringAsFixed(0);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${_minBudget.toStringAsFixed(0)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                      Text(
                        '\$${_maxBudget.toStringAsFixed(0)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Manual Input
            Text(
              'Or Enter Manually',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.md),

            Container(
              decoration: BoxDecoration(
                color: AppColors.neutralWhite,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                border: Border.all(color: AppColors.primaryGreen),
              ),
              child: TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: AppTypography.h4.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: AppTypography.bold,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefix: Text(
                    '\$ ',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                  hintText: 'Enter budget',
                  hintStyle: AppTypography.h5.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
                onChanged: (value) {
                  final budget = double.tryParse(value);
                  if (budget != null && budget >= _minBudget && budget <= _maxBudget) {
                    setState(() {
                      _currentBudget = budget;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Budget Recommendations
            _buildRecommendations(),

            const SizedBox(height: AppSpacing.xl),

            // Quick Preset Buttons
            Text(
              'Quick Presets',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _buildPresetButton(50, 'Budget'),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildPresetButton(100, 'Standard'),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildPresetButton(150, 'Premium'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          border: Border(
            top: BorderSide(color: AppColors.neutralLightGray),
          ),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _generatePlan,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.neutralWhite),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Generate Meal Plan',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.neutralWhite,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    final perDay = _currentBudget / 7;
    final perMeal = perDay / widget.numberOfMeals;

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
              const Icon(Icons.calculate, color: AppColors.infoBlue, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Budget Breakdown',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.infoBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildBreakdownRow('Per Day', '\$${perDay.toStringAsFixed(2)}'),
          _buildBreakdownRow('Per Meal', '\$${perMeal.toStringAsFixed(2)}'),
          _buildBreakdownRow('Weekly Total', '\$${_currentBudget.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: AppTypography.semiBold,
              color: AppColors.infoBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(double amount, String label) {
    final isSelected = (_currentBudget - amount).abs() < 0.1;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          _currentBudget = amount;
          _budgetController.text = amount.toStringAsFixed(0);
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        side: BorderSide(
          color: isSelected ? AppColors.primaryGreen : AppColors.neutralGray,
          width: isSelected ? 2 : 1,
        ),
        backgroundColor: isSelected
            ? AppColors.primaryGreen.withOpacity(0.1)
            : AppColors.neutralWhite,
      ),
      child: Column(
        children: [
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: AppTypography.bold,
              color: isSelected ? AppColors.primaryGreen : AppColors.neutralBlack,
            ),
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  void _generatePlan() {
    // Navigate to suggested meal plan
    // context.push('/meal-planner/suggested-plan', extra: {
    //   'budget': _currentBudget,
    //   'preferences': widget.dietaryPreferences,
    //   'meals': widget.numberOfMeals,
    // });
  }
}
