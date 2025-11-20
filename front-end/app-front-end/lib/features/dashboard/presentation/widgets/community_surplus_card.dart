import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surplus/presentation/bloc/surplus_bloc.dart';
import '../../../surplus/presentation/bloc/surplus_state.dart';

class CommunitySurplusCard extends StatelessWidget {
  const CommunitySurplusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurplusBloc, SurplusState>(
      builder: (context, state) {
        int totalItems = 0;
        int freeItems = 0;
        int discountedItems = 0;

        if (state is SurplusLoaded) {
          totalItems = state.items.length;
          freeItems = state.items.where((item) => item.type.toString().contains('donation')).length;
          discountedItems = state.items.where((item) => item.type.toString().contains('discounted')).length;
        }

        return GestureDetector(
          onTap: () {
            context.push('/surplus');
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.warningYellow.withOpacity(0.85),
                  AppColors.successGreen.withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              boxShadow: [
                BoxShadow(
                  color: AppColors.successGreen.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.neutralWhite.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Reflective overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.neutralWhite.withOpacity(0.25),
                          AppColors.neutralWhite.withOpacity(0.0),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSpacing.radiusMD),
                        topRight: Radius.circular(AppSpacing.radiusMD),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: AppColors.neutralWhite.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                                ),
                                child: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedUserSharing,
                                  color: AppColors.neutralWhite,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Community Surplus',
                                style: AppTypography.h5.copyWith(
                                  color: AppColors.neutralWhite,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.neutralWhite.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'View All',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.neutralWhite,
                                    fontWeight: AppTypography.semiBold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedArrowRight01,
                                  color: AppColors.neutralWhite,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      
                      // Statistics Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              label: 'Available',
                              value: totalItems.toString(),
                              icon: HugeIcons.strokeRoundedPackage,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.neutralWhite.withOpacity(0.3),
                          ),
                          Expanded(
                            child: _buildStatItem(
                              label: 'Free',
                              value: freeItems.toString(),
                              icon: HugeIcons.strokeRoundedGift,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.neutralWhite.withOpacity(0.3),
                          ),
                          Expanded(
                            child: _buildStatItem(
                              label: 'Discounted',
                              value: discountedItems.toString(),
                              icon: HugeIcons.strokeRoundedDollar02,
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
      },
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required dynamic icon,
  }) {
    return Column(
      children: [
        HugeIcon(
          icon: icon,
          color: AppColors.neutralWhite.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.h3.copyWith(
            color: AppColors.neutralWhite,
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.neutralWhite.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
