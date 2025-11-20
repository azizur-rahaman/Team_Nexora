import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/surplus_item.dart';
import '../bloc/surplus_bloc.dart';
import '../bloc/surplus_event.dart';
import '../bloc/surplus_state.dart';
import '../widgets/surplus_item_card.dart';

/// Screen 30: Surplus Feed Page
/// Displays available surplus items with filtering
class SurplusFeedPage extends StatefulWidget {
  const SurplusFeedPage({super.key});

  @override
  State<SurplusFeedPage> createState() => _SurplusFeedPageState();
}

class _SurplusFeedPageState extends State<SurplusFeedPage> {
  SurplusType? _activeFilter;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SurplusBloc>().add(const LoadSurplusItems());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterChanged(SurplusType? type) {
    setState(() => _activeFilter = type);
    context.read<SurplusBloc>().add(FilterSurplusByType(type));
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      context.read<SurplusBloc>().add(const LoadSurplusItems());
    } else {
      context.read<SurplusBloc>().add(SearchSurplusItems(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Community Surplus',
          style: AppTypography.h2.copyWith(color: AppColors.neutralBlack),
        ),
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedNotification02,
              color: AppColors.neutralBlack,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search surplus items...',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.neutralGray),
                prefixIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: AppColors.neutralGray,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),

          // Filter Chips
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isActive: _activeFilter == null,
                    onTap: () => _onFilterChanged(null),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _FilterChip(
                    label: 'Free Donations',
                    icon: HugeIcons.strokeRoundedGift,
                    color: AppColors.successGreen,
                    isActive: _activeFilter == SurplusType.donation,
                    onTap: () => _onFilterChanged(SurplusType.donation),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _FilterChip(
                    label: 'Discounted',
                    icon: HugeIcons.strokeRoundedDollar02,
                    color: AppColors.warningYellow,
                    isActive: _activeFilter == SurplusType.discounted,
                    onTap: () => _onFilterChanged(SurplusType.discounted),
                  ),
                ],
              ),
            ),
          ),

          // Surplus Items List
          Expanded(
            child: BlocBuilder<SurplusBloc, SurplusState>(
              builder: (context, state) {
                if (state is SurplusLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
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
                          'Error loading surplus items',
                          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          state.message,
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.neutralGray),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (state is SurplusLoaded) {
                  if (state.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedPackage,
                            color: AppColors.neutralGray,
                            size: 64,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'No surplus items available',
                            style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Check back later for new items',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.neutralGray),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<SurplusBloc>().add(const LoadSurplusItems());
                    },
                    color: AppColors.primaryGreen,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: state.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        return SurplusItemCard(item: state.items[index]);
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final dynamic icon;
  final Color? color;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.icon,
    this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive ? (color ?? AppColors.primaryGreen) : AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
          border: Border.all(
            color: isActive ? (color ?? AppColors.primaryGreen) : AppColors.neutralGray,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              HugeIcon(
                icon: icon,
                color: isActive ? AppColors.surface : (color ?? AppColors.neutralBlack),
                size: 16,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTypography.label.copyWith(
                color: isActive ? AppColors.surface : AppColors.neutralBlack,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
