import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class RecommendedResourcesSection extends StatelessWidget {
  const RecommendedResourcesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = [
      ResourceItem(
        title: '5 Ways to Use Overripe Bananas',
        description: 'Don\'t throw them away! Make delicious treats',
        imageIcon: HugeIcons.strokeRoundedIdea,
        color: AppColors.secondaryOrange,
      ),
      ResourceItem(
        title: 'Smart Food Storage Tips',
        description: 'Keep your produce fresh longer',
        imageIcon: HugeIcons.strokeRoundedKitchenUtensils,
        color: AppColors.primaryGreen,
      ),
      ResourceItem(
        title: 'Meal Planning 101',
        description: 'Plan ahead to reduce waste',
        imageIcon: HugeIcons.strokeRoundedCalendar03,
        color: AppColors.infoBlue,
      ),
      ResourceItem(
        title: 'Composting Basics',
        description: 'Turn food scraps into garden gold',
        imageIcon: HugeIcons.strokeRoundedLeaf01,
        color: AppColors.successGreen,
      ),
    ];

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: resources.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final resource = resources[index];
          return _buildResourceCard(resource);
        },
      ),
    );
  }

  Widget _buildResourceCard(ResourceItem resource) {
    return Container(
      width: 280,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  resource.color.withOpacity(0.8),
                  resource.color,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusMD),
                topRight: Radius.circular(AppSpacing.radiusMD),
              ),
            ),
            child: Center(
              child: HugeIcon(
                icon: resource.imageIcon,
                size: 40,
                color: AppColors.neutralWhite,
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    resource.title,
                    style: AppTypography.h6.copyWith(
                      color: AppColors.neutralBlack,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    resource.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralGray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  
                  // Read More Link
                  Row(
                    children: [
                      Text(
                        'Read More',
                        style: AppTypography.bodySmall.copyWith(
                          color: resource.color,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowRight01,
                        size: 14,
                        color: resource.color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResourceItem {
  final String title;
  final String description;
  final dynamic imageIcon;
  final Color color;

  ResourceItem({
    required this.title,
    required this.description,
    required this.imageIcon,
    required this.color,
  });
}
