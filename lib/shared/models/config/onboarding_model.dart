import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String image;
  final IconData overlayIcon;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
    required this.overlayIcon,
  });
}

// 🚀 Daftar halaman Onboarding khusus Mitra
final List<OnboardingModel> mitraOnboardingPages = [
  OnboardingModel(
    title: 'Terima Pesanan dengan Mudah',
    description: 'Dapatkan pesanan langsung dari pendaki di seluruh Indonesia.',
    image:
        'https://picsum.photos/seed/xe6615/600/400',
    overlayIcon: Icons.notifications_active,
  ),
  OnboardingModel(
    title: 'Kelola Toko Rental Anda Lebih Mudah',
    description:
        'Bergabunglah sebagai mitra dan jangkau ribuan pendaki yang membutuhkan perlengkapan outdoor berkualitas.',
    image:
        'https://picsum.photos/seed/78wso2/600/400',
    overlayIcon: Icons.inventory_2,
  ),
  OnboardingModel(
    title: 'Kelola Pendapatan Anda',
    description:
        'Pantau saldo dan tarik dana langsung ke rekening Anda kapan saja dengan proses transparan.',
    image:
        'https://picsum.photos/seed/jvsy38/600/400',
    overlayIcon: Icons.trending_up,
  ),
  OnboardingModel(
    title: 'Dukungan Keamanan 24/7',
    description:
        'Tim kami siap membantu Anda kapanpun dan di manapun. Keamanan mitra adalah prioritas utama.',
    image:
        'https://picsum.photos/seed/wq13hy/600/400',
    overlayIcon: Icons.support_agent,
  ),
];
