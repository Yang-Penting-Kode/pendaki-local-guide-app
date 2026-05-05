import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_image.dart';

class OrderCancelledScreen extends StatelessWidget {
  const OrderCancelledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 Definisi warna sebagai variabel biasa (Hapus 'const' di depan Color)
    final Color stitchPrimary = const Color(0xFF006C0C);
    final Color stitchError = const Color(0xFFBA1A1A);
    final Color stitchErrorContainer = const Color(0xFFFFDAD6);
    final Color stitchOnSurfaceVariant = const Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C1C)),
          onPressed: () => Navigator.pop(context),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildStatusVisual(stitchError, stitchErrorContainer),
                  const SizedBox(height: 32),
                  const Text(
                    'Pesanan Dibatalkan',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mohon maaf, pesanan Anda telah dibatalkan. Dana Anda akan segera dikembalikan ke saldo atau metode pembayaran asal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: stitchOnSurfaceVariant, height: 1.6, fontSize: 15),
                  ),
                  const SizedBox(height: 32),
                  _buildCancellationReason(stitchOnSurfaceVariant),
                  const SizedBox(height: 24),
                  _buildOrderSummaryCard(stitchPrimary),
                  const SizedBox(height: 24),
                  Text(
                    '"Keamanan petualangan Anda adalah prioritas kami. Cari perlengkapan pengganti di mitra terdekat lainnya."',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: stitchOnSurfaceVariant, fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 160), 
                ],
              ),
            ),
          ),
          _buildFooter(context, stitchPrimary),
        ],
      ),
    );
  }

  // --- SUB-WIDGET HELPERS ---

  Widget _buildStatusVisual(Color error, Color container) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: container.withOpacity(0.3), // 🚀 AMAN: Tidak pakai const
              shape: BoxShape.circle,
            ),
          ),
          Icon(Icons.cancel, size: 100, color: error),
        ],
      ),
    );
  }

  Widget _buildCancellationReason(Color onSurfaceVariant) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF904D00), size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alasan Pembatalan:', 
                  style: TextStyle(color: onSurfaceVariant, fontWeight: FontWeight.w500, fontSize: 13)),
                const Text('Mitra tidak tersedia di jadwal terpilih.', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(Color primary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1C1C).withOpacity(0.08), // 🚀 AMAN: Hapus const di depan BoxShadow
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('RINGKASAN PESANAN', 
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFF3F4A3B))),
              Text('#RNT-99281', 
                style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.bold, color: primary)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CustomNetworkImage(
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDaf8c5Djp3t4i_Ag1NoT_lIDhhfpMxMg-cLcCzLwVstQp_RLLTD5emv1OvlOvutvVTXqFJjBujAaje18xAT0Kc9aNLe93N1H59_4N1jC4DcnbiFd6TtFQIDQojQY3uDnmKc50cUnPcY0RfPGK3V3VrNPYiOOcsPAeKl-VKgd19qMLF-QoJrJaWGJwL37x7kFW1V4BZ7KZ14jElhGUkWohoPRdYe5m_lv9hXNswFUdrF0cEzMMSI-ZmePnf5lLzxwiNlRwP0b9622Nn',
                  width: 64, height: 64,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tenda Eiger 4P', style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.bold, fontSize: 16)),
                    const Row(
                      children: [
                        Icon(Icons.storefront, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('Toko Merdeka Outdoor', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 40, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('Rp 100.000', 
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough, 
                      color: const Color(0xFF1A1C1C).withOpacity(0.4), // 🚀 FIX: Hapus const[cite: 8]
                      fontWeight: FontWeight.bold, 
                      fontSize: 18
                    )),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1A1A).withOpacity(0.1), // 🚀 FIX: Hapus const[cite: 8]
                  borderRadius: BorderRadius.circular(99)
                ),
                child: const Text('GAGAL', style: TextStyle(color: Color(0xFFBA1A1A), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, Color primary) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                      elevation: 8,
                      shadowColor: primary.withOpacity(0.3),
                    ),
                    child: const Text('Kembali ke Beranda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/catalog'),
                  child: Text('Cari Alat Lain', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}