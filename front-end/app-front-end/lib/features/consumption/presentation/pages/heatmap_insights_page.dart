import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_log.dart';
import '../../data/services/sample_consumption_data.dart';

class HeatmapInsightsPage extends StatefulWidget {
  const HeatmapInsightsPage({super.key});

  @override
  State<HeatmapInsightsPage> createState() => _HeatmapInsightsPageState();
}

class _HeatmapInsightsPageState extends State<HeatmapInsightsPage> {
  late List<ConsumptionLog> _logs;
  final int _daysToShow = 28; // 4 weeks

  @override
  void initState() {
    super.initState();
    _logs = SampleConsumptionData.getLogs();
  }

  @override
  Widget build(BuildContext context) {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: _daysToShow - 1));

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
          'Usage Frequency',
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
              'Heatmap Insights',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Color-coded visualization of usage frequency',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Heatmap Grid
            _buildHeatmapGrid(startDate, endDate),

            const SizedBox(height: AppSpacing.lg),

            // Color Legend
            _buildColorLegend(),

            const SizedBox(height: AppSpacing.xl),

            // Usage Summary
            Text(
              'Usage Summary',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildUsageSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapGrid(DateTime startDate, DateTime endDate) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.neutralLightGray),
      ),
      child: Column(
        children: [
          // Day headers
          Row(
            children: [
              const SizedBox(width: 32), // Space for date label
              ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: AppTypography.caption.copyWith(
                        fontSize: 10,
                        fontWeight: AppTypography.bold,
                        color: AppColors.neutralGray,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Heatmap rows
          ..._buildWeekRows(startDate, endDate),
        ],
      ),
    );
  }

  List<Widget> _buildWeekRows(DateTime startDate, DateTime endDate) {
    final rows = <Widget>[];
    DateTime current = startDate;

    while (current.isBefore(endDate.add(const Duration(days: 1)))) {
      final weekStart = current;
      final weekDays = <DateTime>[];

      // Get 7 days for this week
      for (int i = 0; i < 7; i++) {
        if (current.isBefore(endDate.add(const Duration(days: 1)))) {
          weekDays.add(current);
          current = current.add(const Duration(days: 1));
        }
      }

      rows.add(_buildWeekRow(weekStart, weekDays));
    }

    return rows;
  }

  Widget _buildWeekRow(DateTime weekStart, List<DateTime> days) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          // Week start date
          SizedBox(
            width: 32,
            child: Text(
              '${weekStart.month}/${weekStart.day}',
              style: AppTypography.caption.copyWith(
                fontSize: 9,
                color: AppColors.neutralGray,
              ),
            ),
          ),

          // Day cells
          ...days.map((date) => _buildDayCell(date)),
        ],
      ),
    );
  }

  Widget _buildDayCell(DateTime date) {
    // Count logs for this day
    final dayLogs = _logs.where((log) {
      return log.date.year == date.year &&
          log.date.month == date.month &&
          log.date.day == date.day;
    }).toList();

    final count = dayLogs.length;
    final color = _getHeatmapColor(count);
    final isToday = _isToday(date);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: AspectRatio(
          aspectRatio: 1,
          child: Tooltip(
            message: '${date.month}/${date.day}: $count logs',
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: isToday
                    ? Border.all(color: AppColors.primaryGreenDark, width: 2)
                    : null,
              ),
              child: count > 0
                  ? Center(
                      child: Text(
                        '$count',
                        style: AppTypography.caption.copyWith(
                          fontSize: 8,
                          fontWeight: AppTypography.bold,
                          color: count >= 3
                              ? AppColors.neutralWhite
                              : AppColors.neutralBlack,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Color _getHeatmapColor(int count) {
    if (count == 0) return AppColors.neutralLightGray;
    if (count == 1) return AppColors.primaryGreenLight.withOpacity(0.3);
    if (count == 2) return AppColors.primaryGreenLight.withOpacity(0.6);
    if (count == 3) return AppColors.primaryGreen.withOpacity(0.8);
    return AppColors.primaryGreen;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _buildColorLegend() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequency Legend',
            style: AppTypography.bodySmall.copyWith(
              fontWeight: AppTypography.semiBold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem('None', _getHeatmapColor(0)),
              _buildLegendItem('Low (1)', _getHeatmapColor(1)),
              _buildLegendItem('Medium (2)', _getHeatmapColor(2)),
              _buildLegendItem('High (3)', _getHeatmapColor(3)),
              _buildLegendItem('Very High (4+)', _getHeatmapColor(4)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: 9,
            color: AppColors.neutralGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUsageSummary() {
    final totalLogs = _logs.length;
    final activeDays = _logs.map((log) {
      return '${log.date.year}-${log.date.month}-${log.date.day}';
    }).toSet().length;
    final avgPerDay = totalLogs / _daysToShow;

    return Column(
      children: [
        _buildSummaryCard(
          'Total Logs',
          '$totalLogs',
          Icons.list_alt,
          AppColors.primaryGreen,
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildSummaryCard(
          'Active Days',
          '$activeDays / $_daysToShow',
          Icons.calendar_today,
          AppColors.infoBlue,
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildSummaryCard(
          'Average Per Day',
          avgPerDay.toStringAsFixed(1),
          Icons.show_chart,
          AppColors.secondaryOrange,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
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
            child: Icon(icon, color: AppColors.neutralWhite, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralDarkGray,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.h4.copyWith(
              color: color,
              fontWeight: AppTypography.bold,
            ),
          ),
        ],
      ),
    );
  }
}
