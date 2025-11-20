import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/onboarding_item.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_content_widget.dart';
import '../widgets/page_indicator.dart';
import '../../../auth/presentation/pages/login_page.dart';

/// Onboarding Page
/// Displays the onboarding/welcome screens
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;

  // Onboarding items
  final List<OnboardingItem> _onboardingItems = const [
    OnboardingItem(
      title: AppConstants.onboarding1Title,
      description: AppConstants.onboarding1Description,
      imagePath: AppConstants.onboarding1Image,
    ),
    OnboardingItem(
      title: AppConstants.onboarding2Title,
      description: AppConstants.onboarding2Description,
      imagePath: AppConstants.onboarding2Image,
    ),
    OnboardingItem(
      title: AppConstants.onboarding3Title,
      description: AppConstants.onboarding3Description,
      imagePath: AppConstants.onboarding3Image,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: Scaffold(
        backgroundColor: AppColors.neutralWhite,
        body: SafeArea(
          child: BlocConsumer<OnboardingBloc, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingPageState) {
                _pageController.animateToPage(
                  state.currentPage,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else if (state is OnboardingCompletedState || state is OnboardingSkippedState) {
                _navigateToLogin();
              }
            },
            builder: (context, state) {
              if (state is! OnboardingPageState) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  // Skip button
                  _buildTopBar(context, state),

                  // PageView
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _onboardingItems.length,
                      onPageChanged: (index) {
                        context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
                      },
                      itemBuilder: (context, index) {
                        return OnboardingContentWidget(
                          item: _onboardingItems[index],
                        );
                      },
                    ),
                  ),

                  // Bottom section with indicator and button
                  _buildBottomSection(context, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, OnboardingPageState state) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (only show if not on first page)
          if (state.currentPage > 0)
            IconButton(
              onPressed: () {
                context.read<OnboardingBloc>().add(const OnboardingPreviousPage());
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.neutralBlack,
                size: 24.sp,
              ),
            )
          else
            SizedBox(width: 48.w),

          // Skip button (only show if not on last page)
          if (!state.isLastPage)
            TextButton(
              onPressed: () {
                context.read<OnboardingBloc>().add(const OnboardingSkipped());
              },
              child: Text(
                'Skip',
                style: AppTypography.button.copyWith(
                  color: AppColors.neutralDarkGray,
                  fontSize: 16.sp,
                ),
              ),
            )
          else
            SizedBox(width: 48.w),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, OnboardingPageState state) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.xl.h,
      ),
      child: Column(
        children: [
          // Page indicator
          PageIndicator(
            currentPage: state.currentPage,
            pageCount: state.totalPages,
          ),
    
          SizedBox(height: AppSpacing.xl.h),
    
          // Next/Get Started button
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () {
                if (state.isLastPage) {
                  context.read<OnboardingBloc>().add(const OnboardingCompleted());
                } else {
                  context.read<OnboardingBloc>().add(const OnboardingNextPage());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.neutralWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
                ),
                elevation: 0,
              ),
              child: Text(
                state.isLastPage ? 'Get Started' : 'Next',
                style: AppTypography.button.copyWith(
                  fontSize: 16.sp,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
