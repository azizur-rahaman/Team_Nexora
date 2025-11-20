import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'consumption_log_form_page.dart';

class AddConsumptionLogPage extends ConsumptionLogFormPage {
  const AddConsumptionLogPage({super.key})
      : super(
          title: 'Add Consumption Log',
          subtitle: 'Capture what was eaten to keep your inventory accurate.',
          primaryActionLabel: 'Submit Log',
          accentColor: AppColors.primaryGreen,
          isEditMode: false,
          borderColor: null,
          bannerIcon: Icons.task_alt_outlined,
          bannerMessage: 'Logging meals regularly helps highlight patterns and reduce waste.',
        );
}
