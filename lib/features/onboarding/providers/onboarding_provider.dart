import 'package:flutter/material.dart';
// START REPLACE
import 'package:pendaki_local_guide_app/features/onboarding/data/onboarding_model.dart';
// END REPLACE

class OnboardingProvider extends ChangeNotifier {
  final List<OnboardingModel> slides = [
    OnboardingModel(
      title: 'Penyewaan Alat\nOutdoor Terpercaya',
      subtitle:
          'Sewa perlengkapan pendakian berkualitas tinggi dari mitra lokal kami yang berada dekat dengan basecamp tujuan Anda.',
      image:
          'https://picsum.photos/seed/yg6gar/600/400',
      badge: 'Sewa Peralatan',
    ),
    OnboardingModel(
      title: 'Eksplorasi Tanpa\nBatas & Aman',
      subtitle:
          'Dilengkapi dengan sistem tracking dan peta offline untuk memastikan keamanan pendakian Anda di medan manapun.',
      image:
          'https://picsum.photos/seed/g9s9bm/600/400',
      badge: 'Live Tracking',
    ),
    OnboardingModel(
      title: 'Sewa Alat Outdoor\nTerlengkap',
      subtitle:
          'Sewa berbagai perlengkapan mendaki gunung berkualitas dari mitra lokal terpercaya dengan mudah dan cepat.',
      image:
          'https://picsum.photos/seed/5nuuy6/600/400',
      badge: 'Mitra Lokal',
    ),
  ];
}
