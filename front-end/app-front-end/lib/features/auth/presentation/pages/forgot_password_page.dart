import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/auth_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.neutralBlack,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
              ),
            );
          } else if (state is AuthPasswordResetSent) {
            setState(() {
              _emailSent = true;
            });
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

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: _emailSent ? _buildSuccessView() : _buildFormView(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xl),
          
          // Envelope with leaves illustration
          _buildIllustration(),
          
          const SizedBox(height: AppSpacing.xxxl),
          
          // Title
          Text(
            'Forgot Password?',
            style: AppTypography.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          
          // Subtitle
          Text(
            'Enter your email address and we\'ll send you instructions to reset your password',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.neutralGray,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.xxxl),
          
          // Email Field
          _buildEmailField(),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Submit Button
          _buildSubmitButton(),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Back to Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Remember your password? ',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.neutralDarkGray,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Login',
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
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xxxl),
        
        // Success illustration
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenLight.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 60,
              color: AppColors.successGreen,
            ),
          ),
        ),
        
        const SizedBox(height: AppSpacing.xl),
        
        // Success Title
        Text(
          'Check Your Email',
          style: AppTypography.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Success Message
        Text(
          'We\'ve sent password reset instructions to',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.neutralDarkGray,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _emailController.text,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: AppTypography.semiBold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppSpacing.xxxl),
        
        // Back to Login Button
        SizedBox(
          height: AppSpacing.buttonHeightLG,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: AppColors.neutralWhite,
              elevation: AppSpacing.elevationLow,
              shadowColor: AppColors.shadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              ),
            ),
            child: Text(
              'Back to Login',
              style: AppTypography.button.copyWith(fontSize: 16),
            ),
          ),
        ),
        
        const SizedBox(height: AppSpacing.lg),
        
        // Resend Link
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _emailSent = false;
              });
            },
            child: Text(
              'Didn\'t receive the email? Resend',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: AppTypography.medium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.neutralLightGray,
              shape: BoxShape.circle,
            ),
          ),
          
          // Envelope icon
          const Icon(
            Icons.email_outlined,
            size: 80,
            color: AppColors.primaryGreen,
          ),
          
          // Green leaf - top right
          Positioned(
            top: 30,
            right: 40,
            child: Transform.rotate(
              angle: 0.3,
              child: Icon(
                Icons.eco,
                size: 40,
                color: AppColors.primaryGreenLight,
              ),
            ),
          ),
          
          // Green leaf - bottom left
          Positioned(
            bottom: 40,
            left: 35,
            child: Transform.rotate(
              angle: -0.5,
              child: Icon(
                Icons.eco,
                size: 35,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          
          // Small leaf accent - top left
          Positioned(
            top: 50,
            left: 50,
            child: Transform.rotate(
              angle: 0.8,
              child: Icon(
                Icons.eco,
                size: 25,
                color: AppColors.primaryGreenLight.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
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
        hintText: 'Enter your email address',
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

  Widget _buildSubmitButton() {
    return SizedBox(
      height: AppSpacing.buttonHeightLG,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<AuthBloc>().add(
                  PasswordResetRequested(
                    email: _emailController.text.trim(),
                  ),
                );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.neutralWhite,
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
          'Send Reset Link',
          style: AppTypography.button.copyWith(fontSize: 16),
        ),
      ),
    );
  }
}
