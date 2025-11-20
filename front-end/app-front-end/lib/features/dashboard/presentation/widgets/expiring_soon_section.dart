import 'package:flutter/material.dart';
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
        imageIcon: Icons.local_drink_outlined,
      ),
      ExpiringItem(
        name: 'Strawberries',
        daysLeft: 1,
        category: 'Fruits',
        imageIcon: Icons.set_meal_outlined,
      ),
      ExpiringItem(
        name: 'Greek Yogurt',
        daysLeft: 3,
        category: 'Dairy',
        imageIcon: Icons.icecream_outlined,
      ),
      ExpiringItem(
        name: 'Chicken Breast',
        daysLeft: 2,
        category: 'Meat',
        imageIcon: Icons.restaurant_outlined,
      ),
      ExpiringItem(
        name: 'Lettuce',
        daysLeft: 1,
        category: 'Vegetables',
        imageIcon: Icons.grass_outlined,
      ),
    ];

    return SizedBox(
      height: 140,
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
          children: [
            // Image/Icon Container
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.neutralLightGray,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: Icon(
                item.imageIcon,
                size: 32,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            
            // Item Name
            Text(
              item.name,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralBlack,
                fontWeight: AppTypography.semiBold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            
            // Category
            Text(
              item.category,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
            
            const Spacer(),
            
            // Days Left Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: badgeColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    badgeText,
                    style: AppTypography.bodySmall.copyWith(
                      color: badgeColor,
                      fontWeight: AppTypography.semiBold,
                      fontSize: 11,
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
  final IconData imageIcon;

  ExpiringItem({
    required this.name,
    required this.daysLeft,
    required this.category,
    required this.imageIcon,
  });
}
