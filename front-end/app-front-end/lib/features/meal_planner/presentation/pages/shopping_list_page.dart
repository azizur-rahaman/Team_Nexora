import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/shopping_item.dart';
import '../../data/services/meal_planner_service.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  late ShoppingList _shoppingList;
  final List<ShoppingItem> _items = [];
  String _filterCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  void _loadShoppingList() {
    // Generate sample meal plan and shopping list
    final mealPlan = MealPlannerService.generateMealPlan(
      budget: 100.0,
      dietaryPreferences: [],
      numberOfMeals: 3,
    );
    _shoppingList = MealPlannerService.generateShoppingList(mealPlan);
    _items.addAll(_shoppingList.items);
  }

  List<String> get _categories {
    final categories = _items.map((item) => item.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  List<ShoppingItem> get _filteredItems {
    if (_filterCategory == 'All') {
      return _items;
    }
    return _items.where((item) => item.category == _filterCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _items.where((i) => !i.isPurchased && !i.isInInventory).length;
    final total = _items.length;

    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.neutralBlack),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Shopping List',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.primaryGreen),
            onPressed: () {
              // Share shopping list
            },
            tooltip: 'Share',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Summary
          _buildProgressSummary(total, remaining),

          // Category Filter
          _buildCategoryFilter(),

          // Shopping List
          Expanded(
            child: _filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      return _buildShoppingItem(_filteredItems[index], index);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(remaining),
    );
  }

  Widget _buildProgressSummary(int total, int remaining) {
    final purchased = total - remaining;
    final progress = total > 0 ? (purchased / total).toDouble() : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withOpacity(0.1),
            AppColors.primaryGreenLight.withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.neutralLightGray),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$purchased of $total items',
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                  Text(
                    'Total: \$${_shoppingList.totalCost.toStringAsFixed(2)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                ],
              ),
              CircularProgressIndicator(
                value: progress,
                backgroundColor: AppColors.neutralLightGray,
                valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
                strokeWidth: 6,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.neutralLightGray,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        border: Border(
          bottom: BorderSide(color: AppColors.neutralLightGray),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _filterCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filterCategory = category;
                });
              },
              backgroundColor: AppColors.neutralWhite,
              selectedColor: AppColors.primaryGreen.withOpacity(0.2),
              checkmarkColor: AppColors.primaryGreen,
              side: BorderSide(
                color: isSelected ? AppColors.primaryGreen : AppColors.neutralLightGray,
              ),
              labelStyle: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.primaryGreen : AppColors.neutralBlack,
                fontWeight: isSelected ? AppTypography.semiBold : AppTypography.regular,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShoppingItem(ShoppingItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: item.isPurchased
            ? AppColors.neutralLightGray.withOpacity(0.3)
            : AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: item.isInInventory
              ? AppColors.primaryGreen
              : AppColors.neutralLightGray,
        ),
      ),
      child: CheckboxListTile(
        value: item.isPurchased,
        onChanged: (checked) {
          setState(() {
            _items[_items.indexOf(item)] = item.copyWith(isPurchased: checked);
          });
        },
        activeColor: AppColors.primaryGreen,
        title: Text(
          item.name,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: AppTypography.semiBold,
            decoration: item.isPurchased ? TextDecoration.lineThrough : null,
            color: item.isPurchased ? AppColors.neutralGray : AppColors.neutralBlack,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(item.category).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                  child: Text(
                    item.category,
                    style: AppTypography.caption.copyWith(
                      fontSize: 9,
                      color: _getCategoryColor(item.category),
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${item.quantity} ${item.unit}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
              ],
            ),
            if (item.isInInventory) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2,
                    size: 12,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Already in inventory',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                ],
              ),
            ],
            if (item.usedInMeals.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Used in: ${item.usedInMeals.join(", ")}',
                style: AppTypography.caption.copyWith(
                  color: AppColors.neutralGray,
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        secondary: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$${item.estimatedPrice.toStringAsFixed(2)}',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: AppTypography.bold,
                color: item.isPurchased
                    ? AppColors.neutralGray
                    : AppColors.primaryGreen,
                decoration: item.isPurchased ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.neutralLightGray,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No items in this category',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(int remaining) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        border: Border(
          top: BorderSide(color: AppColors.neutralLightGray),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Remaining Cost',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
                Text(
                  '\$${_shoppingList.remainingCost.toStringAsFixed(2)}',
                  style: AppTypography.h5.copyWith(
                    fontWeight: AppTypography.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ElevatedButton(
              onPressed: remaining > 0
                  ? () {
                      // Mark all as purchased
                      setState(() {
                        for (int i = 0; i < _items.length; i++) {
                          if (!_items[i].isPurchased && !_items[i].isInInventory) {
                            _items[i] = _items[i].copyWith(isPurchased: true);
                          }
                        }
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(
                remaining > 0 ? 'Mark All As Purchased' : 'Shopping Complete!',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.neutralWhite,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Vegetables':
        return AppColors.successGreen;
      case 'Fruits':
        return AppColors.secondaryOrange;
      case 'Dairy & Eggs':
        return AppColors.infoBlue;
      case 'Meat & Poultry':
        return AppColors.errorRed;
      case 'Seafood':
        return AppColors.primaryGreen;
      case 'Grains':
        return AppColors.warningYellow;
      case 'Bakery':
        return AppColors.secondaryOrangeLight;
      case 'Snacks':
        return AppColors.primaryGreenLight;
      default:
        return AppColors.neutralGray;
    }
  }
}
