import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const profile = _UserProfile(
      name: 'Sofia Patel',
      email: 'sofia.patel@foodflow.app',
      householdSize: 4,
      dietaryPreferences: [
        'Plant-forward',
        'Low waste',
        'Nut-free',
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileHeaderCard(profile: profile),
              const SizedBox(height: AppSpacing.lg),
              _EcoInfoCard(
                label: 'Household Size',
                icon: Icons.home_outlined,
                iconColor: AppColors.primaryGreen,
                child: Text(
                  '${profile.householdSize} members',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.neutralBlack,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _EcoInfoCard(
                label: 'Dietary Preferences',
                icon: Icons.local_florist_outlined,
                iconColor: AppColors.secondaryOrange,
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: profile.dietaryPreferences
                      .map((preference) => _DietChip(label: preference))
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _EcoInfoCard(
                label: 'Household Insights',
                icon: Icons.eco_outlined,
                iconColor: AppColors.primaryGreenDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _EcoHighlight(
                      title: 'Waste reduced this month',
                      value: '3.2 kg',
                    ),
                    SizedBox(height: AppSpacing.sm),
                    _EcoHighlight(
                      title: 'Local produce share',
                      value: '68%',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Account Settings',
                style: AppTypography.h5.copyWith(
                  color: AppColors.neutralBlack,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SettingsActionCard(
                title: 'Edit Profile',
                subtitle: 'Update name, preferences, and budget goals',
                icon: Icons.person_outline,
                onTap: () {
                  context.push('/profile/edit');
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _SettingsActionCard(
                title: 'Change Password',
                subtitle: 'Keep your account secure with a new passphrase',
                icon: Icons.lock_outline,
                onTap: () {
                  context.push('/profile/change-password');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.profile});

  final _UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        // gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        // boxShadow: const [
        //   BoxShadow(
        //     color: AppColors.shadow,
        //     blurRadius: 24,
        //     offset: Offset(0, 12),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGreen.withOpacity(0.2),
                ),
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primaryGreen,
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: AppSpacing.iconXL,
                    color: AppColors.neutralWhite,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.neutralBlack,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      profile.email,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.neutralBlack.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Divider(
            color: AppColors.neutralBlack.withOpacity(0.24),
            thickness: 1,
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: const [
              _ProfileBadge(
                icon: Icons.grass_rounded,
                label: 'Seasonal eater',
              ),
              _ProfileBadge(
                icon: Icons.recycling_outlined,
                label: 'Waste conscious',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EcoInfoCard extends StatelessWidget {
  const _EcoInfoCard({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        border: Border.all(color: AppColors.neutralLightGray),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: AppSpacing.iconMD,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                label,
                style: AppTypography.h5.copyWith(
                  color: AppColors.neutralBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _DietChip extends StatelessWidget {
  const _DietChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryGreenLight.withOpacity(0.25),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.primaryGreenDark,
          fontWeight: AppTypography.medium,
        ),
      ),
    );
  }
}

class _EcoHighlight extends StatelessWidget {
  const _EcoHighlight({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.neutralDarkGray,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.h4.copyWith(
            color: AppColors.primaryGreenDark,
          ),
        ),
      ],
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSpacing.iconSM,
            color: AppColors.neutralWhite,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.neutralWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsActionCard extends StatelessWidget {
  const _SettingsActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
          border: Border.all(color: AppColors.neutralLightGray),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryGreenDark,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h5.copyWith(
                      color: AppColors.neutralBlack,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.neutralDarkGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: AppSpacing.iconSM,
              color: AppColors.neutralGray,
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfile {
  const _UserProfile({
    required this.name,
    required this.email,
    required this.householdSize,
    required this.dietaryPreferences,
  });

  final String name;
  final String email;
  final int householdSize;
  final List<String> dietaryPreferences;
}
