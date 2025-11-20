import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightGray,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 200.h,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.neutralWhite,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryGreen,
                      AppColors.primaryGreen.withOpacity(0.85),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),
                      // Avatar with subtle glow
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neutralWhite.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundColor: AppColors.neutralWhite,
                          child: CircleAvatar(
                            radius: 47.r,
                            backgroundColor: AppColors.primaryGreenLight,
                            child: Text(
                              'AR',
                              style: AppTypography.h2.copyWith(
                                color: AppColors.neutralWhite,
                                fontWeight: AppTypography.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Azizur Rahman',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.neutralWhite,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'azizur@example.com',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.neutralWhite.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: IconButton(
                  onPressed: () {
                    // TODO: Navigate to edit profile
                  },
                  icon: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.neutralWhite.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedEdit02,
                      color: AppColors.neutralWhite,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  
                  // Personal Information Section
                  _buildSectionTitle('Personal Information'),
                  SizedBox(height: 12.h),
                  
                  _buildInfoCard(
                    icon: HugeIcons.strokeRoundedUser,
                    title: 'Full Name',
                    value: 'Azizur Rahman',
                    iconColor: AppColors.primaryGreen,
                  ),
                  SizedBox(height: 12.h),
                  
                  _buildInfoCard(
                    icon: HugeIcons.strokeRoundedMail01,
                    title: 'Email',
                    value: 'azizur@example.com',
                    iconColor: AppColors.infoBlue,
                  ),
                  SizedBox(height: 12.h),
                  
                  _buildInfoCard(
                    icon: HugeIcons.strokeRoundedSmartPhone01,
                    title: 'Phone Number',
                    value: '+880 1234 567890',
                    iconColor: AppColors.secondaryOrange,
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Household & Preferences Section
                  _buildSectionTitle('Household & Preferences'),
                  SizedBox(height: 12.h),
                  
                  _buildInfoCard(
                    icon: HugeIcons.strokeRoundedHome01,
                    title: 'Household Size',
                    value: '4 members',
                    iconColor: AppColors.primaryGreen,
                  ),
                  SizedBox(height: 12.h),
                  
                  _buildInfoCard(
                    icon: HugeIcons.strokeRoundedRestaurant02,
                    title: 'Dietary Preferences',
                    value: 'Vegetarian, Gluten-Free',
                    iconColor: AppColors.successGreen,
                  ),
                  SizedBox(height: 12.h),
                  
                  _buildInfoCard(
                    icon: HugeIcons.strokeRoundedLeaf01,
                    title: 'Sustainability Goal',
                    value: 'Reduce waste by 30%',
                    iconColor: AppColors.primaryGreenDark,
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Account Actions Section
                  _buildSectionTitle('Account Settings'),
                  SizedBox(height: 12.h),
                  
                  _buildActionCard(
                    icon: HugeIcons.strokeRoundedNotification03,
                    title: 'Notifications',
                    subtitle: 'Manage notification preferences',
                    onTap: () {
                      // TODO: Navigate to notifications settings
                    },
                  ),
                  SizedBox(height: 12.h),
                  
                  _buildActionCard(
                    icon: HugeIcons.strokeRoundedLock,
                    title: 'Privacy & Security',
                    subtitle: 'Password and security settings',
                    onTap: () {
                      // TODO: Navigate to security settings
                    },
                  ),
                  SizedBox(height: 12.h),
                  
                  _buildActionCard(
                    icon: HugeIcons.strokeRoundedInformationCircle,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact us',
                    onTap: () {
                      // TODO: Navigate to help
                    },
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Logout Button
                  Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSM.r),
                      border: Border.all(
                        color: AppColors.errorRed,
                        width: 1.5,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement logout
                        _showLogoutDialog(context);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSM.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedLogout03,
                            color: AppColors.errorRed,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Logout',
                            style: AppTypography.button.copyWith(
                              color: AppColors.errorRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // App Version
                  Center(
                    child: Text(
                      'FoodFlow v1.0.0',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.neutralGray,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.h5.copyWith(
        color: AppColors.neutralBlack,
        fontWeight: AppTypography.semiBold,
      ),
    );
  }

  Widget _buildInfoCard({
    required dynamic icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutralGray.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM.r),
            ),
            child: HugeIcon(
              icon: icon,
              color: iconColor,
              size: 22.sp,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.neutralBlack,
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required dynamic icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.r),
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutralGray.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM.r),
              ),
              child: HugeIcon(
                icon: icon,
                color: AppColors.primaryGreen,
                size: 22.sp,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.neutralBlack,
                      fontWeight: AppTypography.medium,
                    ),
                  ),
                  SizedBox(height: 2.h),
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
              color: AppColors.neutralGray,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
          ),
          title: Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedLogout03,
                color: AppColors.errorRed,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Logout',
                style: AppTypography.h5.copyWith(
                  color: AppColors.neutralBlack,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.neutralDarkGray,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTypography.button.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement logout logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM.r),
                ),
              ),
              child: Text(
                'Logout',
                style: AppTypography.button.copyWith(
                  color: AppColors.neutralWhite,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
