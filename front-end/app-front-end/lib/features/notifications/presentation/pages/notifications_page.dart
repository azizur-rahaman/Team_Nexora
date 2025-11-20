import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/notification_card.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = _getNotifications();

    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.neutralBlack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: AppTypography.h4.copyWith(
            color: AppColors.neutralBlack,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read
            },
            child: Text(
              'Mark all read',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: AppTypography.semiBold,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: AppSpacing.sm,
              ),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () {
                    // Handle notification tap
                    _handleNotificationTap(context, notification);
                  },
                  onDismiss: () {
                    // Handle notification dismiss
                    _handleNotificationDismiss(context, notification);
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedNotificationOff02,
            size: 80,
            color: AppColors.neutralGray,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No Notifications',
            style: AppTypography.h4.copyWith(
              color: AppColors.neutralBlack,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You\'re all caught up!',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(
      BuildContext context, NotificationItem notification) {
    // Navigate based on notification type
    switch (notification.type) {
      case NotificationType.expiring:
        // Navigate to expiring items
        break;
      case NotificationType.surplus:
        // Navigate to surplus management
        break;
      case NotificationType.recommendation:
        // Navigate to recommendations
        break;
      case NotificationType.general:
        // Show details
        break;
    }
  }

  void _handleNotificationDismiss(
      BuildContext context, NotificationItem notification) {
    // Remove notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification dismissed'),
        backgroundColor: AppColors.neutralDarkGray,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        ),
      ),
    );
  }

  List<NotificationItem> _getNotifications() {
    return [
      NotificationItem(
        id: '1',
        type: NotificationType.expiring,
        title: 'Items Expiring Soon',
        message: 'You have 3 items expiring within 24 hours',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        type: NotificationType.surplus,
        title: 'Surplus Alert',
        message: 'You have excess fresh vegetables. Consider sharing!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        type: NotificationType.recommendation,
        title: 'Recipe Suggestion',
        message: 'Try this delicious banana bread recipe for your overripe bananas',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      NotificationItem(
        id: '4',
        type: NotificationType.expiring,
        title: 'Milk Expires Tomorrow',
        message: 'Your milk will expire on Nov 21, 2025',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        type: NotificationType.general,
        title: 'Weekly Summary Available',
        message: 'Check out your food waste reduction progress this week',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationItem(
        id: '6',
        type: NotificationType.recommendation,
        title: 'Storage Tip',
        message: 'Store tomatoes at room temperature for better flavor',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationItem(
        id: '7',
        type: NotificationType.surplus,
        title: 'Share Your Surplus',
        message: '2 neighbors are looking for fresh produce',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }
}

enum NotificationType {
  expiring,
  surplus,
  recommendation,
  general,
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}
