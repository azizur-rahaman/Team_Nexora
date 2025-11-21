import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_trend.dart';

class WastePredictionScreen extends StatelessWidget {
  const WastePredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock waste predictions
    final predictions = [
      _WasteItem('Oat Milk', 500, 'ml', 0.85, WasteRiskLevel.critical),
      _WasteItem('Strawberries', 200, 'g', 0.72, WasteRiskLevel.high),
      _WasteItem('Brown Rice', 300, 'g', 0.58, WasteRiskLevel.medium),
      _WasteItem('Almond Butter', 150, 'g', 0.45, WasteRiskLevel.medium),
      _WasteItem('Spinach', 100, 'g', 0.32, WasteRiskLevel.low),
      _WasteItem('Blueberries', 150, 'g', 0.28, WasteRiskLevel.low),
    ];

    // Sort by probability (high to low)
    predictions.sort((a, b) => b.probability.compareTo(a.probability));

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
          'Waste Predictions',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Stats
          Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.errorRed.withOpacity(0.1),
                  AppColors.warningYellow.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.delete_outline,
                  color: AppColors.errorRed,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${predictions.length} Items at Risk',
                        style: AppTypography.h4,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Predicted waste in next 3-7 days',
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

          // Risk Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Critical', AppColors.errorRed),
                _buildLegendItem('High', AppColors.secondaryOrange),
                _buildLegendItem('Medium', AppColors.warningYellow),
                _buildLegendItem('Low', AppColors.successGreen),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.md),

          // Predictions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                final item = predictions[index];
                return _buildPredictionCard(item, index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: 10,
            color: AppColors.neutralGray,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionCard(_WasteItem item, int rank) {
    final isHighRisk = item.riskLevel == WasteRiskLevel.critical || 
                       item.riskLevel == WasteRiskLevel.high;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: isHighRisk 
              ? _getRiskColor(item.riskLevel).withOpacity(0.3)
              : AppColors.neutralLightGray,
          width: isHighRisk ? 2 : 1,
        ),
        boxShadow: isHighRisk
            ? [
                BoxShadow(
                  color: _getRiskColor(item.riskLevel).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getRiskColor(item.riskLevel).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: AppTypography.bold,
                  color: _getRiskColor(item.riskLevel),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: AppSpacing.md),
          
          // Item Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estimated waste: ${item.quantity} ${item.unit}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Probability Bar
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Waste Probability',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                  color: AppColors.neutralGray,
                                ),
                              ),
                              Text(
                                '${(item.probability * 100).toStringAsFixed(0)}%',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                  fontWeight: AppTypography.bold,
                                  color: _getRiskColor(item.riskLevel),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: item.probability,
                              backgroundColor: AppColors.neutralLightGray,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getRiskColor(item.riskLevel),
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Risk Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _getRiskColor(item.riskLevel),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
            ),
            child: Text(
              _getRiskLabel(item.riskLevel),
              style: AppTypography.caption.copyWith(
                color: AppColors.neutralWhite,
                fontWeight: AppTypography.bold,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(WasteRiskLevel level) {
    switch (level) {
      case WasteRiskLevel.critical:
        return AppColors.errorRed;
      case WasteRiskLevel.high:
        return AppColors.secondaryOrange;
      case WasteRiskLevel.medium:
        return AppColors.warningYellow;
      case WasteRiskLevel.low:
        return AppColors.successGreen;
    }
  }

  String _getRiskLabel(WasteRiskLevel level) {
    switch (level) {
      case WasteRiskLevel.critical:
        return 'CRITICAL';
      case WasteRiskLevel.high:
        return 'HIGH';
      case WasteRiskLevel.medium:
        return 'MEDIUM';
      case WasteRiskLevel.low:
        return 'LOW';
    }
  }
}

class _WasteItem {
  final String name;
  final double quantity;
  final String unit;
  final double probability; // 0.0 to 1.0
  final WasteRiskLevel riskLevel;

  _WasteItem(
    this.name,
    this.quantity,
    this.unit,
    this.probability,
    this.riskLevel,
  );
}
