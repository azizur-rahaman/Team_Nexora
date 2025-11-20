import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _passwordDecoration(
    String label, {
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.neutralWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.primaryGreenLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.primaryGreenLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.primaryGreen),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(
          isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.primaryGreenDark,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightGray,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.neutralBlack),
        title: Text(
          'Change Password',
          style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keep things secure',
                style: AppTypography.h5.copyWith(color: AppColors.neutralBlack),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Use a strong passphrase with at least 8 characters, numbers, and symbols.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                  border: Border.all(color: AppColors.primaryGreenLight.withOpacity(0.4)),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _currentPasswordController,
                      obscureText: !_showCurrent,
                      textInputAction: TextInputAction.next,
                      decoration: _passwordDecoration(
                        'Current Password',
                        isVisible: _showCurrent,
                        onToggle: () => setState(() => _showCurrent = !_showCurrent),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: !_showNew,
                      textInputAction: TextInputAction.next,
                      decoration: _passwordDecoration(
                        'New Password',
                        isVisible: _showNew,
                        onToggle: () => setState(() => _showNew = !_showNew),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirm,
                      textInputAction: TextInputAction.done,
                      decoration: _passwordDecoration(
                        'Confirm Password',
                        isVisible: _showConfirm,
                        onToggle: () => setState(() => _showConfirm = !_showConfirm),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.neutralWhite,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                    ),
                  ),
                  child: Text(
                    'Update Password',
                    style: AppTypography.buttonLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
