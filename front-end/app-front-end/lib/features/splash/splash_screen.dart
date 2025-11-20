import 'package:flutter/material.dart';
import 'package:khaddo/core/constants/app_constants.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../auth/presentation/pages/login_page.dart';

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
      duration: const Duration(milliseconds: 1500),
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
      duration: const Duration(milliseconds: 800),
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
      duration: const Duration(milliseconds: 800),
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
      duration: const Duration(milliseconds: 2000),
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

    // Navigate to login after all animations complete
    await Future.delayed(const Duration(milliseconds: 1500));
    // if (mounted) {
    //   Navigator.of(context).pushReplacement(
    //     PageRouteBuilder(
    //       pageBuilder: (context, animation, secondaryAnimation) =>
    //           const LoginPage(),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(opacity: animation, child: child);
    //       },
    //       transitionDuration: const Duration(milliseconds: 500),
    //     ),
    //   );
    // }
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
        
                  SizedBox(height: AppSpacing.xl),
        
                  // Animated App Name
                  _buildAnimatedAppName(),
        
                  SizedBox(height: AppSpacing.md),
        
                  // Animated Tagline
                  _buildAnimatedTagline(),
                ],
              ),
            ),
        
            // Bottom Decorative Elements
            _buildBottomDecoration(),
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
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                    ),
                    child: const Icon(
                      Icons.eco,
                      size: 50,
                      color: AppColors.neutralWhite,
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
              fontSize: 48,
              fontWeight: AppTypography.bold,
              color: AppColors.neutralWhite,
              letterSpacing: 2,
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
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomDecoration() {
    return Positioned(
      bottom: AppSpacing.xl,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _backgroundOpacityAnimation,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDecorativeIcon(Icons.apple, AppColors.errorRed),
                SizedBox(width: AppSpacing.lg),
                _buildDecorativeIcon(Icons.restaurant, AppColors.secondaryOrange),
                SizedBox(width: AppSpacing.lg),
                _buildDecorativeIcon(Icons.bakery_dining, AppColors.warningYellow),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
            Text(
              '🌱',
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeIcon(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Icon(
        icon,
        color: color,
        size: AppSpacing.iconLG,
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
        final x = (size.width / 5) * i + 40;
        final y = (size.height / 8) * j + 40;

        // Draw simple leaf shape
        final path = Path();
        path.moveTo(x, y);
        path.quadraticBezierTo(x + 15, y + 10, x, y + 30);
        path.quadraticBezierTo(x - 15, y + 10, x, y);

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
