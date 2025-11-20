import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../pages/notifications_page.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: _buildDismissBackground(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        child: Container(
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppColors.neutralWhite
                : AppColors.primaryGreenLight.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            border: Border.all(
              color: AppColors.neutralGray.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                _buildNotificationIcon(),
                const SizedBox(width: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and unread indicator
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: AppTypography.h6.copyWith(
                                color: AppColors.neutralBlack,
                                fontWeight: notification.isRead
                                    ? AppTypography.medium
                                    : AppTypography.semiBold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),

                      // Message
                      Text(
                        notification.message,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.neutralDarkGray,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Timestamp
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    final iconData = _getIconForType();
    final iconColor = _getColorForType();

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: HugeIcon(
        icon: iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.errorRed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      child: const HugeIcon(
        icon: HugeIcons.strokeRoundedDelete02,
        color: AppColors.neutralWhite,
        size: 24,
      ),
    );
  }

  dynamic _getIconForType() {
    switch (notification.type) {
      case NotificationType.expiring:
        return HugeIcons.strokeRoundedAlertCircle;
      case NotificationType.surplus:
        return HugeIcons.strokeRoundedShare08;
      case NotificationType.recommendation:
        return HugeIcons.strokeRoundedIdea;
      case NotificationType.general:
        return HugeIcons.strokeRoundedNotification02;
    }
  }

  Color _getColorForType() {
    switch (notification.type) {
      case NotificationType.expiring:
        return AppColors.warningYellow;
      case NotificationType.surplus:
        return AppColors.secondaryOrange;
      case NotificationType.recommendation:
        return AppColors.infoBlue;
      case NotificationType.general:
        return AppColors.primaryGreen;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
