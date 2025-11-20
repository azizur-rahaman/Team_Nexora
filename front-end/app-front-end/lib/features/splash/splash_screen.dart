import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khaddo/core/constants/app_constants.dart';
import 'dart:async';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _backgroundController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoOpacityAnimation;

  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  late Animation<double> _taglineFadeAnimation;
  late Animation<Offset> _taglineSlideAnimation;

  late Animation<double> _backgroundOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo Animation Controller
    _logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text Animation Controller
    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // Tagline Animation Controller
    _taglineController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    // Background Animation Controller
    _backgroundController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    _backgroundOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeIn),
    );
  }

  void _startAnimationSequence() async {
    // Start background animation
    _backgroundController.forward();

    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Start text animation
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Start tagline animation
    await Future.delayed(const Duration(milliseconds: 400));
    _taglineController.forward();

    // Navigate to onboarding after all animations complete
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppConstants.splashBackgroundImage), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            // Animated Background Pattern
            _buildAnimatedBackground(),
        
            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  _buildAnimatedLogo(),
        
                  SizedBox(height: AppSpacing.xl.h),
        
                  // Animated App Name
                  _buildAnimatedAppName(),
        
                  SizedBox(height: AppSpacing.md.h),
        
                  // Animated Tagline
                  _buildAnimatedTagline(),
                ],
              ),
            ),
        
            // Bottom loading using loadingAnimatedWidget
            _buildLoadingAnimatedWidget(),

          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundOpacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _backgroundOpacityAnimation.value * 0.1,
          child: CustomPaint(
            size: Size.infinite,
            painter: BackgroundPatternPainter(),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Transform.rotate(
            angle: _logoRotationAnimation.value * 0.5,
            child: Opacity(
              opacity: _logoOpacityAnimation.value,
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage(AppConstants.appLogoImage),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                      blurRadius: 30.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      
                    ),
                    
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAppName() {
    return SlideTransition(
      position: _textSlideAnimation,
      child: FadeTransition(
        opacity: _textFadeAnimation,
        child: ShaderMask(
          shaderCallback: (bounds) => AppColors.primaryGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            'FoodFlow',
            style: AppTypography.h1.copyWith(
              fontSize: 48.sp,
              fontWeight: AppTypography.bold,
              color: AppColors.neutralWhite,
              letterSpacing: 2.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTagline() {
    return SlideTransition(
      position: _taglineSlideAnimation,
      child: FadeTransition(
        opacity: _taglineFadeAnimation,
        child: Text(
          'Reduce Waste, Save Food',
          style: AppTypography.h5.copyWith(
            color: AppColors.neutralDarkGray,
            fontWeight: AppTypography.medium,
            letterSpacing: 1.5.w,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimatedWidget() {
    return Positioned(
      bottom: AppSpacing.xl.h * 2,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _backgroundOpacityAnimation,
        child: Column(
          children: [
            // Loading indicator
            LoadingAnimationWidget.horizontalRotatingDots(
              color: AppColors.primaryGreen,
              size: 50.w,
            ),
            
          ],
        ),
      ),
    );
  }

}

// Custom Painter for Background Pattern
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreenLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw leaf pattern
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 8; j++) {
        final x = (size.width / 5) * i + 40.w;
        final y = (size.height / 8) * j + 40.h;

        // Draw simple leaf shape
        final path = Path();
        path.moveTo(x, y);
        path.quadraticBezierTo(x + 15.w, y + 10.h, x, y + 30.h);
        path.quadraticBezierTo(x - 15.w, y + 10.h, x, y);

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
