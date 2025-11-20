import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/consumption_log.dart';
import 'consumption_log_form_page.dart';

class EditConsumptionLogPage extends ConsumptionLogFormPage {
  EditConsumptionLogPage({super.key})
      : super(
          title: 'Edit Consumption Log',
          subtitle: 'Adjust servings or fix mistakes without losing context.',
          primaryActionLabel: 'Update Log',
          accentColor: AppColors.primaryGreenDark,
          isEditMode: true,
          initialLog: ConsumptionLogSamples.featured,
          borderColor: AppColors.warningYellow,
          bannerIcon: Icons.edit_note_outlined,
          bannerMessage: 'Editing mode – changes will overwrite the original log.',
        );
}
