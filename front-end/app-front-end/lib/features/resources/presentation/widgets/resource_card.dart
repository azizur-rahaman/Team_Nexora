import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/resource.dart';

/// Resource Card Widget
/// Modern card displaying resource thumbnail, title, description, and metadata
class ResourceCard extends StatelessWidget {
  final Resource resource;
  final VoidCallback onTap;
  final bool isCompact;

  const ResourceCard({
    super.key,
    required this.resource,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
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
            // Header Image with Type Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusMD),
                    topRight: Radius.circular(AppSpacing.radiusMD),
                  ),
                  child: Container(
                    height: isCompact ? 120 : 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          resource.category.color.withOpacity(0.3),
                          resource.category.color.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: HugeIcon(
                      icon: resource.category.icon,
                      size: isCompact ? 40 : 60,
                      color: resource.category.color.withOpacity(0.3),
                    ),
                  ),
                ),
                // Type Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neutralBlack.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HugeIcon(
                          icon: resource.type.icon,
                          size: 12,
                          color: AppColors.neutralWhite,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          resource.type.label,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.neutralWhite,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bookmark Icon
                if (resource.isBookmarked)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const HugeIcon(
                        icon: HugeIcons.strokeRoundedBookmark02,
                        size: 16,
                        color: AppColors.neutralWhite,
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(isCompact ? AppSpacing.sm : AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  ResourceCategoryBadge(
                    category: resource.category,
                    small: true,
                  ),
                  SizedBox(height: isCompact ? AppSpacing.xs : AppSpacing.sm),

                  // Title
                  Text(
                    resource.title,
                    style: isCompact
                        ? AppTypography.h6.copyWith(
                            color: AppColors.neutralBlack,
                          )
                        : AppTypography.h5.copyWith(
                            color: AppColors.neutralBlack,
                          ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isCompact ? 4 : AppSpacing.xs),

                  // Description
                  Text(
                    resource.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralGray,
                    ),
                    maxLines: isCompact ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isCompact ? AppSpacing.sm : AppSpacing.md),

                  // Metadata Row
                  Row(
                    children: [
                      // Read Time
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedClock01,
                        size: 14,
                        color: AppColors.neutralGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${resource.readTimeMinutes} min',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      // Views
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedView,
                        size: 14,
                        color: AppColors.neutralGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${resource.views}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      // Likes
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedThumbsUp,
                        size: 14,
                        color: AppColors.neutralGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${resource.likes}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                    ],
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
