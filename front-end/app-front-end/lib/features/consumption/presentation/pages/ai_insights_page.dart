import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/services/consumption_analyzer_service.dart';
import '../../data/services/sample_consumption_data.dart';
import '../../domain/entities/consumption_trend.dart';
import '../widgets/consumption_trend_card.dart';
import '../widgets/waste_prediction_card.dart';
import '../widgets/nutrition_balance_card.dart';
import '../widgets/ai_insights/consumption_alerts_card.dart';

class AIInsightsPage extends StatefulWidget {
  const AIInsightsPage({super.key});

  @override
  State<AIInsightsPage> createState() => _AIInsightsPageState();
}

class _AIInsightsPageState extends State<AIInsightsPage> {
  final _analyzerService = ConsumptionAnalyzerService();
  late List<ConsumptionTrend> _trends;
  late List<ConsumptionAlert> _alerts;
  late List<WastePrediction> _wastePredictions;
  late NutritionBalance _nutritionBalance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final logs = SampleConsumptionData.getLogs();
    
    setState(() {
      _trends = _analyzerService.analyzeWeeklyTrends(logs);
      _alerts = _analyzerService.detectConsumptionAlerts(logs);
      _wastePredictions = _analyzerService.predictWaste(logs);
      _nutritionBalance = _analyzerService.analyzeNutritionBalance(logs);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightGray,
      appBar: AppBar(
        title: Text(
          'AI Insights',
          style: AppTypography.h2.copyWith(color: AppColors.neutralWhite),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.neutralWhite),
            onPressed: _loadAnalytics,
            tooltip: 'Refresh insights',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : RefreshIndicator(
              onRefresh: _loadAnalytics,
              color: AppColors.primaryGreen,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Alerts Section
                    if (_alerts.isNotEmpty) ...[
                      _buildSectionTitle('Active Alerts', Icons.notification_important),
                      const SizedBox(height: AppSpacing.sm),
                      ConsumptionAlertsCard(alerts: _alerts),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    
                    // Waste Predictions Section
                    _buildSectionTitle('Waste Predictions', Icons.delete_outline),
                    const SizedBox(height: AppSpacing.sm),
                    WastePredictionCard(predictions: _wastePredictions),
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Weekly Trends Section
                    _buildSectionTitle('Weekly Trends', Icons.trending_up),
                    const SizedBox(height: AppSpacing.sm),
                    ConsumptionTrendCard(trends: _trends),
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Nutrition Balance Section
                    _buildSectionTitle('Nutrition Balance', Icons.pie_chart),
                    const SizedBox(height: AppSpacing.sm),
                    NutritionBalanceCard(nutritionBalance: _nutritionBalance),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreenDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.neutralWhite,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI-Powered Analysis',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.neutralWhite,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Personalized insights from your consumption patterns',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.neutralWhite.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildStat('${_trends.length}', 'Trends'),
              const SizedBox(width: AppSpacing.md),
              _buildStat('${_wastePredictions.length}', 'Predictions'),
              const SizedBox(width: AppSpacing.md),
              _buildStat('${_alerts.length}', 'Alerts'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.neutralWhite.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.h2.copyWith(
                color: AppColors.neutralWhite,
                fontWeight: AppTypography.bold,
              ),
            ),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralWhite.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 24),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: AppTypography.h3.copyWith(
            color: AppColors.neutralBlack,
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ],
    );
  }
}
