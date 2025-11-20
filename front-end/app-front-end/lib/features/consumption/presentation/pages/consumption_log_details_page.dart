import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_log.dart';
import 'edit_consumption_log_page.dart';

class ConsumptionLogDetailsPage extends StatelessWidget {
  const ConsumptionLogDetailsPage({
    super.key,
    required this.log,
  });

  final ConsumptionLog log;

  factory ConsumptionLogDetailsPage.preview() {
    return ConsumptionLogDetailsPage(log: ConsumptionLogSamples.featured);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightGray,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.neutralBlack),
        title: Text(
          log.itemName,
          style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
        ),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedEdit04,
              color: AppColors.primaryGreenDark,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EditConsumptionLogPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailsHeader(log: log),
            const SizedBox(height: AppSpacing.lg),
            _InfoTile(
              icon: Icons.scale_outlined,
              label: 'Quantity',
              value: '${log.quantity} ${log.unit}',
            ),
            const SizedBox(height: AppSpacing.md),
            _InfoTile(
              icon: Icons.calendar_today_outlined,
              label: 'Logged on',
              value: _formatDate(log.date),
            ),
            const SizedBox(height: AppSpacing.md),
            _InfoTile(
              icon: log.category.icon,
              label: 'Category',
              value: log.category.label,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Notes',
              style: AppTypography.h5.copyWith(color: AppColors.neutralBlack),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.neutralWhite,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                log.notes ?? 'No additional notes recorded for this log.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.neutralDarkGray,
                ),
              ),
            ),
          ],
        ),
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

class _DetailsHeader extends StatelessWidget {
  const _DetailsHeader({required this.log});

  final ConsumptionLog log;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreenLight,
            AppColors.primaryGreen.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.neutralWhite,
                child: Icon(
                  log.category.icon,
                  color: AppColors.primaryGreenDark,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.itemName,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.neutralWhite,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Logged ${_formatRelativeDate(log.date)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.neutralWhite.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _HeaderStat(label: 'Quantity', value: '${log.quantity} ${log.unit}'),
              const SizedBox(width: AppSpacing.md),
              _HeaderStat(label: 'Category', value: log.category.label),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRelativeDate(DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    return '${diff.inDays} days ago';
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.neutralWhite.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralWhite.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: AppTypography.h4.copyWith(
                color: AppColors.neutralWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
            ),
            child: Icon(icon, color: AppColors.primaryGreenDark),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: AppTypography.h5.copyWith(
                  color: AppColors.neutralBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
