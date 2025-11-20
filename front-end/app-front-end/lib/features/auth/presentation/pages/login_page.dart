import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/auth_bloc.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
              ),
            );
          } else if (state is AuthAuthenticated) {
            // Navigate to home page
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            );
          }

          return Stack(
            children: [
              // Background with eco leaf shapes
              _buildBackgroundShapes(),
              
              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xl,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.xxxl),
                          
                          // Logo or App Name
                          Center(
                            child: Icon(
                              Icons.eco,
                              size: AppSpacing.iconXL * 1.5,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          
                          // Welcome Text
                          Text(
                            'Welcome Back',
                            style: AppTypography.h1,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Login to continue saving food',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.neutralGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: AppSpacing.xxxl),
                          
                          // Email Field
                          _buildEmailField(),
                          const SizedBox(height: AppSpacing.md),
                          
                          // Password Field
                          _buildPasswordField(),
                          
                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.sm,
                                ),
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: AppTypography.medium,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Login Button
                          _buildLoginButton(state),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.neutralDarkGray,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to sign up
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.primaryGreen,
                                    fontWeight: AppTypography.semiBold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackgroundShapes() {
    return Stack(
      children: [
        // Top-left leaf shape
        Positioned(
          top: -50,
          left: -50,
          child: Transform.rotate(
            angle: 0.3,
            child: Icon(
              Icons.eco,
              size: 200,
              color: AppColors.primaryGreenLight.withOpacity(0.1),
            ),
          ),
        ),
        // Bottom-right leaf shape
        Positioned(
          bottom: -80,
          right: -60,
          child: Transform.rotate(
            angle: -0.5,
            child: Icon(
              Icons.eco,
              size: 250,
              color: AppColors.primaryGreenLight.withOpacity(0.08),
            ),
          ),
        ),
        // Middle leaf shape
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          right: -40,
          child: Transform.rotate(
            angle: 0.8,
            child: Icon(
              Icons.eco,
              size: 150,
              color: AppColors.primaryGreenLight.withOpacity(0.06),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: AppTypography.bodyLarge.copyWith(
        color: AppColors.neutralBlack,
      ),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutralGray,
        ),
        hintText: 'Enter your email',
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutralGray.withOpacity(0.6),
        ),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: AppColors.neutralGray,
        ),
        filled: true,
        fillColor: AppColors.neutralLightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: const BorderSide(
            color: AppColors.neutralLightGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: const BorderSide(
            color: AppColors.errorRed,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: const BorderSide(
            color: AppColors.errorRed,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: AppTypography.bodyLarge.copyWith(
        color: AppColors.neutralBlack,
      ),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutralGray,
        ),
        hintText: 'Enter your password',
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutralGray.withOpacity(0.6),
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppColors.neutralGray,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.neutralGray,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: AppColors.neutralLightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: const BorderSide(
            color: AppColors.neutralLightGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: const BorderSide(
            color: AppColors.errorRed,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: const BorderSide(
            color: AppColors.errorRed,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(AuthState state) {
    return SizedBox(
      height: AppSpacing.buttonHeightLG,
      child: ElevatedButton(
        onPressed: state is AuthLoading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                        LoginRequested(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        ),
                      );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.neutralWhite,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.disabledText,
          elevation: AppSpacing.elevationLow,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
        child: Text(
          'Login',
          style: AppTypography.button.copyWith(fontSize: 16),
        ),
      ),
    );
  }
}
