import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/bot_settings.dart';
import '../../data/services/nourish_bot_service.dart';

class BotSettingsPage extends StatefulWidget {
  const BotSettingsPage({super.key});

  @override
  State<BotSettingsPage> createState() => _BotSettingsPageState();
}

class _BotSettingsPageState extends State<BotSettingsPage> {
  late BotSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = NourishBotService.getSettings();
  }

  void _updateSettings(BotSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    NourishBotService.updateSettings(newSettings);
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
          'Bot Settings',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bot Info Card
            _buildBotInfoCard(),

            const SizedBox(height: AppSpacing.xl),

            // Preferences Section
            Text(
              'Bot Preferences',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildSettingTile(
              icon: Icons.favorite_outline,
              title: 'Nutrition Focus',
              subtitle: 'Emphasize nutritional advice and healthy eating',
              value: _settings.nutritionFocus,
              onChanged: (value) {
                _updateSettings(_settings.copyWith(nutritionFocus: value));
              },
            ),

            _buildSettingTile(
              icon: Icons.lightbulb_outline,
              title: 'Leftover Ideas',
              subtitle: 'Get creative suggestions for using leftovers',
              value: _settings.leftoverIdeas,
              onChanged: (value) {
                _updateSettings(_settings.copyWith(leftoverIdeas: value));
              },
            ),

            _buildSettingTile(
              icon: Icons.delete_outline,
              title: 'Waste Reduction',
              subtitle: 'Tips and strategies to minimize food waste',
              value: _settings.wasteReduction,
              onChanged: (value) {
                _updateSettings(_settings.copyWith(wasteReduction: value));
              },
            ),

            _buildSettingTile(
              icon: Icons.restaurant_menu,
              title: 'Meal Plan Suggestions',
              subtitle: 'Receive weekly meal planning assistance',
              value: _settings.mealPlanSuggestions,
              onChanged: (value) {
                _updateSettings(_settings.copyWith(mealPlanSuggestions: value));
              },
            ),

            _buildSettingTile(
              icon: Icons.calendar_today,
              title: 'Seasonal Recommendations',
              subtitle: 'Get suggestions based on seasonal ingredients',
              value: _settings.seasonalRecommendations,
              onChanged: (value) {
                _updateSettings(_settings.copyWith(seasonalRecommendations: value));
              },
            ),

            _buildSettingTile(
              icon: Icons.savings_outlined,
              title: 'Budget Optimization',
              subtitle: 'Focus on cost-effective meal suggestions',
              value: _settings.budgetOptimization,
              onChanged: (value) {
                _updateSettings(_settings.copyWith(budgetOptimization: value));
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // Diet Mode Section
            Text(
              'Diet Mode',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Select your dietary preference for personalized suggestions',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            _buildDietModeSelector(),

            const SizedBox(height: AppSpacing.xl),

            // Notifications Section
            Text(
              'Notifications',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildNotificationSelector(),

            const SizedBox(height: AppSpacing.xl),

            // Clear Data Section
            _buildClearDataSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBotInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreenLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.neutralWhite.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppColors.neutralWhite,
              size: 40,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NourishBot',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.neutralWhite,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI-powered nutrition & waste reduction assistant',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralWhite.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.neutralLightGray),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryGreen,
        secondary: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: value
                ? AppColors.primaryGreen.withOpacity(0.1)
                : AppColors.neutralLightGray.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
          ),
          child: Icon(
            icon,
            color: value ? AppColors.primaryGreen : AppColors.neutralGray,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.neutralGray,
          ),
        ),
      ),
    );
  }

  Widget _buildDietModeSelector() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Column(
        children: DietMode.values.map((mode) {
          final isSelected = _settings.dietMode == mode;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: InkWell(
              onTap: () {
                _updateSettings(_settings.copyWith(dietMode: mode));
              },
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGreen.withOpacity(0.1)
                      : AppColors.neutralWhite,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.neutralLightGray,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getDietModeIcon(mode),
                      color: isSelected ? AppColors.primaryGreen : AppColors.neutralGray,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        mode.displayName,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: isSelected ? AppTypography.semiBold : AppTypography.regular,
                          color: isSelected ? AppColors.primaryGreen : AppColors.neutralBlack,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryGreen,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationSelector() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Column(
        children: NotificationPreference.values.map((pref) {
          final isSelected = _settings.notifications == pref;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: InkWell(
              onTap: () {
                _updateSettings(_settings.copyWith(notifications: pref));
              },
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGreen.withOpacity(0.1)
                      : AppColors.neutralWhite,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.neutralLightGray,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getNotificationIcon(pref),
                      color: isSelected ? AppColors.primaryGreen : AppColors.neutralGray,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        pref.displayName,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: isSelected ? AppTypography.semiBold : AppTypography.regular,
                          color: isSelected ? AppColors.primaryGreen : AppColors.neutralBlack,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryGreen,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClearDataSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber, color: AppColors.errorRed, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Data Management',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.errorRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Clear all chat history and reset settings to default',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () {
              _showClearDataDialog();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.errorRed),
              foregroundColor: AppColors.errorRed,
            ),
            child: const Text('Clear Chat History'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History?'),
        content: const Text(
          'This will delete all your chat messages with NourishBot. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat history cleared'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  IconData _getDietModeIcon(DietMode mode) {
    switch (mode) {
      case DietMode.balanced:
        return Icons.balance;
      case DietMode.vegetarian:
        return Icons.eco;
      case DietMode.vegan:
        return Icons.spa;
      case DietMode.lowCarb:
        return Icons.trending_down;
      case DietMode.highProtein:
        return Icons.fitness_center;
      case DietMode.ketogenic:
        return Icons.local_fire_department;
    }
  }

  IconData _getNotificationIcon(NotificationPreference pref) {
    switch (pref) {
      case NotificationPreference.all:
        return Icons.notifications_active;
      case NotificationPreference.important:
        return Icons.notifications;
      case NotificationPreference.none:
        return Icons.notifications_off;
    }
  }
}
