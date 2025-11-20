import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/surplus_item.dart';

/// Business Info Card Widget
/// Displays business information for a surplus item
class BusinessInfoCard extends StatelessWidget {
  final SurplusItem item;

  const BusinessInfoCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.neutralGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Information',
            style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
          ),

          const SizedBox(height: AppSpacing.md),

          // Business Name and Type
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedStore01,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.businessName,
                      style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      item.businessType,
                      style: AppTypography.label.copyWith(
                        color: AppColors.neutralGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Pickup Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedLocation01,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup Address',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.neutralGray,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      item.pickupAddress,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.neutralBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // View on Map Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Open map with location
              },
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedMapsLocation01,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              label: Text(
                'View on Map',
                style: AppTypography.button.copyWith(color: AppColors.primaryGreen),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryGreen),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
          ),

          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.infoBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                border: Border.all(color: AppColors.infoBlue.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedInformationCircle,
                    color: AppColors.infoBlue,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      item.notes!,
                      style: AppTypography.label.copyWith(
                        color: AppColors.neutralBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.md),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: HugeIcons.strokeRoundedView,
                  label: 'Views',
                  value: item.views.toString(),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.neutralGray,
              ),
              Expanded(
                child: _StatItem(
                  icon: HugeIcons.strokeRoundedUserMultiple,
                  label: 'Claims',
                  value: item.claims.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final dynamic icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HugeIcon(
          icon: icon,
          color: AppColors.neutralGray,
          size: 20,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.h4.copyWith(
            color: AppColors.neutralBlack,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.neutralGray,
          ),
        ),
      ],
    );
  }
}
