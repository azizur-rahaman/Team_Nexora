import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/resource.dart';
import '../bloc/resource_bloc.dart';
import '../bloc/resource_event.dart';
import '../bloc/resource_state.dart';
import '../widgets/resource_card.dart';
import '../widgets/resource_filter_bar.dart';

/// Screen 27: Resources List Screen
/// Scrollable list of article/video cards with thumbnails, category tags, title, short description.
/// Light card style with green accents.
class ResourcesListPage extends StatefulWidget {
  const ResourcesListPage({super.key});

  @override
  State<ResourcesListPage> createState() => _ResourcesListPageState();
}

class _ResourcesListPageState extends State<ResourcesListPage> {
  List<ResourceCategory>? _selectedCategories;
  List<ResourceType>? _selectedTypes;
  String _sortBy = 'date'; // 'title', 'date', 'views', 'likes', 'readTime'
  bool _ascending = false;

  @override
  void initState() {
    super.initState();
    // Load resources on init
    context.read<ResourceBloc>().add(const LoadResources());
  }

  void _applyFilters() {
    context.read<ResourceBloc>().add(
          FilterResourcesEvent(
            categories: _selectedCategories,
            types: _selectedTypes,
            sortBy: _sortBy,
            ascending: _ascending,
          ),
        );
  }

  void _resetFilters() {
    setState(() {
      _selectedCategories = null;
      _selectedTypes = null;
      _sortBy = 'date';
      _ascending = false;
    });
    context.read<ResourceBloc>().add(const ResetResourceFilter());
  }

  bool get _hasActiveFilters =>
      (_selectedCategories != null && _selectedCategories!.isNotEmpty) ||
      (_selectedTypes != null && _selectedTypes!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightGray,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resources & Education',
              style: AppTypography.h4.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
            const SizedBox(height: 2),
            BlocBuilder<ResourceBloc, ResourceState>(
              builder: (context, state) {
                if (state is ResourcesLoaded) {
                  return Text(
                    '${state.resources.length} articles',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  );
                }
                return Text(
                  'Loading...',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralGray,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          // Filter Button
          IconButton(
            icon: Stack(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedFilterHorizontal,
                  color: AppColors.primaryGreen,
                ),
                if (_hasActiveFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.errorRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              _showFilterBottomSheet();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          ResourceFilterBar(
            selectedCategories: _selectedCategories,
            selectedTypes: _selectedTypes,
            hasActiveFilters: _hasActiveFilters,
            onCategoryTap: (category) {
              setState(() {
                if (_selectedCategories == null) {
                  _selectedCategories = [category];
                } else if (_selectedCategories!.contains(category)) {
                  _selectedCategories!.remove(category);
                  if (_selectedCategories!.isEmpty) {
                    _selectedCategories = null;
                  }
                } else {
                  _selectedCategories!.add(category);
                }
              });
              _applyFilters();
            },
            onTypeTap: (type) {
              setState(() {
                if (_selectedTypes == null) {
                  _selectedTypes = [type];
                } else if (_selectedTypes!.contains(type)) {
                  _selectedTypes!.remove(type);
                  if (_selectedTypes!.isEmpty) {
                    _selectedTypes = null;
                  }
                } else {
                  _selectedTypes!.add(type);
                }
              });
              _applyFilters();
            },
            onClearFilters: _resetFilters,
          ),

          // Resources List
          Expanded(
            child: BlocBuilder<ResourceBloc, ResourceState>(
              builder: (context, state) {
                if (state is ResourceLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  );
                }

                if (state is ResourceError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedAlert02,
                          color: AppColors.errorRed,
                          size: 64,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Error loading resources',
                          style: AppTypography.h5.copyWith(
                            color: AppColors.neutralBlack,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          state.message,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.neutralGray,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ResourceBloc>().add(
                                  const LoadResources(),
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ResourcesEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedFileSearch,
                          color: AppColors.neutralGray,
                          size: 80,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'No Resources Found',
                          style: AppTypography.h4.copyWith(
                            color: AppColors.neutralBlack,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Try adjusting your filters',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.neutralGray,
                          ),
                        ),
                        if (_hasActiveFilters) ...[
                          const SizedBox(height: AppSpacing.lg),
                          ElevatedButton(
                            onPressed: _resetFilters,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                            ),
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                if (state is ResourcesLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ResourceBloc>().add(
                            const LoadResources(),
                          );
                    },
                    color: AppColors.primaryGreen,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: state.resources.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final resource = state.resources[index];
                        return ResourceCard(
                          resource: resource,
                          onTap: () {
                            // Increment views when tapped
                            context.read<ResourceBloc>().add(
                                  IncrementResourceViews(resource.id),
                                );
                            context.push('/resources/details/${resource.id}');
                          },
                        );
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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: AppColors.neutralWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusLG),
              topRight: Radius.circular(AppSpacing.radiusLG),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter & Sort',
                      style: AppTypography.h4.copyWith(
                        color: AppColors.neutralBlack,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _resetFilters();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Clear All',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.errorRed,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Filter Content
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    Text(
                      'Sort By',
                      style: AppTypography.h6.copyWith(
                        color: AppColors.neutralBlack,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        _buildSortChip('Latest', 'date'),
                        _buildSortChip('Title', 'title'),
                        _buildSortChip('Views', 'views'),
                        _buildSortChip('Likes', 'likes'),
                        _buildSortChip('Read Time', 'readTime'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Order',
                      style: AppTypography.h6.copyWith(
                        color: AppColors.neutralBlack,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: _buildOrderChip('Ascending', true),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _buildOrderChip('Descending', false),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
              // Apply Button
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: AppTypography.button.copyWith(
                          color: AppColors.neutralWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _sortBy = value;
        });
      },
      selectedColor: AppColors.primaryGreen.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryGreen : AppColors.neutralDarkGray,
        fontWeight: isSelected ? AppTypography.semiBold : AppTypography.regular,
      ),
    );
  }

  Widget _buildOrderChip(String label, bool isAscending) {
    final isSelected = _ascending == isAscending;
    return ChoiceChip(
      label: Center(child: Text(label)),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _ascending = isAscending;
        });
      },
      selectedColor: AppColors.primaryGreen.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryGreen : AppColors.neutralDarkGray,
        fontWeight: isSelected ? AppTypography.semiBold : AppTypography.regular,
      ),
    );
  }
}
