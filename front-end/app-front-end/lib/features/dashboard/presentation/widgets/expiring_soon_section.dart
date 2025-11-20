import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ExpiringSoonSection extends StatelessWidget {
  const ExpiringSoonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final expiringItems = [
      ExpiringItem(
        name: 'Fresh Milk',
        daysLeft: 2,
        category: 'Dairy',
        imageIcon: HugeIcons.strokeRoundedMilkBottle,
      ),
      ExpiringItem(
        name: 'Strawberries',
        daysLeft: 1,
        category: 'Fruits',
        imageIcon: HugeIcons.strokeRoundedCherry,
      ),
      ExpiringItem(
        name: 'Greek Yogurt',
        daysLeft: 3,
        category: 'Dairy',
        imageIcon: HugeIcons.strokeRoundedIceCream01,
      ),
      ExpiringItem(
        name: 'Chicken Breast',
        daysLeft: 2,
        category: 'Meat',
        imageIcon: HugeIcons.strokeRoundedChickenThighs,
      ),
      ExpiringItem(
        name: 'Lettuce',
        daysLeft: 1,
        category: 'Vegetables',
        imageIcon: HugeIcons.strokeRoundedVegetarianFood,
      ),
    ];

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: expiringItems.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final item = expiringItems[index];
          return _buildExpiringItemCard(item);
        },
      ),
    );
  }

  Widget _buildExpiringItemCard(ExpiringItem item) {
    Color badgeColor;
    String badgeText;
    
    if (item.daysLeft == 1) {
      badgeColor = AppColors.errorRed;
      badgeText = 'Tomorrow';
    } else if (item.daysLeft == 2) {
      badgeColor = AppColors.warningYellow;
      badgeText = '${item.daysLeft} days';
    } else {
      badgeColor = AppColors.infoBlue;
      badgeText = '${item.daysLeft} days';
    }

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image/Icon Container
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.neutralLightGray,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: HugeIcon(
                icon: item.imageIcon,
                size: 28,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            
            // Item Name
            Text(
              item.name,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralBlack,
                fontWeight: AppTypography.semiBold,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            
            // Category
            Text(
              item.category,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
                fontSize: 11,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xs),
            
            // Days Left Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedClock01,
                    size: 10,
                    color: badgeColor,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    badgeText,
                    style: AppTypography.bodySmall.copyWith(
                      color: badgeColor,
                      fontWeight: AppTypography.semiBold,
                      fontSize: 10,
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

class ExpiringItem {
  final String name;
  final int daysLeft;
  final String category;
  final dynamic imageIcon;

  ExpiringItem({
    required this.name,
    required this.daysLeft,
    required this.category,
    required this.imageIcon,
  });
}
