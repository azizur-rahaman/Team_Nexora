import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_log.dart';

class ConsumptionLogsListPage extends StatelessWidget {
  const ConsumptionLogsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = ConsumptionLogSamples.logs;
    return Scaffold(
      backgroundColor: AppColors.neutralLightGray,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        title: Text(
          'Consumption Logs',
          style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
        ),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedFilter,
              color: AppColors.primaryGreenDark,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Filter controls coming soon',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.neutralWhite),
                  ),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: logs.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final log = logs[index];
          return _ConsumptionLogCard(log: log);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.neutralWhite,
        icon: const Icon(Icons.add),
        label: const Text('Add Log'),
      ),
    );
  }
}

class _ConsumptionLogCard extends StatelessWidget {
  const _ConsumptionLogCard({required this.log});

  final ConsumptionLog log;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  log.itemName,
                  style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
                ),
              ),
              ConsumptionCategoryBadge(category: log.category),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.scale_outlined, color: AppColors.primaryGreenDark, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${log.quantity.toStringAsFixed(log.quantity.truncateToDouble() == log.quantity ? 0 : 1)} ${log.unit}',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(width: AppSpacing.lg),
              Icon(Icons.calendar_today_outlined, color: AppColors.primaryGreenDark, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _formatDate(log.date),
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
          if (log.notes != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              log.notes!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.neutralDarkGray),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthLabel(date.month)} '
        '${date.year}';
  }

  String _monthLabel(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
