import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';

class WaitingConfirmationScreen extends StatelessWidget {
  const WaitingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi warna lokal sesuai kode stitch HTML
    const Color stitchPrimary = Color(0xFF006C0C);
    const Color stitchPrimaryContainer = Color(0xFF1C871E);
    const Color stitchOnSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      // 1. TopAppBar dengan Efek Blur
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: stitchPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Status Pesanan',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B1B1B),
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // 2. Illustration Section (Minimalist Alpine Theme)
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: stitchPrimary.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background landscape icon (opacity 20%)
                      Opacity(
                        opacity: 0.1,
                        child: Icon(
                          Icons.landscape,
                          size: 160,
                          color: stitchPrimary,
                        ),
                      ),
                      // Schedule Icon & Pulse Line
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule_outlined,
                            size: 96,
                            color: stitchPrimary,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: stitchPrimary,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 3. Status Messaging
              const Text(
                'Menunggu Konfirmasi',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Mitra sedang meninjau pesanan Anda. Kami akan memberitahu Anda segera setelah pesanan dikonfirmasi (estimasi < 30 menit).',
                  style: TextStyle(
                    color: stitchOnSurfaceVariant,
                    height: 1.6,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // 4. Order Card[cite: 8]
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ORDER ID',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: stitchOnSurfaceVariant,
                          ),
                        ),
                        Text(
                          '#RNT-99281',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: stitchPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildOrderRow('Item', 'Tenda Eiger 4P'),
                    const SizedBox(height: 12),
                    _buildOrderRow('Mitra', 'Toko Merdeka Outdoor'),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(color: stitchOnSurfaceVariant),
                        ),
                        const Text(
                          'Rp 100.000',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 5. Atmospheric Safety Element[cite: 8]
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user, color: stitchPrimary, size: 14),
                    SizedBox(width: 8),
                    Text(
                      'Transaksi dilindungi oleh Mountain Kit Safety',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: stitchOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120), // Spacer footer
            ],
          ),
        ),
      ),
      // 6. Fixed Footer Button[cite: 8]
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border:
              Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/dashboard', (route) => false),
              style: ElevatedButton.styleFrom(
                backgroundColor: stitchPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99)),
                elevation: 8,
                shadowColor: stitchPrimary.withOpacity(0.3),
              ),
              child: const Text(
                'Kembali ke Beranda',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF3F4A3B))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
