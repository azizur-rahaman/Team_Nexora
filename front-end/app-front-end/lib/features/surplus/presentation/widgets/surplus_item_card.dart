import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/surplus_item.dart';

/// Surplus Item Card Widget
/// Displays a surplus item in the feed
class SurplusItemCard extends StatelessWidget {
  final SurplusItem item;

  const SurplusItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/surplus/details/${item.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          border: Border.all(color: AppColors.neutralGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusMD),
                  ),
                  child: Image.network(
                    item.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: AppColors.neutralGray,
                        child: const Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedImage01,
                            color: AppColors.neutralGray,
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Type Badge
                Positioned(
                  top: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: item.type == SurplusType.donation
                          ? AppColors.successGreen
                          : AppColors.warningYellow,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HugeIcon(
                          icon: item.type == SurplusType.donation
                              ? HugeIcons.strokeRoundedGift
                              : HugeIcons.strokeRoundedDollar02,
                          color: AppColors.surface,
                          size: 16,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          item.type == SurplusType.donation
                              ? 'FREE'
                              : '${item.discountPercentage}% OFF',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expiring Soon Badge
                if (item.isExpiringSoon)
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorRed,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedClock01,
                            color: AppColors.surface,
                            size: 12,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Expiring Soon',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.surface,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title,
                    style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Price and Quantity
                  Row(
                    children: [
                      if (item.type == SurplusType.discounted) ...[
                        Text(
                          '৳${item.originalPrice?.toStringAsFixed(2)}',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.neutralGray,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '৳${item.discountedPrice?.toStringAsFixed(2)}',
                          style: AppTypography.h4.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                          ),
                          child: Text(
                            'FREE DONATION',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.successGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedPackage,
                        color: AppColors.neutralGray,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${item.quantity} ${item.unit}',
                        style: AppTypography.label.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Pickup Time
                  Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedClock03,
                        color: AppColors.neutralGray,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          item.pickupTimeRange,
                          style: AppTypography.label.copyWith(
                            color: AppColors.neutralGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.isPickupAvailableNow)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                          ),
                          child: Text(
                            'Now',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.surface,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Business Info
                  Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedStore01,
                        color: AppColors.neutralGray,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          item.businessName,
                          style: AppTypography.label.copyWith(
                            color: AppColors.neutralGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${item.views} views',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.neutralGray,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/surplus/request/${item.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        elevation: 0,
                      ),
                      child: Text(
                        'Request Pickup',
                        style: AppTypography.button.copyWith(color: AppColors.surface),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
