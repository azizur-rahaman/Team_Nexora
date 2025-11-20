import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: AppTypography.h4.copyWith(
            color: AppColors.neutralBlack,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              size: 80,
              color: AppColors.neutralGray,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Profile Page',
              style: AppTypography.h3.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Coming soon...',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
