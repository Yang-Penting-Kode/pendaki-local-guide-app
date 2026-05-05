import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // 🚀 Import package Lottie
import '../../core/constants/app_colors.dart'; // 🚀 Gunakan warna global

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna solid dari core constants untuk mencegah ghosting
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verifikasi Email',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Manrope'),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.surface,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🚀 ANIMASI LOTTIE: Mengganti ikon statis sebelumnya
                    SizedBox(
                      height: 240,
                      child: Lottie.asset(
                        'assets/animations/gmail.json', // 📁 Pastikan file utuh .json sudah di folder assets
                        repeat: true,
                        reverse: true,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.mark_email_read_outlined,
                              size: 100, color: AppColors.primary);
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Cek Email Kamu',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Manrope'),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Kami telah mengirimkan tautan verifikasi ke email kamu. Silakan klik tautan tersebut untuk mengaktifkan akun.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColors.onSurfaceVariant,
                            height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Tombol Buka Gmail (UX Sat-set ala Bank Jago)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Pindah ke layar sukses pendaftaran[cite: 13]
                            Navigator.pushReplacementNamed(
                                context, '/register-success');
                          },
                          icon: Image.network(
                            'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                            height: 20,
                          ),
                          label: const Text(
                            'Buka Gmail',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 2,
                            side: BorderSide(color: Colors.grey.shade100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer: Kontrol Pengiriman Ulang[cite: 13]
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Tidak menerima email?',
                        style: TextStyle(color: AppColors.onSurfaceVariant)),
                    TextButton(
                      onPressed: () {
                        // Memunculkan SnackBar dengan tema warna brand[cite: 13]
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Email sudah dikirim ulang, silahkan cek gmail!',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.all(20),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      child: const Text(
                        'Kirim Ulang',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
