import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:khaddo/core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../consumption/presentation/pages/add_consumption_log_page.dart';
import '../../../consumption/presentation/pages/consumption_logs_list_page.dart';
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
        leading: Container(
          margin: EdgeInsets.only(left: 10.w),
          child: CircleAvatar(
            backgroundColor: AppColors.neutralGray.withOpacity(0.2),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: AppColors.neutralBlack,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AppConstants.appLogoImage, height: 50.h),
            // Text(
            //   'Dashboard',
            //   style: AppTypography.h4.copyWith(
            //     color: AppColors.neutralBlack,
            //   ),
            // ),
            // const SizedBox(height: 2),
            // Text(
            //   'Welcome back, User!',
            //   style: AppTypography.bodySmall.copyWith(
            //     color: AppColors.neutralGray,
            //   ),
            // ),
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
          SizedBox(width: 8.w),
          // IconButton(
          //   icon: const HugeIcon(
          //     icon: HugeIcons.strokeRoundedUser,
          //     color: AppColors.neutralBlack,
          //   ),
          //   onPressed: () {
          //     context.go('/profile');
          //   },
          // ),
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
                SizedBox(height: AppSpacing.md),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ConsumptionLogsListPage(),
                      ),
                    );
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddConsumptionLogPage(),
            ),
          );
        },
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.neutralWhite,
        icon: const Icon(Icons.add),
        label: const Text('Log Food'),
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
