import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/inventory_summary_card.dart';
import '../widgets/expiring_soon_section.dart';
import '../widgets/recent_logs_section.dart';
import '../widgets/recommended_resources_section.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: AppColors.neutralBlack,
            ),
            onPressed: () {
              // Navigate to profile
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add item
          _showAddItemBottomSheet(context);
        },
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.neutralWhite,
        elevation: AppSpacing.elevationMedium,
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01,
          color: AppColors.neutralWhite,
        ),
        label: Text(
          'Add Item',
          style: AppTypography.button,
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

  void _showAddItemBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.neutralWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLG),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              Text(
                'Add New Item',
                style: AppTypography.h4,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Add options
              _buildAddOption(
                context,
                icon: HugeIcons.strokeRoundedQrCode,
                title: 'Scan Barcode',
                subtitle: 'Scan product barcode',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to barcode scanner
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildAddOption(
                context,
                icon: HugeIcons.strokeRoundedEdit02,
                title: 'Manual Entry',
                subtitle: 'Enter item details manually',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to manual entry
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildAddOption(
                context,
                icon: HugeIcons.strokeRoundedCamera01,
                title: 'Take Photo',
                subtitle: 'Capture receipt or item',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to camera
                },
              ),
              
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddOption(
    BuildContext context, {
    required dynamic icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.neutralLightGray,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: HugeIcon(
                icon: icon,
                color: AppColors.primaryGreen,
                size: AppSpacing.iconMD,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h6.copyWith(
                      color: AppColors.neutralBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              size: AppSpacing.iconSM,
              color: AppColors.neutralGray,
            ),
          ],
        ),
      ),
    );
  }
}
