import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_log.dart';
import '../../data/services/sample_consumption_data.dart';
import '../widgets/category_filter_chip.dart';

class WeeklyConsumptionHeatmapPage extends StatefulWidget {
  const WeeklyConsumptionHeatmapPage({super.key});

  @override
  State<WeeklyConsumptionHeatmapPage> createState() => _WeeklyConsumptionHeatmapPageState();
}

class _WeeklyConsumptionHeatmapPageState extends State<WeeklyConsumptionHeatmapPage> {
  ConsumptionCategory? _selectedCategory;
  late List<ConsumptionLog> _logs;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _logs = SampleConsumptionData.getLogs();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(const Duration(days: 27)); // 4 weeks
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _selectedCategory == null
        ? _logs
        : _logs.where((log) => log.category == _selectedCategory).toList();

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
          'Weekly Consumption',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Category',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralGray,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(null, 'All', filteredLogs.length),
                      const SizedBox(width: AppSpacing.sm),
                      ...ConsumptionCategory.values.map((category) {
                        final count = _logs.where((log) => log.category == category).length;
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: _buildFilterChip(category, category.label, count),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Heatmap Calendar Grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consumption Heatmap',
                    style: AppTypography.h4,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Color intensity shows consumption frequency',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildHeatmapGrid(filteredLogs),
                  const SizedBox(height: AppSpacing.lg),
                  _buildLegend(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(ConsumptionCategory? category, String label, int count) {
    final isSelected = _selectedCategory == category;
    
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.neutralWhite.withOpacity(0.3) : AppColors.neutralLightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: AppTypography.caption.copyWith(
                fontSize: 10,
                color: isSelected ? AppColors.neutralWhite : AppColors.neutralGray,
              ),
            ),
          ),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
      selectedColor: category?.accentColor ?? AppColors.primaryGreen,
      checkmarkColor: AppColors.neutralWhite,
      backgroundColor: AppColors.neutralLightGray,
      labelStyle: AppTypography.bodySmall.copyWith(
        color: isSelected ? AppColors.neutralWhite : AppColors.neutralBlack,
        fontWeight: isSelected ? AppTypography.semiBold : AppTypography.regular,
      ),
    );
  }

  Widget _buildHeatmapGrid(List<ConsumptionLog> logs) {
    // Create 4 weeks x 7 days grid
    final weeks = <List<DateTime>>[];
    DateTime current = _startDate;
    
    for (int week = 0; week < 4; week++) {
      final weekDays = <DateTime>[];
      for (int day = 0; day < 7; day++) {
        weekDays.add(current);
        current = current.add(const Duration(days: 1));
      }
      weeks.add(weekDays);
    }

    return Column(
      children: [
        // Day labels
        Row(
          children: [
            const SizedBox(width: 40), // Space for week label
            ...['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.neutralGray,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ),
            )),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        
        // Heatmap rows
        ...weeks.asMap().entries.map((entry) {
          final weekIndex = entry.key;
          final weekDays = entry.value;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    'W${weekIndex + 1}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.neutralGray,
                      fontWeight: AppTypography.medium,
                    ),
                  ),
                ),
                ...weekDays.map((date) => _buildHeatmapCell(date, logs)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHeatmapCell(DateTime date, List<ConsumptionLog> logs) {
    final dayLogs = logs.where((log) {
      return log.date.year == date.year &&
             log.date.month == date.month &&
             log.date.day == date.day;
    }).toList();

    final count = dayLogs.length;
    final intensity = count > 0 ? (count / 5).clamp(0.2, 1.0) : 0.0;
    
    final baseColor = _selectedCategory?.accentColor ?? AppColors.primaryGreen;
    final cellColor = intensity > 0 
        ? baseColor.withOpacity(intensity)
        : AppColors.neutralLightGray;

    final isToday = date.year == DateTime.now().year &&
                    date.month == DateTime.now().month &&
                    date.day == DateTime.now().day;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: cellColor,
              borderRadius: BorderRadius.circular(4),
              border: isToday 
                  ? Border.all(color: AppColors.primaryGreenDark, width: 2)
                  : null,
            ),
            child: Center(
              child: count > 0
                  ? Text(
                      '$count',
                      style: AppTypography.caption.copyWith(
                        fontSize: 9,
                        color: intensity > 0.5 ? AppColors.neutralWhite : AppColors.neutralBlack,
                        fontWeight: AppTypography.bold,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: Row(
        children: [
          Text(
            'Less',
            style: AppTypography.caption.copyWith(color: AppColors.neutralGray),
          ),
          const SizedBox(width: AppSpacing.sm),
          ...[0.0, 0.25, 0.5, 0.75, 1.0].map((intensity) {
            final color = (_selectedCategory?.accentColor ?? AppColors.primaryGreen)
                .withOpacity(intensity > 0 ? intensity : 0.1);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: intensity == 0 ? AppColors.neutralLightGray : color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'More',
            style: AppTypography.caption.copyWith(color: AppColors.neutralGray),
          ),
        ],
      ),
    );
  }
}
