import 'package:flutter/material.dart';
import 'dart:ui';

class TransactionFailedScreen extends StatelessWidget {
  const TransactionFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai desain HTML
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color warningColor = Color(0xFFFF6B00);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Top App Bar dengan efek Blur
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.8),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Transaksi Gagal',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Decorative Elements
          _buildBackgroundDecor(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 2. Hero Illustration/Icon
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: warningColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: warningColor.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: const Icon(Icons.warning_rounded,
                      color: Colors.white, size: 48),
                ),
                const SizedBox(height: 32),

                // 3. Failure Message
                const Text(
                  'Pembayaran Gagal',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Waktu pembayaran telah habis atau terjadi kesalahan pada sistem pembayaran Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: onSurfaceVariant, fontSize: 15, height: 1.5),
                  ),
                ),

                const SizedBox(height: 40),

                // 4. Order Persistence Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.02), blurRadius: 10)
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.receipt_long,
                          color: primaryColor, size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pesanan #RNT-99281 tetap tersimpan.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Silakan coba bayar kembali sebelum batas waktu berakhir.',
                              style: TextStyle(
                                  color: onSurfaceVariant.withOpacity(0.8),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // 5. Call-to-Action (Sticky Bottom)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(
                      context); // Kembali ke ringkasan untuk coba lagi
                },
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Coba Bayar Lagi',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryContainer,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton(
                onPressed: () {
                  // Kembali ke Beranda
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                },
                style: TextButton.styleFrom(
                  foregroundColor: onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                ),
                child: const Text('Batalkan Pesanan',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget dekorasi latar belakang sesuai desain HTML
  Widget _buildBackgroundDecor() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFF005F3F).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B00).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
