import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Loading Widget
/// Displays loading indicator with message
class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primaryGreen,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Error Widget
/// Displays error message with retry option
class ErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: AppSpacing.iconXL,
                color: AppColors.errorRed,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.h4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralGray,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(
                    color: AppColors.primaryGreen,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  ),
                ),
                icon: const Icon(Icons.refresh, size: AppSpacing.iconSM),
                label: Text(
                  'Retry',
                  style: AppTypography.button.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
