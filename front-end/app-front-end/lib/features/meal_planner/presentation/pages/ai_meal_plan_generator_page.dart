import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class AIMealPlanGeneratorPage extends StatefulWidget {
  const AIMealPlanGeneratorPage({super.key});

  @override
  State<AIMealPlanGeneratorPage> createState() => _AIMealPlanGeneratorPageState();
}

class _AIMealPlanGeneratorPageState extends State<AIMealPlanGeneratorPage> {
  int _currentStep = 0;
  double _budget = 100.0;
  final List<String> _selectedPreferences = [];
  int _numberOfMeals = 3;

  final List<String> _dietaryOptions = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
    'Low-Carb',
    'High-Protein',
    'Pescatarian',
    'Halal',
  ];

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
          'AI Meal Plan Generator',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _buildStepContent(),
            ),
          ),

          // Navigation Buttons
          _buildNavigationButtons(),
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
        children: List.generate(3, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: isCompleted || isActive
                          ? AppColors.primaryGreen
                          : AppColors.neutralLightGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < 2) const SizedBox(width: 4),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildWelcomeStep();
      case 1:
        return _buildPreferencesStep();
      case 2:
        return _buildMealsStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWelcomeStep() {
    return Column(
      children: [
        // AI Robot Illustration
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
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
                  size: 120,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Let AI Plan Your Meals',
                style: AppTypography.h3.copyWith(
                  color: AppColors.primaryGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Answer a few questions and let our AI create a personalized meal plan optimized for your budget and preferences',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.neutralGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Features
        _buildFeatureCard(
          Icons.attach_money,
          'Budget-Friendly',
          'Plans tailored to your weekly budget',
          AppColors.successGreen,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildFeatureCard(
          Icons.restaurant_menu,
          'Dietary Preferences',
          'Support for various dietary needs',
          AppColors.secondaryOrange,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildFeatureCard(
          Icons.inventory_2,
          'Use Your Inventory',
          'Minimize waste by using what you have',
          AppColors.infoBlue,
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
            ),
            child: Icon(icon, color: AppColors.neutralWhite, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
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

  Widget _buildPreferencesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dietary Preferences',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Select all that apply to you',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.neutralGray,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Dietary Options
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _dietaryOptions.map((option) {
            final isSelected = _selectedPreferences.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedPreferences.add(option);
                  } else {
                    _selectedPreferences.remove(option);
                  }
                });
              },
              backgroundColor: AppColors.neutralWhite,
              selectedColor: AppColors.primaryGreen.withOpacity(0.2),
              checkmarkColor: AppColors.primaryGreen,
              side: BorderSide(
                color: isSelected ? AppColors.primaryGreen : AppColors.neutralLightGray,
              ),
              labelStyle: AppTypography.bodyMedium.copyWith(
                color: isSelected ? AppColors.primaryGreen : AppColors.neutralBlack,
                fontWeight: isSelected ? AppTypography.semiBold : AppTypography.regular,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Info card
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.infoBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            border: Border.all(color: AppColors.infoBlue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.infoBlue, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'You can skip this step if you don\'t have any dietary restrictions',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.infoBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Meals',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'How many meals per day?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.neutralGray,
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Meal Selection Cards
        _buildMealOptionCard(
          '2 Meals',
          'Breakfast & Dinner',
          Icons.free_breakfast,
          2,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMealOptionCard(
          '3 Meals',
          'Breakfast, Lunch & Dinner',
          Icons.restaurant_menu,
          3,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMealOptionCard(
          '4 Meals',
          'All meals + Snacks',
          Icons.lunch_dining,
          4,
        ),

        const SizedBox(height: AppSpacing.xl),

        // Summary Card
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Preferences',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildSummaryRow('Budget', '\$${_budget.toStringAsFixed(2)}/week'),
              _buildSummaryRow(
                'Diet',
                _selectedPreferences.isEmpty
                    ? 'No restrictions'
                    : _selectedPreferences.join(', '),
              ),
              _buildSummaryRow('Meals', '$_numberOfMeals per day'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealOptionCard(String title, String subtitle, IconData icon, int meals) {
    final isSelected = _numberOfMeals == meals;

    return InkWell(
      onTap: () {
        setState(() {
          _numberOfMeals = meals;
        });
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withOpacity(0.1)
              : AppColors.neutralWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.neutralLightGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.neutralLightGray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.neutralWhite : AppColors.neutralGray,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: AppTypography.semiBold,
                      color: isSelected ? AppColors.primaryGreen : AppColors.neutralBlack,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryGreen,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: AppTypography.semiBold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        border: Border(
          top: BorderSide(color: AppColors.neutralLightGray),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  side: const BorderSide(color: AppColors.neutralGray),
                ),
                child: Text(
                  'Back',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: AppSpacing.md),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleNextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: Text(
                _currentStep == 2 ? 'Set Budget' : 'Next',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.neutralWhite,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Navigate to budget input
      // context.push('/meal-planner/budget-input');
    }
  }
}
