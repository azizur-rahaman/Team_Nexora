import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/surplus_item.dart';
import '../bloc/surplus_bloc.dart';
import '../bloc/surplus_event.dart';
import '../bloc/surplus_state.dart';
import '../widgets/business_info_card.dart';

/// Screen 31: Surplus Detail Page
/// Shows detailed information about a surplus item
class SurplusDetailPage extends StatefulWidget {
  final String id;

  const SurplusDetailPage({super.key, required this.id});

  @override
  State<SurplusDetailPage> createState() => _SurplusDetailPageState();
}

class _SurplusDetailPageState extends State<SurplusDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<SurplusBloc>().add(LoadSurplusItemById(widget.id));
    context.read<SurplusBloc>().add(IncrementSurplusViewsEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<SurplusBloc, SurplusState>(
        builder: (context, state) {
          if (state is SurplusLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            );
          }

          if (state is SurplusError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedAlert01,
                    color: AppColors.errorRed,
                    size: 48,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Error loading item',
                    style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    state.message,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.neutralGray),
                  ),
                ],
              ),
            );
          }

          if (state is SurplusItemDetailLoaded) {
            return _buildDetailView(context, state.item);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetailView(BuildContext context, SurplusItem item) {
    return CustomScrollView(
      slivers: [
        // App Bar with Image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: AppColors.neutralBlack,
              ),
            ),
            onPressed: () => context.pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.neutralGray,
                  child: const Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedImage01,
                      color: AppColors.neutralGray,
                      size: 64,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
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
                                  ? 'FREE DONATION'
                                  : '${item.discountPercentage}% OFF',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.surface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Title
                      Text(
                        item.title,
                        style: AppTypography.h2.copyWith(color: AppColors.neutralBlack),
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // Quantity and Price
                      Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedPackage,
                            color: AppColors.neutralGray,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${item.quantity} ${item.unit}',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.neutralGray,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (item.type == SurplusType.discounted) ...[
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              '৳${item.originalPrice?.toStringAsFixed(2)}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.neutralGray,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '৳${item.discountedPrice?.toStringAsFixed(2)}',
                              style: AppTypography.h3.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Expiry Info
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: item.isExpiringSoon
                              ? AppColors.errorRed.withOpacity(0.1)
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                          border: Border.all(
                            color: item.isExpiringSoon ? AppColors.errorRed : AppColors.neutralGray,
                          ),
                        ),
                        child: Row(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedClock01,
                              color: item.isExpiringSoon ? AppColors.errorRed : AppColors.neutralGray,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Best before',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.neutralGray,
                                    ),
                                  ),
                                  Text(
                                    DateFormatter.formatDateTime(item.expiryDate),
                                    style: AppTypography.label.copyWith(
                                      color: item.isExpiringSoon
                                          ? AppColors.errorRed
                                          : AppColors.neutralBlack,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Description
                      Text(
                        'Description',
                        style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        item.description,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.neutralGray),
                      ),

                      // Dietary Info
                      if (item.dietaryInfo.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Dietary Information',
                          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: item.dietaryInfo.map((info) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                                border: Border.all(color: AppColors.successGreen),
                              ),
                              child: Text(
                                info,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.successGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      // Allergens
                      if (item.allergens.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Allergens',
                          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: item.allergens.map((allergen) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warningYellow.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                                border: Border.all(color: AppColors.warningYellow),
                              ),
                              child: Text(
                                allergen,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.warningYellow,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: AppSpacing.lg),

                      // Pickup Time
                      Text(
                        'Pickup Time',
                        style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                          border: Border.all(color: AppColors.neutralGray),
                        ),
                        child: Row(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedClock03,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                item.pickupTimeRange,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.neutralBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (item.isPickupAvailableNow)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.successGreen,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                                ),
                                child: Text(
                                  'Available Now',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.surface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),

                // Business Info
                BusinessInfoCard(item: item),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
