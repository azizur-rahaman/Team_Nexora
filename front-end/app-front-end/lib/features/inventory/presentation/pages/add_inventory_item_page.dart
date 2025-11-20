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

/// Screen 20: Add Inventory Item Screen
/// Inventory creation form: Name dropdown, Quantity stepper, Purchase Date, Auto Expiration date section, 
/// optional photo upload. Use icons and smooth layout.
class AddInventoryItemPage extends StatefulWidget {
  const AddInventoryItemPage({super.key});

  @override
  State<AddInventoryItemPage> createState() => _AddInventoryItemPageState();
}

class _AddInventoryItemPageState extends State<AddInventoryItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  double _quantity = 1.0;
  String _unit = 'pcs';
  InventoryCategory _selectedCategory = InventoryCategory.other;
  DateTime _purchaseDate = DateTime.now();
  DateTime? _expirationDate;
  String? _imageUrl;
  final _barcodeController = TextEditingController();

  final List<String> _commonUnits = ['pcs', 'kg', 'g', 'L', 'ml', 'pack', 'box', 'can', 'bottle'];
  
  // Preset expiration periods for categories (in days)
  final Map<InventoryCategory, int> _defaultExpirationPeriods = {
    InventoryCategory.dairy: 7,
    InventoryCategory.fruit: 5,
    InventoryCategory.vegetable: 7,
    InventoryCategory.meat: 3,
    InventoryCategory.grain: 30,
    InventoryCategory.beverage: 14,
    InventoryCategory.snack: 60,
    InventoryCategory.frozen: 365,
    InventoryCategory.canned: 730,
    InventoryCategory.other: 30,
  };

  @override
  void initState() {
    super.initState();
    _updateExpirationDate();
  }

  void _updateExpirationDate() {
    final days = _defaultExpirationPeriods[_selectedCategory] ?? 30;
    setState(() {
      _expirationDate = _purchaseDate.add(Duration(days: days));
    });
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
      initialDate: isPurchaseDate ? _purchaseDate : (_expirationDate ?? DateTime.now()),
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
          _updateExpirationDate();
        } else {
          _expirationDate = picked;
        }
      });
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      if (_expirationDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an expiration date'),
            backgroundColor: AppColors.errorRed,
          ),
        );
        return;
      }

      final newItem = InventoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        quantity: _quantity,
        unit: _unit,
        category: _selectedCategory,
        purchaseDate: _purchaseDate,
        expirationDate: _expirationDate!,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        imageUrl: _imageUrl,
        barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
      );

      context.read<InventoryBloc>().add(AddInventoryItemEvent(newItem));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryBloc, InventoryState>(
      listener: (context, state) {
        if (state is InventoryItemAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.item.name} added successfully!'),
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
                'Add Inventory Item',
                style: AppTypography.h4.copyWith(
                  color: AppColors.neutralBlack,
                ),
              ),
              Text(
                'Add a new food item to your inventory',
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
              // Food Name
              _buildSectionTitle('Food Name'),
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
                  enabledBorder: OutlineInputBorder(
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
              _buildSectionTitle('Category'),
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
                        _updateExpirationDate();
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Quantity and Unit
              _buildSectionTitle('Quantity'),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  // Quantity Stepper
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
                  // Unit Dropdown
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
              _buildSectionTitle('Purchase Date'),
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
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: AppColors.neutralGray),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Expiration Date (Auto-calculated with manual override)
              _buildSectionTitle('Expiration Date'),
              Text(
                'Auto-calculated based on category (tap to change)',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutralGray,
                  fontStyle: FontStyle.italic,
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
                        _expirationDate != null
                            ? DateFormatter.formatDate(_expirationDate!)
                            : 'Select expiration date',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.neutralBlack,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                      const Spacer(),
                      if (_expirationDate != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
                          ),
                          child: Text(
                            '${_expirationDate!.difference(_purchaseDate).inDays} days',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: AppTypography.semiBold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Optional: Barcode
              _buildSectionTitle('Barcode (Optional)'),
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
                    borderSide: const BorderSide(color: AppColors.neutralGray),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Optional: Notes
              _buildSectionTitle('Notes (Optional)'),
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
                    borderSide: const BorderSide(color: AppColors.neutralGray),
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
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      side: const BorderSide(color: AppColors.neutralGray),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.button.copyWith(
                        color: AppColors.neutralDarkGray,
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
                        onPressed: isLoading ? null : _saveItem,
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
                          isLoading ? 'Adding...' : 'Add Item',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.h6.copyWith(
        color: AppColors.neutralBlack,
        fontWeight: AppTypography.semiBold,
      ),
    );
  }
}
