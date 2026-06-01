// =============================================================================
// ✅ TRANSACTION SUCCESS SCREEN — Transaksi Berhasil (RIVERPOD INJECTED)
// Lokasi: lib/features/booking/presentation/screens/transaction_success_screen.dart
//
// Migrasi: screens/booking/transaction_success_screen.dart → features/booking/...
// Perubahan: StatelessWidget → ConsumerWidget
// Injeksi: Menerima orderId (UUID v7) via ModalRoute.settings.arguments
//
// Perbaikan Kritis:
//   - Ganti '/home' → '/dashboard' (route '/home' tidak ada di main.dart)
//   - Ganti hardcoded '#RNT-99281' → orderId dari arguments
// UI: Desain asli (icon check, instruction card, shadow) DIPERTAHANKAN.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionSuccessScreen extends ConsumerWidget {
  const TransactionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    // 🔌 Injeksi: Terima orderId dari Navigator.pushNamedAndRemoveUntil arguments
    final orderId =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'N/A';

    // Tampilkan 8 karakter pertama UUID v7 agar tidak terlalu panjang di UI
    // UUID v7 format: "01975abc-..." → ambil bagian pertama sebelum "-"
    final displayId = orderId.length > 8
        ? '#${orderId.substring(0, 8).toUpperCase()}'
        : '#$orderId';

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Top App Bar — Dipertahankan
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: primaryColor),
          onPressed: () {
            // 🔌 Fix: Ganti '/home' → '/dashboard' (route /home tidak ada)
            Navigator.pushNamedAndRemoveUntil(
                context, '/dashboard', (route) => false);
          },
        ),
        title: const Text(
          'Transaksi Berhasil',
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2. Status Icon — Dipertahankan (check circle dengan shadow)
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: primaryContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryContainer.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // 🔌 Injeksi: Tampilkan orderId yang diterima dari orderProvider
            Text(
              'Pesanan $displayId telah dikonfirmasi oleh Mitra.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: onSurfaceVariant, fontSize: 16),
            ),

            const SizedBox(height: 48),

            // 3. Instruction Card — Dipertahankan (shadow styling)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.02), blurRadius: 10)
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F3F3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on,
                        color: primaryContainer),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                            fontSize: 15, color: Colors.black, height: 1.5),
                        children: [
                          TextSpan(
                              text: 'Langkah Selanjutnya: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'Tunjukkan detail pesanan ini kepada Mitra saat Anda mengambil alat di lokasi.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 4. CTAs Bottom — Dipertahankan
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Tampilkan QR Code (Primary)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/order-detail',
                  arguments: orderId,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007A52),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.receipt_long, size: 24),
                label: const Text(
                  'Detail Pesanan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Bento-Style Secondary Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/tracking-order', arguments: orderId),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99)),
                      ),
                      child: const Text(
                        'Lacak Pesanan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/dashboard', (route) => false),
                      style: TextButton.styleFrom(
                        foregroundColor: primaryContainer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99)),
                      ),
                      child: const Text(
                        'Ke Beranda',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
