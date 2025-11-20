import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class RecentLogsSection extends StatelessWidget {
  const RecentLogsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final recentLogs = [
      LogItem(
        title: 'Added Organic Apples',
        subtitle: '2 kg • Expires in 7 days',
        time: '2 hours ago',
        icon: Icons.add_circle_outline,
        iconColor: AppColors.successGreen,
      ),
      LogItem(
        title: 'Used Fresh Tomatoes',
        subtitle: '500g • Made pasta sauce',
        time: '5 hours ago',
        icon: Icons.check_circle_outline,
        iconColor: AppColors.primaryGreen,
      ),
      LogItem(
        title: 'Expired Bread',
        subtitle: '1 loaf • Moved to compost',
        time: 'Yesterday',
        icon: Icons.warning_amber_outlined,
        iconColor: AppColors.warningYellow,
      ),
      LogItem(
        title: 'Shared with Neighbor',
        subtitle: 'Extra vegetables',
        time: '2 days ago',
        icon: Icons.volunteer_activism_outlined,
        iconColor: AppColors.infoBlue,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentLogs.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: AppColors.neutralGray.withOpacity(0.2),
        ),
        itemBuilder: (context, index) {
          final log = recentLogs[index];
          return _buildLogItem(log);
        },
      ),
    );
  }

  Widget _buildLogItem(LogItem log) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: log.iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        ),
        child: Icon(
          log.icon,
          color: log.iconColor,
          size: 20,
        ),
      ),
      title: Text(
        log.title,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutralBlack,
          fontWeight: AppTypography.semiBold,
        ),
      ),
      subtitle: Text(
        log.subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.neutralGray,
        ),
      ),
      trailing: Text(
        log.time,
        style: AppTypography.caption.copyWith(
          color: AppColors.neutralGray,
        ),
      ),
    );
  }
}

class LogItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;

  LogItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}
