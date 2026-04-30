import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF007A52);
    const Color secondaryColor = Color(0xFF904D00);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: surfaceColor.withOpacity(0.8),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Hero Section
            Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Keamanan Sewa dan Kualitas Alat Terjamin.',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 36,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pembaruan Terakhir: 15 Juni 2024',
              style: TextStyle(color: onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 48),

            // 3. Document Content
            _buildSection(
              number: '1.',
              title: 'Pendahuluan',
              content:
                  'Selamat datang di GuideIn Marketplace. Platform kami menghubungkan pendaki dengan mitra penyedia rental alat outdoor lokal. Syarat dan ketentuan ini mengatur penggunaan layanan penyewaan peralatan petualangan di ekosistem kami.\n\nGuideIn bertindak sebagai perantara transaksi dan tidak memiliki atau mengelola inventaris alat secara langsung. Tanggung jawab kualitas fisik alat berada pada mitra persewaan.',
              primaryColor: primaryColor,
            ),

            _buildSection(
              number: '2.',
              title: 'Pendaftaran & Identitas',
              content:
                  'Untuk menyewa peralatan, Anda wajib mengunggah identitas diri yang sah (KTP/SIM) sebagai bagian dari prosedur keamanan mitra kami.',
              primaryColor: primaryColor,
              items: [
                'Data identitas hanya digunakan untuk keperluan verifikasi sewa.',
                'Penyewa bertanggung jawab penuh atas alat yang disewa.',
              ],
            ),

            // 4. Callout Section (Section 3)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                    left: BorderSide(color: secondaryColor, width: 4)),
              ),
              child: _buildSection(
                number: '3.',
                title: 'Kualitas & Kerusakan Alat',
                content:
                    'Penyewa wajib memeriksa kondisi alat saat serah terima. Komplain mengenai kerusakan fisik setelah alat dibawa keluar dari lokasi mitra tidak akan diterima.',
                primaryColor: secondaryColor,
                extra: const Text(
                  'Kerusakan permanen atau kehilangan alat selama masa sewa menjadi tanggung jawab penyewa dan akan dikenakan biaya penggantian sesuai harga pasar.',
                  style: TextStyle(
                      color: onSurfaceVariant,
                      fontSize: 13,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),

            const SizedBox(height: 48),

            _buildSection(
              number: '4.',
              title: 'Deposit Keamanan',
              content:
                  'Beberapa mitra mungkin mewajibkan deposit keamanan di luar biaya sewa. GuideIn menjamin pengembalian deposit secara otomatis melalui sistem setelah alat dikembalikan dalam kondisi baik.',
              primaryColor: primaryColor,
              extra: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Metode Pengembalian',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 4),
                    Text(
                        'Deposit akan dikembalikan ke saldo GuideIn atau rekening asal dalam maksimal 1x24 jam setelah verifikasi mitra.',
                        style:
                            TextStyle(color: onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
            ),

            _buildSection(
              number: '5.',
              title: 'Pembatalan & Denda',
              content:
                  'Ketepatan waktu adalah kunci. Keterlambatan pengembalian alat akan dikenakan denda harian sesuai tarif yang tertera di masing-masing item.',
              primaryColor: primaryColor,
              extra: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.02), blurRadius: 10)
                  ],
                ),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer_outlined,
                            color: secondaryColor, size: 20),
                        SizedBox(width: 12),
                        Text('Kebijakan Pembatalan Sewa',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                        'Pembatalan pesanan kurang dari 24 jam sebelum waktu pengambilan akan dikenakan biaya pembatalan sebesar 50% dari total sewa untuk mengkompensasi kerugian ketersediaan alat mitra.',
                        style: TextStyle(
                            color: onSurfaceVariant,
                            fontSize: 13,
                            height: 1.5)),
                  ],
                ),
              ),
            ),

            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'Dengan melanjutkan proses penyewaan, Anda menyatakan telah memahami risiko penggunaan alat outdoor dan setuju untuk mematuhi standar perawatan alat selama masa sewa berlangsung.',
              style:
                  TextStyle(color: onSurfaceVariant, fontSize: 13, height: 1.5),
            ),

            const SizedBox(height: 64),

            // 5. Acceptance Action
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                  elevation: 0,
                ),
                child: const Text('Saya Mengerti & Setuju',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text('Versi Dokumen: GI-RENT-2024-V1',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER SECTION BUILDER ---
  Widget _buildSection({
    required String number,
    required String title,
    required String content,
    required Color primaryColor,
    List<String>? items,
    Widget? extra,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number,
              style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: primaryColor)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(content,
                    style: const TextStyle(
                        fontSize: 15, height: 1.6, color: Colors.black)),
                if (items != null) ...[
                  const SizedBox(height: 16),
                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle,
                                color: primaryColor, size: 16),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text(item,
                                    style: const TextStyle(fontSize: 14))),
                          ],
                        ),
                      )),
                ],
                if (extra != null) ...[
                  const SizedBox(height: 16),
                  extra,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
