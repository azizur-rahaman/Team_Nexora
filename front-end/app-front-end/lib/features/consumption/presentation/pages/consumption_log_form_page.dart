import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/consumption_log.dart';

class ConsumptionLogFormPage extends StatefulWidget {
  const ConsumptionLogFormPage({
    super.key,
    required this.title,
    required this.primaryActionLabel,
    required this.accentColor,
    required this.isEditMode,
    this.initialLog,
    this.subtitle,
    this.borderColor,
    this.bannerIcon,
    this.bannerMessage,
  });

  final String title;
  final String primaryActionLabel;
  final Color accentColor;
  final bool isEditMode;
  final ConsumptionLog? initialLog;
  final String? subtitle;
  final Color? borderColor;
  final IconData? bannerIcon;
  final String? bannerMessage;

  @override
  State<ConsumptionLogFormPage> createState() => _ConsumptionLogFormPageState();
}

class _ConsumptionLogFormPageState extends State<ConsumptionLogFormPage> {
  late TextEditingController _itemController;
  late TextEditingController _notesController;
  late double _quantity;
  late ConsumptionCategory _selectedCategory;
  late DateTime _selectedDate;
  final List<String> _suggestions = const [
    'Oat milk',
    'Kale smoothie',
    'Wholegrain pasta',
  ];

  @override
  void initState() {
    super.initState();
    final log = widget.initialLog;
    _itemController = TextEditingController(text: log?.itemName ?? '');
    _notesController = TextEditingController(text: log?.notes ?? '');
    _quantity = log?.quantity ?? 1;
    _selectedCategory = log?.category ?? ConsumptionCategory.dairy;
    _selectedDate = log?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _itemController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 1),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: widget.accentColor,
        content: Text(
          widget.isEditMode
              ? 'Log updated with ${_itemController.text.isEmpty ? 'current item' : _itemController.text}.'
              : 'Log added for ${_itemController.text.isEmpty ? 'new item' : _itemController.text}.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.neutralWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.primaryGreenLight.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Text(
            'Quantity',
            style: AppTypography.h5.copyWith(color: AppColors.neutralBlack),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              if (_quantity <= 0.25) return;
              setState(() => _quantity = (_quantity - 0.25).clamp(0.25, 999));
            },
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.primaryGreenDark,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
            ),
            child: Text(
              '${_quantity.toStringAsFixed(_quantity.truncateToDouble() == _quantity ? 0 : 2)} units',
              style: AppTypography.h5.copyWith(
                color: AppColors.primaryGreenDark,
                fontWeight: AppTypography.semiBold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _quantity += 0.25),
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.primaryGreenDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: ConsumptionCategory.values.map((category) {
        final bool isSelected = _selectedCategory == category;
        return ChoiceChip(
          label: Text(category.label),
          avatar: Icon(
            category.icon,
            size: 18,
            color: isSelected ? AppColors.neutralWhite : AppColors.primaryGreenDark,
          ),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedCategory = category),
          selectedColor: AppColors.primaryGreen,
          backgroundColor: category.accentColor.withOpacity(0.2),
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: isSelected ? AppColors.neutralWhite : AppColors.primaryGreenDark,
            fontWeight: AppTypography.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor;

    return Scaffold(
      backgroundColor: AppColors.neutralLightGray,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.neutralBlack),
        title: Text(
          widget.title,
          style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    widget.subtitle!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.neutralDarkGray,
                    ),
                  ),
                ),
              if (widget.bannerMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: widget.isEditMode
                        ? AppColors.warningYellow.withOpacity(0.18)
                        : widget.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.bannerIcon ?? Icons.eco_outlined,
                        color: widget.isEditMode
                            ? AppColors.warningYellow
                            : AppColors.primaryGreenDark,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          widget.bannerMessage!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.neutralBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                  border: borderColor != null
                      ? Border.all(color: borderColor, width: 1.2)
                      : null,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _itemController,
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        hintText: 'Search food item',
                        prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreenDark),
                        filled: true,
                        fillColor: AppColors.neutralLightGray.withOpacity(0.6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: _suggestions
                          .map(
                            (suggestion) => ActionChip(
                              label: Text(suggestion),
                              onPressed: () => setState(() => _itemController.text = suggestion),
                              backgroundColor: AppColors.neutralLightGray,
                              labelStyle: AppTypography.bodySmall,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildQuantitySelector(),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Category',
                      style: AppTypography.h5.copyWith(color: AppColors.neutralBlack),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildCategoryChips(),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Date',
                      style: AppTypography.h5.copyWith(color: AppColors.neutralBlack),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today, color: AppColors.primaryGreenDark),
                      label: Text(
                        _selectedDateFormatted,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.neutralBlack,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: widget.accentColor.withOpacity(0.6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Notes (optional)',
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: AppColors.neutralLightGray.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                          borderSide: BorderSide(
                            color: AppColors.primaryGreenLight.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.accentColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          widget.primaryActionLabel,
                          style: AppTypography.buttonLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _selectedDateFormatted {
    return '${_selectedDate.day.toString().padLeft(2, '0')} '
        '${_monthLabel(_selectedDate.month)} '
        '${_selectedDate.year}';
  }

  String _monthLabel(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
