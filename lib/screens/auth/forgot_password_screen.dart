import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // 🚀 Import Lottie
import '../../core/constants/app_colors.dart'; // 🚀 Warna global
import '../../widgets/custom_label.dart'; // 🚀 Widget modular kita
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart'; // 🚀 Button bouncy global

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lupa Kata Sandi',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            // 🚀 KUNCINYA DI SINI: Mengatur agar elemen dasar dimulai dari kiri
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // 1. Animasi Lottie - Dibungkus Center agar tetap di tengah
              Center(
                child: SizedBox(
                  height: 250,
                  child: Lottie.asset(
                    'assets/animations/forgot-password.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Judul & Deskripsi - Dibungkus Center agar tetap di tengah[cite: 14]
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Atur Ulang Kata Sandi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Masukkan email yang terdaftar untuk menerima instruksi pengaturan ulang kata sandi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: AppColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 3. Form Section - Sekarang otomatis berada di kiri karena parent Column-nya 'start'[cite: 14]
              const CustomLabel(
                  text: 'Alamat Email'), // 🚀 Ini sekarang di kiri!
              CustomTextField(
                hint: 'nama@email.com',
                controller: emailController,
                suffixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),

              // 4. Button - Mengikuti lebar layar[cite: 14]
              PrimaryButton(
                text: 'Kirim Instruksi',
                color: AppColors.primary,
                onTap: () => _handleSendInstruction(context),
              ),

              const SizedBox(height: 48),

              // 5. Footer - Dibungkus Center agar tetap di tengah[cite: 14]
              const Center(
                child: Text(
                  'KEAMANAN TERJAMIN • LOCAL GUIDE DESIGN',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              _buildSupportCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // --- INTERAKSI INTERAKTIF: Logic Banner ---
  void _handleSendInstruction(BuildContext context) {
    // 1. Bersihkan banner lama
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

    // 2. Tampilkan Banner di ATAS (Interaksi Premium)[cite: 14]
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        elevation: 0,
        backgroundColor: AppColors.primary, // Hijau brand[cite: 14]
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Silahkan cek akun gmail kamu!',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              Navigator.pushNamed(context, '/reset-password');
            },
            child: const Text(
              'SIMULASI LINK',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          ),
        ],
      ),
    );

    // 3. Auto-hide setelah 5 detik
    Future.delayed(const Duration(seconds: 5), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });
  }

  Widget _buildSupportCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.help_outline, color: AppColors.secondary),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Butuh Bantuan?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Hubungi pusat dukungan kami jika Anda tidak menerima email dalam waktu 5 menit.',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
