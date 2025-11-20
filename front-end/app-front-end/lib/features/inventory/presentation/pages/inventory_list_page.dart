import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/inventory_item.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';
import '../widgets/inventory_item_card.dart';
import '../widgets/inventory_filter_bar.dart';

/// Screen 19: Inventory List Screen
/// Modern inventory screen showing list of food items with quantity, expiration badge (green/yellow/red), icons.
/// Filter bar top with categories. Clean grid or list format.
class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  bool _isGridView = true;
  List<InventoryCategory>? _selectedCategories;
  ExpirationStatus? _selectedStatus;
  String _sortBy = 'expiration'; // 'name', 'expiration', 'quantity'
  bool _ascending = true;

  @override
  void initState() {
    super.initState();
    // Load inventory items on init
    context.read<InventoryBloc>().add(const LoadInventoryItems());
  }

  void _applyFilters() {
    context.read<InventoryBloc>().add(
          FilterInventoryItemsEvent(
            categories: _selectedCategories,
            expirationStatus: _selectedStatus,
            sortBy: _sortBy,
            ascending: _ascending,
          ),
        );
  }

  void _resetFilters() {
    setState(() {
      _selectedCategories = null;
      _selectedStatus = null;
      _sortBy = 'expiration';
      _ascending = true;
    });
    context.read<InventoryBloc>().add(const ResetInventoryFilter());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightGray,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.neutralBlack,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Food Inventory',
              style: AppTypography.h4.copyWith(
                color: AppColors.neutralBlack,
              ),
            ),
            const SizedBox(height: 2),
            BlocBuilder<InventoryBloc, InventoryState>(
              builder: (context, state) {
                if (state is InventoryLoaded) {
                  return Text(
                    '${state.items.length} items',
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
          // Toggle Grid/List View
          IconButton(
            icon: HugeIcon(
              icon: _isGridView
                  ? HugeIcons.strokeRoundedViewOffSlash
                  : HugeIcons.strokeRoundedGridView,
              color: AppColors.neutralBlack,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          // Filter Button
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedFilterHorizontal,
              color: AppColors.primaryGreen,
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
          InventoryFilterBar(
            selectedCategories: _selectedCategories,
            selectedStatus: _selectedStatus,
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
            onStatusTap: (status) {
              setState(() {
                _selectedStatus = _selectedStatus == status ? null : status;
              });
              _applyFilters();
            },
            onClearFilters: _resetFilters,
          ),

          // Inventory List/Grid
          Expanded(
            child: BlocBuilder<InventoryBloc, InventoryState>(
              builder: (context, state) {
                if (state is InventoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  );
                }

                if (state is InventoryError) {
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
                          'Error loading inventory',
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
                            context.read<InventoryBloc>().add(
                                  const LoadInventoryItems(),
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

                if (state is InventoryEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedPackageOpen,
                          color: AppColors.neutralGray,
                          size: 80,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'No Items Found',
                          style: AppTypography.h4.copyWith(
                            color: AppColors.neutralBlack,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Start adding items to your inventory',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.neutralGray,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.push('/inventory/add');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                          ),
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedAdd01,
                            color: AppColors.neutralWhite,
                          ),
                          label: const Text('Add First Item'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is InventoryLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<InventoryBloc>().add(
                            const LoadInventoryItems(),
                          );
                    },
                    color: AppColors.primaryGreen,
                    child: _isGridView
                        ? _buildGridView(state.items)
                        : _buildListView(state.items),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/inventory/add');
        },
        backgroundColor: AppColors.primaryGreen,
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01,
          color: AppColors.neutralWhite,
        ),
        label: Text(
          'Add Item',
          style: AppTypography.button.copyWith(
            color: AppColors.neutralWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildGridView(List<InventoryItem> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return InventoryItemCard(
          item: items[index],
          isGridView: true,
          onTap: () {
            context.push('/inventory/details/${items[index].id}');
          },
        );
      },
    );
  }

  Widget _buildListView(List<InventoryItem> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return InventoryItemCard(
          item: items[index],
          isGridView: false,
          onTap: () {
            context.push('/inventory/details/${items[index].id}');
          },
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
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
                        _buildSortChip('Name', 'name'),
                        _buildSortChip('Expiration', 'expiration'),
                        _buildSortChip('Quantity', 'quantity'),
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
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: AppTypography.h6.copyWith(
                            color: AppColors.neutralBlack,
                          ),
                        ),
                        if (_selectedCategories != null)
                          Text(
                            '${_selectedCategories!.length} selected',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: InventoryCategory.values.map((category) {
                        final isSelected =
                            _selectedCategories?.contains(category) ?? false;
                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(category.icon, size: 16),
                              const SizedBox(width: 4),
                              Text(category.label),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (_selectedCategories == null) {
                                _selectedCategories = [category];
                              } else if (isSelected) {
                                _selectedCategories!.remove(category);
                                if (_selectedCategories!.isEmpty) {
                                  _selectedCategories = null;
                                }
                              } else {
                                _selectedCategories!.add(category);
                              }
                            });
                          },
                          selectedColor:
                              category.accentColor.withOpacity(0.2),
                          checkmarkColor: category.accentColor,
                        );
                      }).toList(),
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
