import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class WasteEstimationScreen extends StatelessWidget {
  const WasteEstimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final weeklyWasteGrams = 450.0;
    final weeklyWasteMoney = 12.50;
    final monthlyWasteGrams = 1850.0;
    final monthlyWasteMoney = 52.30;
    
    // Trend data for the last 4 weeks
    final weeklyTrend = [380.0, 420.0, 390.0, 450.0];
    final maxValue = weeklyTrend.reduce((a, b) => a > b ? a : b);

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
          'Waste Estimation',
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
              'Track Your Food Waste',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Estimated waste in grams and money',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Weekly Waste Card
            _buildWasteCard(
              title: 'Weekly Waste',
              grams: weeklyWasteGrams,
              money: weeklyWasteMoney,
              color: AppColors.warningYellow,
              icon: Icons.calendar_today,
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Monthly Waste Card
            _buildWasteCard(
              title: 'Monthly Waste',
              grams: monthlyWasteGrams,
              money: monthlyWasteMoney,
              color: AppColors.secondaryOrange,
              icon: Icons.calendar_month,
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Waste Trend Chart
            Text(
              'Waste Trend (Last 4 Weeks)',
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
                  // Line Chart
                  SizedBox(
                    height: 200,
                    child: CustomPaint(
                      size: const Size(double.infinity, 200),
                      painter: LineChartPainter(weeklyTrend, maxValue),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Week Labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeekLabel('W1', '380g'),
                      _buildWeekLabel('W2', '420g'),
                      _buildWeekLabel('W3', '390g'),
                      _buildWeekLabel('W4', '450g'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Breakdown by Category
            Text(
              'Waste Breakdown',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.md),
            
            _buildCategoryBreakdown('Fruits', 180, 0.40, AppColors.secondaryOrangeLight),
            _buildCategoryBreakdown('Vegetables', 135, 0.30, AppColors.successGreen),
            _buildCategoryBreakdown('Dairy', 90, 0.20, AppColors.primaryGreenLight),
            _buildCategoryBreakdown('Grains', 45, 0.10, AppColors.infoBlue),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Tips Section
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
                  Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.primaryGreen,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Reduce Waste Tips',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: AppTypography.semiBold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...[
                    'Store fruits properly to extend freshness',
                    'Plan meals ahead to avoid over-purchasing',
                    'Use the freezer for items nearing expiration',
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
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteCard({
    required String title,
    required double grams,
    required double money,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: AppTypography.h5.copyWith(
                  color: AppColors.neutralDarkGray,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Big Numbers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${grams.toStringAsFixed(0)}g',
                      style: AppTypography.h1.copyWith(
                        fontSize: 36,
                        color: color,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Weight',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.neutralGray,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                width: 1,
                height: 60,
                color: AppColors.neutralLightGray,
              ),
              
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '\$${money.toStringAsFixed(2)}',
                      style: AppTypography.h1.copyWith(
                        fontSize: 36,
                        color: color,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Value',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.neutralGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekLabel(String week, String value) {
    return Column(
      children: [
        Text(
          week,
          style: AppTypography.caption.copyWith(
            fontWeight: AppTypography.bold,
            color: AppColors.neutralBlack,
          ),
        ),
        Text(
          value,
          style: AppTypography.caption.copyWith(
            fontSize: 10,
            color: AppColors.neutralGray,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(String category, double grams, double percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: AppTypography.semiBold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: AppColors.neutralLightGray,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${grams.toStringAsFixed(0)}g',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: AppTypography.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> values;
  final double maxValue;

  LineChartPainter(this.values, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondaryOrange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppColors.secondaryOrange.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    
    final stepX = size.width / (values.length - 1);
    
    // Start fill path from bottom
    fillPath.moveTo(0, size.height);
    
    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxValue * size.height * 0.8);
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      
      // Draw dots
      canvas.drawCircle(Offset(x, y), 6, Paint()..color = AppColors.secondaryOrange);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = AppColors.neutralWhite);
    }
    
    // Close fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
