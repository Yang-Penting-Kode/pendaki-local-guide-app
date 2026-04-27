import 'package:flutter/material.dart';

class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai desain HTML
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: primaryColor),
          onPressed: () {
            // Kembali ke Beranda dan bersihkan stack navigasi
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
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
          mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten
          children: [
            // 2. Status Illustration & Text
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
            const Text(
              'Pesanan #RNT-99281 telah dikonfirmasi oleh Mitra.',
              textAlign: TextAlign.center,
              style: TextStyle(color: onSurfaceVariant, fontSize: 16),
            ),

            const SizedBox(height: 48),

            // 3. Instruction Card
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
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.location_on, color: primaryContainer),
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
      // 4. CTAs (Bottom Docked)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/pickup-confirmation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                  elevation: 0,
                ),
                child: const Text('Lihat Detail Pesanan',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton(
                onPressed: () {
                  // Bersihkan navigasi dan balik ke Home
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                },
                style: TextButton.styleFrom(
                  foregroundColor: primaryContainer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                ),
                child: const Text('Kembali ke Beranda',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
