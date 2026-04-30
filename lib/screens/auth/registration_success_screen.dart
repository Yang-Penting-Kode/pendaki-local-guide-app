import 'dart:ui';
import 'package:flutter/material.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi warna dari Tailwind
    const Color primaryColor = Color(0xFF006C0C);
    const Color primaryGradientEnd = Color(0xFF1C871E);
    const Color secondaryColor = Color(0xFF006C0C);
    const Color secondaryGradientEnd = Color(0xFF006C0C);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: surfaceColor,
      // TopAppBar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        automaticallyImplyLeading: false, // User tidak boleh back dari sini
        title: Row(
          children: [
            const Icon(Icons.travel_explore, color: Color(0xFF228B22)),
            const SizedBox(width: 8),
            Text(
              'Local Guide Marketplace',
              style: TextStyle(
                color: const Color(0xFF228B22),
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Illustration Area
            Center(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=1000',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Glassmorphic Success Overlay
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.shopping_cart_checkout,
                                    color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Opacity(
                                    opacity: 0.8,
                                    child: Text(
                                      'INFO SISTEM',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5),
                                    ),
                                  ),
                                  const Text(
                                    'Pemesanan Berhasil',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // 2. Editorial Typography Section
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
              'Pemesanan alat pendakian Anda telah terverifikasi. Anda dapat mengambil perlengkapan di pos penyewaan terdekat sesuai jadwal yang dipilih.',
              style: TextStyle(
                fontSize: 16,
                color: onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),

            // 3. Success Details Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
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
                                color: primaryColor,
                                letterSpacing: 1.2)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text('Aktif',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified,
                                color: primaryColor, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ID PENDAKI',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: onSurfaceVariant,
                                letterSpacing: 1.2)),
                        const SizedBox(height: 4),
                        const Text('GUIDE-99218',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // 4. Primary Call to Action (Gradient Button)
            Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                gradient: const LinearGradient(
                  colors: [secondaryColor, secondaryGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                      color: secondaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8))
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/tutorial');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tutorial Dulu',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    SizedBox(width: 12),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  'Ketuk tombol lanjut ke tutorial dulu sebelum ke menggunakan aplikasi.',
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
}
