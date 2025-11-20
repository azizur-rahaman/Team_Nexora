import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.neutralWhite,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.neutralGray,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        selectedLabelStyle: AppTypography.caption.copyWith(
          fontWeight: AppTypography.semiBold,
        ),
        unselectedLabelStyle: AppTypography.caption,
        items: [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome01,
              color: _calculateSelectedIndex(context) == 0
                  ? AppColors.primaryGreen
                  : AppColors.neutralGray,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: _calculateSelectedIndex(context) == 1
                  ? AppColors.primaryGreen
                  : AppColors.neutralGray,
              size: 24,
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedAdd01,
                  color: AppColors.neutralWhite,
                  size: 18.sp,
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedGift,
              color: _calculateSelectedIndex(context) == 3
                  ? AppColors.primaryGreen
                  : AppColors.neutralGray,
              size: 24,
            ),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: _calculateSelectedIndex(context) == 4
                  ? AppColors.primaryGreen
                  : AppColors.neutralGray,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/explore')) {
      return 1;
    }
    if (location.startsWith('/rewards')) {
      return 3;
    }
    if (location.startsWith('/profile')) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/explore');
        break;
      case 2:
        // Center FAB - show add item bottom sheet
        _showAddItemBottomSheet(context);
        break;
      case 3:
        context.go('/rewards');
        break;
      case 4:
        context.go('/profile');
        break;
    }
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
                icon: HugeIcons.strokeRoundedRestaurant02,
                title: 'Log Food Consumption',
                subtitle: 'Track what you ate',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/consumption-logs/add');
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
