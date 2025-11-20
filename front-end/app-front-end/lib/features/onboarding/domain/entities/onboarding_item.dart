import 'package:equatable/equatable.dart';

/// Onboarding Item Entity
/// Represents a single onboarding screen content
class OnboardingItem extends Equatable {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [title, description, imagePath];
}
