import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';

class OnboardingProvider extends ChangeNotifier {
  final List<OnboardingModel> slides = [
    OnboardingModel(
      title: 'Penyewaan Alat\nOutdoor Terpercaya',
      subtitle:
          'Sewa perlengkapan pendakian berkualitas tinggi dari mitra lokal kami yang berada dekat dengan basecamp tujuan Anda.',
      image:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80&w=1000',
      badge: 'Sewa Peralatan',
    ),
    OnboardingModel(
      title: 'Eksplorasi Tanpa\nBatas & Aman',
      subtitle:
          'Dilengkapi dengan sistem tracking dan peta offline untuk memastikan keamanan pendakian Anda di medan manapun.',
      image:
          'https://images.unsplash.com/photo-1501555088652-021faa106b9b?auto=format&fit=crop&q=80&w=1000',
      badge: 'Live Tracking',
    ),
    OnboardingModel(
      title: 'Sewa Alat Outdoor\nTerlengkap',
      subtitle:
          'Sewa berbagai perlengkapan mendaki gunung berkualitas dari mitra lokal terpercaya dengan mudah dan cepat.',
      image:
          'https://images.unsplash.com/photo-1526772662000-3f88f10405ff?auto=format&fit=crop&q=80&w=1000',
      badge: 'Mitra Lokal',
    ),
  ];
}
