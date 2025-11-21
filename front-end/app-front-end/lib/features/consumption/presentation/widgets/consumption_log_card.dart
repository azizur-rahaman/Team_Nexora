import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_log.dart';

/// Consumption Log Card Widget
/// Displays a consumption log entry in a card format
class ConsumptionLogCard extends StatelessWidget {
  final ConsumptionLog log;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ConsumptionLogCard({
    super.key,
    required this.log,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSpacing.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Category Badge
                  ConsumptionCategoryBadge(category: log.category),
                  const Spacer(),
                  // Actions
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      iconSize: AppSpacing.iconSM,
                      color: AppColors.primaryGreen,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onEdit,
                    ),
                  if (onEdit != null) const SizedBox(width: AppSpacing.sm),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      iconSize: AppSpacing.iconSM,
                      color: AppColors.errorRed,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onDelete,
                    ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              // Item Name
              Text(
                log.itemName,
                style: AppTypography.h5,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: AppSpacing.xs),
              
              // Quantity
              Row(
                children: [
                  const Icon(
                    Icons.scale_outlined,
                    size: AppSpacing.iconXS,
                    color: AppColors.neutralGray,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    log.formattedQuantity,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.neutralDarkGray,
                      fontWeight: AppTypography.medium,
                    ),
                  ),
                ],
              ),
              
              if (log.notes != null && log.notes!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.neutralLightGray,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.note_outlined,
                        size: AppSpacing.iconXS,
                        color: AppColors.neutralGray,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          log.notes!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.neutralDarkGray,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: AppSpacing.sm),
              
              // Time and Date
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: AppSpacing.iconXS,
                    color: AppColors.neutralGray,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    log.timeAgo,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: AppSpacing.iconXS,
                    color: AppColors.neutralGray,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    _formatDate(log.date),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
