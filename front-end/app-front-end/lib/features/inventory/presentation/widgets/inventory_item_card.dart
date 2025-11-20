import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/inventory_item.dart';

/// Inventory Item Card Widget
/// Displays inventory item in grid or list format
class InventoryItemCard extends StatelessWidget {
  const InventoryItemCard({
    super.key,
    required this.item,
    required this.isGridView,
    this.onTap,
  });

  final InventoryItem item;
  final bool isGridView;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return isGridView ? _buildGridCard() : _buildListCard();
  }

  Widget _buildGridCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/Icon Container
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: item.category.accentColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusMD),
                  topRight: Radius.circular(AppSpacing.radiusMD),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      item.category.icon,
                      size: 48,
                      color: item.category.accentColor,
                    ),
                  ),
                  // Expiration Badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ExpirationStatusBadge(
                      item: item,
                      size: BadgeSize.small,
                    ),
                  ),
                ],
              ),
            ),
            // Item Details
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.neutralBlack,
                      fontWeight: AppTypography.semiBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedPackage,
                        size: 14,
                        color: AppColors.neutralGray,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${item.quantity} ${item.unit}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.neutralGray,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  InventoryCategoryBadge(
                    category: item.category,
                    size: BadgeSize.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: item.category.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                ),
                child: Icon(
                  item.category.icon,
                  size: 36,
                  color: item.category.accentColor,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.neutralBlack,
                        fontWeight: AppTypography.semiBold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        InventoryCategoryBadge(
                          category: item.category,
                          size: BadgeSize.small,
                        ),
                        const SizedBox(width: 8),
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedPackage,
                          size: 14,
                          color: AppColors.neutralGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.quantity} ${item.unit}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.neutralGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ExpirationStatusBadge(
                      item: item,
                      size: BadgeSize.small,
                    ),
                  ],
                ),
              ),
              // Arrow
              const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: AppColors.neutralGray,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
