import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/surplus_item.dart';
import '../bloc/surplus_bloc.dart';
import '../bloc/surplus_event.dart' as surplus_event;
import '../bloc/surplus_state.dart';

/// Screen 32: Request Surplus Page
/// Form to request a surplus item
class RequestSurplusPage extends StatefulWidget {
  final String itemId;

  const RequestSurplusPage({super.key, required this.itemId});

  @override
  State<RequestSurplusPage> createState() => _RequestSurplusPageState();
}

class _RequestSurplusPageState extends State<RequestSurplusPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  DateTime? _selectedPickupTime;
  SurplusItem? _item;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    context.read<SurplusBloc>().add(surplus_event.LoadSurplusItemById(widget.itemId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectPickupTime() async {
    if (_item == null) return;

    final date = await showDatePicker(
      context: context,
      initialDate: _item!.pickupStartTime,
      firstDate: _item!.pickupStartTime,
      lastDate: _item!.pickupEndTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: AppColors.surface,
              surface: AppColors.surface,
              onSurface: AppColors.neutralBlack,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_item!.pickupStartTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primaryGreen,
                onPrimary: AppColors.surface,
                surface: AppColors.surface,
                onSurface: AppColors.neutralBlack,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedPickupTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPickupTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a pickup time'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // TODO: Get actual user ID from auth
    const userId = 'user123';

    context.read<SurplusBloc>().add(
          surplus_event.CreateSurplusRequestEvent(
            surplusItemId: widget.itemId,
            userId: userId,
            message: _messageController.text.trim().isEmpty ? null : _messageController.text.trim(),
            requestedPickupTime: _selectedPickupTime!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.neutralBlack,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Request Surplus',
          style: AppTypography.h3.copyWith(color: AppColors.neutralBlack),
        ),
      ),
      body: BlocConsumer<SurplusBloc, SurplusState>(
        listener: (context, state) {
          if (state is SurplusRequestCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Request submitted successfully!'),
                backgroundColor: AppColors.successGreen,
              ),
            );
            context.pop();
            context.pop(); // Go back to feed
          } else if (state is SurplusError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SurplusLoading && _item == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            );
          }

          if (state is SurplusItemDetailLoaded) {
            _item = state.item;
          }

          if (_item == null) {
            return const Center(
              child: Text('Item not found'),
            );
          }

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Preview Card
                  Container(
                    margin: const EdgeInsets.all(AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      border: Border.all(color: AppColors.neutralGray),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                          child: Image.network(
                            _item!.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: AppColors.neutralGray,
                                child: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedImage01,
                                  color: AppColors.neutralGray,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _item!.title,
                                style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '${_item!.quantity} ${_item!.unit}',
                                style: AppTypography.label.copyWith(
                                  color: AppColors.neutralGray,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: _item!.type == SurplusType.donation
                                      ? AppColors.successGreen
                                      : AppColors.warningYellow,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                                ),
                                child: Text(
                                  _item!.type == SurplusType.donation
                                      ? 'FREE'
                                      : '৳${_item!.discountedPrice?.toStringAsFixed(2)}',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.surface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pickup Time Selection
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pickup Time *',
                          style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Available: ${_item!.pickupTimeRange}',
                          style: AppTypography.label.copyWith(
                            color: AppColors.neutralGray,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        GestureDetector(
                          onTap: _selectPickupTime,
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                              border: Border.all(color: AppColors.neutralGray),
                            ),
                            child: Row(
                              children: [
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedCalendar03,
                                  color: AppColors.primaryGreen,
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    _selectedPickupTime != null
                                        ? DateFormatter.formatDateTime(_selectedPickupTime!)
                                        : 'Select pickup time',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: _selectedPickupTime != null
                                          ? AppColors.neutralBlack
                                          : AppColors.neutralGray,
                                    ),
                                  ),
                                ),
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedArrowRight01,
                                  color: AppColors.neutralGray,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Message Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Message (Optional)',
                          style: AppTypography.h4.copyWith(color: AppColors.neutralBlack),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Any special requests or notes...',
                            hintStyle: AppTypography.bodyMedium.copyWith(
                              color: AppColors.neutralGray,
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                              borderSide: const BorderSide(color: AppColors.neutralGray),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                              borderSide: const BorderSide(color: AppColors.neutralGray),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                              borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                            ),
                          ),
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.neutralBlack),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Submit Button
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                          ),
                          elevation: 0,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.surface,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Submit Request',
                                style: AppTypography.button.copyWith(
                                  color: AppColors.surface,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
