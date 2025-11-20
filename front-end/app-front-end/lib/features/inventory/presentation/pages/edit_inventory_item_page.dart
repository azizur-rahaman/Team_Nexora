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
import '../bloc/inventory_state.dart';

/// Screen 21: Edit Inventory Item Screen
/// Scrollable editable form with update and delete options. Use caution red for delete button.
class EditInventoryItemPage extends StatefulWidget {
  const EditInventoryItemPage({
    super.key,
    required this.item,
  });

  final InventoryItem item;

  @override
  State<EditInventoryItemPage> createState() => _EditInventoryItemPageState();
}

class _EditInventoryItemPageState extends State<EditInventoryItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  late TextEditingController _barcodeController;

  late double _quantity;
  late String _unit;
  late InventoryCategory _selectedCategory;
  late DateTime _purchaseDate;
  late DateTime _expirationDate;

  final List<String> _commonUnits = ['pcs', 'kg', 'g', 'L', 'ml', 'pack', 'box', 'can', 'bottle'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _notesController = TextEditingController(text: widget.item.notes ?? '');
    _barcodeController = TextEditingController(text: widget.item.barcode ?? '');
    _quantity = widget.item.quantity;
    _unit = widget.item.unit;
    _selectedCategory = widget.item.category;
    _purchaseDate = widget.item.purchaseDate;
    _expirationDate = widget.item.expirationDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isPurchaseDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPurchaseDate ? _purchaseDate : _expirationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: AppColors.neutralWhite,
              surface: AppColors.neutralWhite,
              onSurface: AppColors.neutralBlack,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPurchaseDate) {
          _purchaseDate = picked;
        } else {
          _expirationDate = picked;
        }
      });
    }
  }

  void _updateItem() {
    if (_formKey.currentState!.validate()) {
      final updatedItem = widget.item.copyWith(
        name: _nameController.text.trim(),
        quantity: _quantity,
        unit: _unit,
        category: _selectedCategory,
        purchaseDate: _purchaseDate,
        expirationDate: _expirationDate,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
      );

      context.read<InventoryBloc>().add(UpdateInventoryItemEvent(updatedItem));
    }
  }

  void _deleteItem() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${widget.item.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<InventoryBloc>().add(DeleteInventoryItemEvent(widget.item.id));
              context.pop(); // Go back
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryBloc, InventoryState>(
      listener: (context, state) {
        if (state is InventoryItemUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.item.name} updated successfully!'),
              backgroundColor: AppColors.successGreen,
            ),
          );
          context.pop();
        } else if (state is InventoryItemDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item deleted successfully!'),
              backgroundColor: AppColors.successGreen,
            ),
          );
          context.pop();
        } else if (state is InventoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralLightGray,
        appBar: AppBar(
          backgroundColor: AppColors.neutralWhite,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.neutralBlack),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Inventory Item',
                style: AppTypography.h4.copyWith(
                  color: AppColors.neutralBlack,
                ),
              ),
              Text(
                'Update item information',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                ),
              ),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Edit Mode Banner
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warningYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  border: Border.all(
                    color: AppColors.warningYellow.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit_note_outlined,
                      color: AppColors.warningYellow,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Editing mode – changes will overwrite the original item.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.neutralBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Food Name
              Text(
                'Food Name',
                style: AppTypography.h6.copyWith(
                  color: AppColors.neutralBlack,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Fresh Milk, Strawberries',
                  prefixIcon: const Icon(Icons.fastfood_outlined),
                  filled: true,
                  fillColor: AppColors.neutralWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                    borderSide: const BorderSide(color: AppColors.neutralGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                    borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a food name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Category
              Text(
                'Category',
                style: AppTypography.h6.copyWith(
                  color: AppColors.neutralBlack,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  border: Border.all(color: AppColors.neutralGray),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<InventoryCategory>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryGreen),
                    items: InventoryCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(category.icon, size: 20, color: category.accentColor),
                            const SizedBox(width: AppSpacing.sm),
                            Text(category.label),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Quantity and Unit
              Text(
                'Quantity',
                style: AppTypography.h6.copyWith(
                  color: AppColors.neutralBlack,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.neutralWhite,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                        border: Border.all(color: AppColors.neutralGray),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const HugeIcon(
                              icon: HugeIcons.strokeRoundedRemove01,
                              color: AppColors.primaryGreen,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_quantity > 0.5) _quantity -= 0.5;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              _quantity.toString(),
                              style: AppTypography.h5.copyWith(
                                color: AppColors.neutralBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            icon: const HugeIcon(
                              icon: HugeIcons.strokeRoundedAdd01,
                              color: AppColors.primaryGreen,
                            ),
                            onPressed: () {
                              setState(() {
                                _quantity += 0.5;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.neutralWhite,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                        border: Border.all(color: AppColors.neutralGray),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _unit,
                          isExpanded: true,
                          items: _commonUnits.map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _unit = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Purchase Date
              Text(
                'Purchase Date',
                style: AppTypography.h6.copyWith(
                  color: AppColors.neutralBlack,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                onTap: () => _selectDate(context, true),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                    border: Border.all(color: AppColors.neutralGray),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: AppColors.primaryGreen),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        DateFormatter.formatDate(_purchaseDate),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.neutralBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Expiration Date
              Text(
                'Expiration Date',
                style: AppTypography.h6.copyWith(
                  color: AppColors.neutralBlack,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                onTap: () => _selectDate(context, false),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                    border: Border.all(color: AppColors.primaryGreen, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_available_outlined, color: AppColors.primaryGreen),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        DateFormatter.formatDate(_expirationDate),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.neutralBlack,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Barcode
              Text(
                'Barcode (Optional)',
                style: AppTypography.h6.copyWith(
                  color: AppColors.neutralBlack,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _barcodeController,
                decoration: InputDecoration(
                  hintText: 'Scan or enter barcode',
                  prefixIcon: const Icon(Icons.qr_code_scanner_outlined),
                  filled: true,
                  fillColor: AppColors.neutralWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Notes
              Text(
                'Notes (Optional)',
                style: AppTypography.h6.copyWith(
                  color: AppColors.neutralBlack,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add any additional notes about this item',
                  filled: true,
                  fillColor: AppColors.neutralWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
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
                  child: OutlinedButton(
                    onPressed: _deleteItem,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      side: const BorderSide(color: AppColors.errorRed),
                    ),
                    child: Text(
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
                  child: BlocBuilder<InventoryBloc, InventoryState>(
                    builder: (context, state) {
                      final isLoading = state is InventoryLoading;
                      return ElevatedButton.icon(
                        onPressed: isLoading ? null : _updateItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        ),
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.neutralWhite,
                                  strokeWidth: 2,
                                ),
                              )
                            : const HugeIcon(
                                icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                                color: AppColors.neutralWhite,
                              ),
                        label: Text(
                          isLoading ? 'Updating...' : 'Update Item',
                          style: AppTypography.button.copyWith(
                            color: AppColors.neutralWhite,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
