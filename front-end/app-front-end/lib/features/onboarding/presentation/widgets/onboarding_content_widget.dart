import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/onboarding_item.dart';

/// Onboarding Content Widget
/// Displays the content for a single onboarding page
class OnboardingContentWidget extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingContentWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            child: Text(
              item.title,
              style: AppTypography.h2.copyWith(
                fontSize: 32.sp,
                fontWeight: AppTypography.bold,
                color: AppColors.neutralBlack,
              ),
              textAlign: TextAlign.start,
            ),
          ),

          SizedBox(height: AppSpacing.md.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            child: Text(
              item.description,
              style: AppTypography.bodyLarge.copyWith(
                fontSize: 16.sp,
                color: AppColors.neutralDarkGray,
                height: 1.6,
              ),
              textAlign: TextAlign.start,
            ),
          ),

          // Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.lg.r),
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
