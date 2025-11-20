import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Sofia Patel');
  final TextEditingController _locationController =
      TextEditingController(text: 'Birmingham, UK');

  final List<String> _dietOptions = const [
    'Plant-forward',
    'Flexitarian',
    'Vegetarian',
    'Vegan',
    'Pescatarian',
  ];

  String _selectedDiet = 'Plant-forward';
  RangeValues _budgetRange = const RangeValues(200, 450);

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  InputDecoration _buildFieldDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.neutralLightGray.withOpacity(0.4),
      labelStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.neutralDarkGray,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.primaryGreenLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.primaryGreenLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.primaryGreen),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightGray,
      appBar: AppBar(
        backgroundColor: AppColors.neutralWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.neutralBlack),
        title: Text(
          'Edit Profile',
          style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Details',
                style: AppTypography.h5.copyWith(
                  color: AppColors.neutralBlack,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: _buildFieldDecoration('Full Name'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      value: _selectedDiet,
                      decoration: _buildFieldDecoration('Diet Preferences'),
                      items: _dietOptions
                          .map(
                            (option) => DropdownMenuItem<String>(
                              value: option,
                              child: Text(option, style: AppTypography.bodyMedium),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedDiet = value);
                      },
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _BudgetSlider(
                      budgetRange: _budgetRange,
                      onChanged: (values) => setState(() => _budgetRange = values),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _locationController,
                      textInputAction: TextInputAction.done,
                      decoration: _buildFieldDecoration(
                        'Location',
                        hint: 'City, Country',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.neutralWhite,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: AppTypography.buttonLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetSlider extends StatelessWidget {
  const _BudgetSlider({
    required this.budgetRange,
    required this.onChanged,
  });

  final RangeValues budgetRange;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = AppTypography.bodyMedium.copyWith(
      color: AppColors.primaryGreenDark,
      fontWeight: AppTypography.medium,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget Range (monthly)',
          style: AppTypography.h6.copyWith(color: AppColors.neutralBlack),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'GBP ${budgetRange.start.toStringAsFixed(0)} - GBP ${budgetRange.end.toStringAsFixed(0)}',
          style: valueStyle,
        ),
        const SizedBox(height: AppSpacing.sm),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primaryGreen,
            inactiveTrackColor: AppColors.primaryGreenLight.withOpacity(0.4),
            trackHeight: 4,
            thumbColor: AppColors.primaryGreen,
            overlayColor: AppColors.primaryGreen.withOpacity(0.1),
          ),
          child: RangeSlider(
            values: budgetRange,
            min: 100,
            max: 1000,
            divisions: 18,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
