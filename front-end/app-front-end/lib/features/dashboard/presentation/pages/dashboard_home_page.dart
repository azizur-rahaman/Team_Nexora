import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:khaddo/core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surplus/presentation/bloc/surplus_bloc.dart';
import '../../../surplus/presentation/bloc/surplus_event.dart';
import '../widgets/inventory_summary_card.dart';
import '../widgets/community_surplus_card.dart';
import '../widgets/expiring_soon_section.dart';
import '../widgets/recent_logs_section.dart';
import '../widgets/recommended_resources_section.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  @override
  void initState() {
    super.initState();
    // Load surplus items on dashboard init
    context.read<SurplusBloc>().add(const LoadSurplusItems());
  }

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
                // Inventory Summary Card (Clickable to navigate to inventory)
                GestureDetector(
                  onTap: () {
                    context.push('/inventory');
                  },
                  child: const InventorySummaryCard(),
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                // AI Insights Card - Navigation to AI analysis
                GestureDetector(
                  onTap: () {
                    context.push('/ai-insights');
                  },
                  child: _buildAIInsightsCard(),
                ),

                const SizedBox(height: AppSpacing.md),

                // Meal Planner Card - Navigation to meal planning
                GestureDetector(
                  onTap: () {
                    context.push('/meal-planner');
                  },
                  child: _buildMealPlannerCard(),
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Chatbot Card
                GestureDetector(
                  onTap: () {
                    context.push('/chatbot');
                  },
                  child: _buildChatbotCard(),
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Community Surplus Card
                const CommunitySurplusCard(),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Expiring Soon Section
                _buildSectionHeader(
                  context,
                  title: 'Expiring Soon',
                  subtitle: 'Items to use quickly',
                  onSeeAll: () {
                    context.push('/inventory');
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
                    context.push('/consumption-logs');
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
                  onSeeAll: () {
                    context.push('/resources');
                  },
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

  Widget _buildAIInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreenDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.neutralWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedAiInnovation01,
              color: AppColors.neutralWhite,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Consumption Insights',
                  style: AppTypography.h5.copyWith(
                    color: AppColors.neutralWhite,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get smart predictions & waste analysis',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralWhite.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.neutralWhite,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlannerCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.secondaryOrange,
            AppColors.secondaryOrangeLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryOrange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.neutralWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedRestaurant01,
              color: AppColors.neutralWhite,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Meal Planner',
                  style: AppTypography.h5.copyWith(
                    color: AppColors.neutralWhite,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Plan meals & save on groceries',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralWhite.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.neutralWhite,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildChatbotCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00B4D8), // Teal/Cyan
            Color(0xFF90E0EF), // Light Cyan
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B4D8).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.neutralWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppColors.neutralWhite,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ask NourishBot',
                  style: AppTypography.h5.copyWith(
                    color: AppColors.neutralWhite,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI assistant for nutrition & tips',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralWhite.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.neutralWhite,
            size: 20,
          ),
        ],
      ),
    );
  }
}
