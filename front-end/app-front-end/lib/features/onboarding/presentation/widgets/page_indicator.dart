import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

/// Page Indicator Widget
/// Shows dots indicating the current page in onboarding
class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => _buildDot(index == currentPage),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: isActive ? 12.h : 8.h,
      width: isActive ? 12.w : 8.w,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryGreen : AppColors.neutralLightGray,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}
