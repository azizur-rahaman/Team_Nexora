import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'user_registration_page.dart';
import 'business_registration_page.dart';
import 'ngo_registration_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                
                // Logo
                Center(
                  child: Icon(
                    Icons.eco,
                    size: AppSpacing.iconXL * 1.5,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Title
                Text(
                  'Join FoodFlow',
                  style: AppTypography.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Subtitle
                Text(
                  'Choose your account type to get started',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.neutralGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSpacing.xxxl),
                
                // User Account Card
                _buildRoleCard(
                  context: context,
                  icon: Icons.person_outline,
                  title: 'Personal Account',
                  description: 'Track your household food and reduce waste',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UserRegistrationPage(),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Business Account Card
                _buildRoleCard(
                  context: context,
                  icon: Icons.store_outlined,
                  title: 'Business Account',
                  description: 'For supermarkets, restaurants & food retailers',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BusinessRegistrationPage(),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // NGO Account Card
                _buildRoleCard(
                  context: context,
                  icon: Icons.volunteer_activism_outlined,
                  title: 'NGO Account',
                  description: 'For charities and non-profit organizations',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NgoRegistrationPage(),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
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
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.neutralLightGray,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          border: Border.all(
            color: AppColors.neutralGray.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconLG,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h5.copyWith(
                      color: AppColors.neutralBlack,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralDarkGray,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: AppSpacing.iconSM,
              color: AppColors.neutralGray,
            ),
          ],
        ),
      ),
    );
  }
}
