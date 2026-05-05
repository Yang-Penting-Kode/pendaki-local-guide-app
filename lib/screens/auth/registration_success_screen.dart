import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // 🚀 Import Lottie
import '../../core/constants/app_colors.dart'; // 🚀 Gunakan warna global
import '../../widgets/primary_button.dart'; // 🚀 Gunakan button bouncy global

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface, // bg-surface konsisten
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        automaticallyImplyLeading: false, // Proteksi agar user tidak back
        title: Row(
          children: [
            const Icon(Icons.travel_explore, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Local Guide Marketplace',
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Illustration Area (Lottie Edition)
            Center(
              child: SizedBox(
                height: 300,
                child: Lottie.asset(
                  'assets/animations/register-success.json', // 📁 Pastikan file JSON sudah di folder assets
                  repeat: true, // Jalankan sekali agar elegan
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.check_circle_outline,
                        size: 100, color: AppColors.primary);
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 2. Editorial Typography Section[cite: 14]
            const Text(
              'Registrasi Sukses!',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 48,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Akun pendaki Anda telah terverifikasi. Sekarang Anda bisa mulai mencari perlengkapan terbaik untuk petualangan berikutnya.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),

            // 3. Success Details Card[cite: 14]
            _buildDetailsCard(),
            const SizedBox(height: 48),

            // 4. Primary CTA (Bouncy Button Global)[cite: 14]
            PrimaryButton(
              text: 'Tutorial Dulu',
              onTap: () => Navigator.pushNamed(context, '/tutorial'),
            ),

            const SizedBox(height: 24),
            const Center(
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  'Ketuk tombol lanjut ke tutorial dulu sebelum mulai menggunakan aplikasi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI HELPER COMPONENTS ---

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('STATUS AKUN',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1.2)),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Text('Aktif',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Icon(Icons.verified, color: AppColors.primary, size: 16),
                  ],
                ),
              ],
            ),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID PENDAKI',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2)),
                SizedBox(height: 4),
                Text('GUIDE-99218',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
