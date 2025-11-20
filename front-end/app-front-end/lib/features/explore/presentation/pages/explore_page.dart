import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surplus/presentation/bloc/surplus_bloc.dart';
import '../../../surplus/presentation/bloc/surplus_event.dart';
import '../../../surplus/presentation/bloc/surplus_state.dart';
import '../../../surplus/presentation/widgets/surplus_item_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  void initState() {
    super.initState();
    // Load surplus items
    context.read<SurplusBloc>().add(const LoadSurplusItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Explore',
          style: AppTypography.h4.copyWith(
            color: AppColors.neutralBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: AppColors.neutralBlack,
            ),
            onPressed: () {
              context.push('/surplus');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<SurplusBloc>().add(const LoadSurplusItems());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        color: AppColors.primaryGreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Community Surplus Hero Section
                _buildHeroSection(context),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Section Header
                _buildSectionHeader(
                  context,
                  title: 'Community Surplus',
                  subtitle: 'Share and discover surplus food near you',
                  onSeeAll: () {
                    context.push('/surplus');
                  },
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Surplus Items Grid
                BlocBuilder<SurplusBloc, SurplusState>(
                  builder: (context, state) {
                    if (state is SurplusLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      );
                    }
                    
                    if (state is SurplusError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            children: [
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedAlertCircle,
                                color: AppColors.errorRed,
                                size: 48,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                state.message,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.errorRed,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    if (state is SurplusLoaded) {
                      final items = state.items.take(6).toList();
                      
                      if (items.isEmpty) {
                        return _buildEmptyState();
                      }
                      
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          return SurplusItemCard(item: items[index]);
                        },
                      );
                    }
                    
                    return _buildEmptyState();
                  },
                ),
                
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen,
            AppColors.successGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedUserSharing,
                    color: AppColors.neutralWhite,
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community Surplus',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.neutralWhite,
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Reduce waste, help others',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.neutralWhite.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Discover free donations and discounted surplus food from local businesses and community members near you.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralWhite.withOpacity(0.95),
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () {
                context.push('/surplus');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neutralWhite,
                foregroundColor: AppColors.primaryGreen,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Browse All Items',
                    style: AppTypography.h6.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight01,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    String? subtitle,
    VoidCallback? onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.h5.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
            ],
          ],
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  'See All',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
                const SizedBox(width: 4),
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  size: 12,
                  color: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedPackage,
              size: 64,
              color: AppColors.neutralGray,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No surplus items yet',
              style: AppTypography.h5.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Check back soon for available items',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
