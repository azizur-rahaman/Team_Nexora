import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/resource.dart';
import '../bloc/resource_bloc.dart';
import '../bloc/resource_event.dart';

/// Screen 28: Resource Details Screen
/// Full article layout: header image, title, tag, body text. Clean magazine-like format.
class ResourceDetailsPage extends StatefulWidget {
  final Resource resource;

  const ResourceDetailsPage({
    super.key,
    required this.resource,
  });

  @override
  State<ResourceDetailsPage> createState() => _ResourceDetailsPageState();
}

class _ResourceDetailsPageState extends State<ResourceDetailsPage> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.resource.isBookmarked;
  }

  void _toggleBookmark() {
    context
        .read<ResourceBloc>()
        .add(ToggleResourceBookmark(widget.resource.id));
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      body: CustomScrollView(
        slivers: [
          // App Bar with Header Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.neutralWhite,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.neutralWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft01,
                  color: AppColors.neutralBlack,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              // Bookmark Button
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: HugeIcon(
                    icon: _isBookmarked
                        ? HugeIcons.strokeRoundedBookmark02
                        : HugeIcons.strokeRoundedBookmarkAdd01,
                    color: _isBookmarked
                        ? AppColors.primaryGreen
                        : AppColors.neutralBlack,
                  ),
                  onPressed: _toggleBookmark,
                ),
              ),
              // Share Button
              Container(
                margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedShare08,
                    color: AppColors.neutralBlack,
                  ),
                  onPressed: () {
                    // TODO: Implement share functionality
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Header Image (Gradient Background with Icon)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.resource.category.color.withOpacity(0.8),
                          widget.resource.category.color,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: widget.resource.category.icon,
                        size: 100,
                        color: AppColors.neutralWhite.withOpacity(0.3),
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.neutralBlack.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Type Badge
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neutralWhite,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: widget.resource.type.icon,
                            size: 16,
                            color: widget.resource.category.color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.resource.type.label,
                            style: AppTypography.bodySmall.copyWith(
                              color: widget.resource.category.color,
                              fontWeight: AppTypography.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  ResourceCategoryBadge(category: widget.resource.category),
                  const SizedBox(height: AppSpacing.md),

                  // Title
                  Text(
                    widget.resource.title,
                    style: AppTypography.h2.copyWith(
                      color: AppColors.neutralBlack,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Metadata Row
                  Row(
                    children: [
                      // Date
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedCalendar03,
                        size: 16,
                        color: AppColors.neutralGray,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormatter.formatDate(widget.resource.publishedDate),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Read Time
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedClock01,
                        size: 16,
                        color: AppColors.neutralGray,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.resource.readTimeMinutes} min read',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Views
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedView,
                        size: 16,
                        color: AppColors.neutralGray,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.resource.views}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Divider
                  Divider(color: AppColors.neutralGray.withOpacity(0.3)),
                  const SizedBox(height: AppSpacing.lg),

                  // Description
                  Text(
                    widget.resource.description,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.neutralDarkGray,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Body Content
                  _buildMarkdownContent(widget.resource.content),
                  const SizedBox(height: AppSpacing.xl),

                  // Tags Section
                  if (widget.resource.tags.isNotEmpty) ...[
                    Text(
                      'Tags',
                      style: AppTypography.h6.copyWith(
                        color: AppColors.neutralBlack,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: widget.resource.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.neutralLightGray,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '#$tag',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: AppTypography.medium,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Engagement Section
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.neutralLightGray,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Like Button
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO: Implement like functionality
                              },
                              icon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedThumbsUp,
                                color: AppColors.primaryGreen,
                                size: 28,
                              ),
                            ),
                            Text(
                              '${widget.resource.likes}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.neutralBlack,
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                            Text(
                              'Likes',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.neutralGray,
                              ),
                            ),
                          ],
                        ),

                        // Vertical Divider
                        Container(
                          height: 60,
                          width: 1,
                          color: AppColors.neutralGray.withOpacity(0.3),
                        ),

                        // Share Button
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO: Implement share functionality
                              },
                              icon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedShare08,
                                color: AppColors.infoBlue,
                                size: 28,
                              ),
                            ),
                            Text(
                              'Share',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.neutralBlack,
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                            Text(
                              'with friends',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.neutralGray,
                              ),
                            ),
                          ],
                        ),

                        // Vertical Divider
                        Container(
                          height: 60,
                          width: 1,
                          color: AppColors.neutralGray.withOpacity(0.3),
                        ),

                        // Bookmark Status
                        Column(
                          children: [
                            IconButton(
                              onPressed: _toggleBookmark,
                              icon: HugeIcon(
                                icon: _isBookmarked
                                    ? HugeIcons.strokeRoundedBookmark02
                                    : HugeIcons.strokeRoundedBookmarkAdd01,
                                color: _isBookmarked
                                    ? AppColors.primaryGreen
                                    : AppColors.secondaryOrange,
                                size: 28,
                              ),
                            ),
                            Text(
                              _isBookmarked ? 'Saved' : 'Save',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.neutralBlack,
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                            Text(
                              'for later',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.neutralGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Simple markdown-like content parser
  Widget _buildMarkdownContent(String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: AppSpacing.sm));
        continue;
      }

      // Heading 1
      if (line.startsWith('# ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              line.substring(2),
              style: AppTypography.h3.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
          ),
        );
      }
      // Heading 2
      else if (line.startsWith('## ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              line.substring(3),
              style: AppTypography.h4.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
          ),
        );
      }
      // List item
      else if (line.startsWith('- ') || line.startsWith('• ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              bottom: AppSpacing.xs,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.neutralDarkGray,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Numbered list
      else if (RegExp(r'^\d+\.').hasMatch(line)) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              bottom: AppSpacing.xs,
            ),
            child: Text(
              line,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.neutralDarkGray,
                height: 1.6,
              ),
            ),
          ),
        );
      }
      // Check items
      else if (line.startsWith('✅ ') || line.startsWith('❌ ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              line,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.neutralDarkGray,
                height: 1.6,
              ),
            ),
          ),
        );
      }
      // Regular paragraph
      else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              line,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.neutralDarkGray,
                height: 1.6,
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
