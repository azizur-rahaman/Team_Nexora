import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/inventory_item.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';

/// Screen 22: Inventory Item Details Screen
/// Detailed view with big food illustration, expiration timeline, quantity, category, attached images section. 
/// Minimalist aesthetic.
class InventoryItemDetailsPage extends StatelessWidget {
  const InventoryItemDetailsPage({
    super.key,
    required this.item,
  });

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightGray,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: item.category.accentColor.withOpacity(0.1),
            iconTheme: const IconThemeData(color: AppColors.neutralBlack),
            actions: [
              PopupMenuButton<String>(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedMoreVertical,
                  color: AppColors.neutralBlack,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedEdit04,
                          color: AppColors.primaryGreen,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text('Edit Item'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedDelete02,
                          color: AppColors.errorRed,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text('Delete Item'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    context.push('/inventory/edit/${item.id}');
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context);
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item.category.accentColor.withOpacity(0.2),
                      item.category.accentColor.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'inventory-${item.id}',
                    child: Icon(
                      item.category.icon,
                      size: 120,
                      color: item.category.accentColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  margin: const EdgeInsets.all(AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: AppTypography.h3.copyWith(
                                color: AppColors.neutralBlack,
                              ),
                            ),
                          ),
                          ExpirationStatusBadge(item: item),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      InventoryCategoryBadge(category: item.category),
                    ],
                  ),
                ),

                // Expiration Timeline
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            item.expirationStatus.icon,
                            color: item.expirationStatus.color,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Expiration Timeline',
                            style: AppTypography.h6.copyWith(
                              color: AppColors.neutralBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildTimelineRow(
                        'Purchased',
                        DateFormatter.formatDateShort(item.purchaseDate),
                        Icons.shopping_bag_outlined,
                        AppColors.primaryGreen,
                      ),
                      _buildTimelineDivider(),
                      _buildTimelineRow(
                        item.daysUntilExpiration >= 0 ? 'Expires' : 'Expired',
                        DateFormatter.formatDateShort(item.expirationDate),
                        Icons.event_busy_outlined,
                        item.expirationStatus.color,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: item.expirationStatus.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 20,
                              color: item.expirationStatus.color,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                item.daysUntilExpiration >= 0
                                    ? 'Use within ${item.daysUntilExpiration} day${item.daysUntilExpiration != 1 ? 's' : ''}'
                                    : 'Expired ${item.daysUntilExpiration.abs()} day${item.daysUntilExpiration.abs() != 1 ? 's' : ''} ago',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: item.expirationStatus.color,
                                  fontWeight: AppTypography.semiBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Quantity & Details
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details',
                        style: AppTypography.h6.copyWith(
                          color: AppColors.neutralBlack,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildDetailRow(
                        'Quantity',
                        '${item.quantity} ${item.unit}',
                        Icons.production_quantity_limits_outlined,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        'Category',
                        item.category.label,
                        item.category.icon,
                      ),
                      if (item.barcode != null) ...[
                        const Divider(height: 24),
                        _buildDetailRow(
                          'Barcode',
                          item.barcode!,
                          Icons.qr_code_outlined,
                        ),
                      ],
                    ],
                  ),
                ),

                // Notes (if any)
                if (item.notes != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.neutralWhite,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.notes_outlined,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Notes',
                              style: AppTypography.h6.copyWith(
                                color: AppColors.neutralBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          item.notes!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.neutralDarkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDeleteConfirmation(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    side: const BorderSide(color: AppColors.errorRed),
                  ),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete02,
                    color: AppColors.errorRed,
                  ),
                  label: Text(
                    'Delete',
                    style: AppTypography.button.copyWith(
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/inventory/edit/${item.id}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedEdit04,
                    color: AppColors.neutralWhite,
                  ),
                  label: Text(
                    'Edit Item',
                    style: AppTypography.button.copyWith(
                      color: AppColors.neutralWhite,
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

  Widget _buildTimelineRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
            Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutralBlack,
                fontWeight: AppTypography.semiBold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      height: 30,
      width: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryGreen.withOpacity(0.5),
            AppColors.neutralGray.withOpacity(0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.neutralBlack,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<InventoryBloc>().add(DeleteInventoryItemEvent(item.id));
              context.pop(); // Go back to list
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
