import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/inventory_summary_card.dart';
import '../widgets/expiring_soon_section.dart';
import '../widgets/recent_logs_section.dart';
import '../widgets/recommended_resources_section.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: AppTypography.h4.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Welcome back, User!',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedNotification02,
              color: AppColors.neutralBlack,
            ),
            onPressed: () {
              context.push('/notifications');
            },
          ),
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: AppColors.neutralBlack,
            ),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh logic
          await Future.delayed(const Duration(seconds: 1));
        },
        color: AppColors.primaryGreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Inventory Summary Card
                const InventorySummaryCard(),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Expiring Soon Section
                _buildSectionHeader(
                  context,
                  title: 'Expiring Soon',
                  subtitle: 'Items to use quickly',
                  onSeeAll: () {
                    // Navigate to expiring items
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                const ExpiringSoonSection(),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Recent Logs Section
                _buildSectionHeader(
                  context,
                  title: 'Recent Logs',
                  subtitle: 'Your latest activities',
                  onSeeAll: () {
                    // Navigate to all logs
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                const RecentLogsSection(),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Recommended Resources Section
                _buildSectionHeader(
                  context,
                  title: 'Recommended Resources',
                  subtitle: 'Tips to reduce food waste',
                ),
                const SizedBox(height: AppSpacing.sm),
                const RecommendedResourcesSection(),
                
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    String? subtitle,
    VoidCallback? onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.h5.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
            ],
          ],
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  'See All',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
                const SizedBox(width: 4),
                HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  size: 12,
                  color: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
