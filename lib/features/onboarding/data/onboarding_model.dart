// lib/features/onboarding/data/onboarding_model.dart
// Model data untuk slide onboarding. Ditempatkan di feature-nya sendiri (DDD-Lite).

class OnboardingModel {
  final String title;
  final String subtitle;
  final String image;
  final String badge;

  const OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.badge,
  });
}
