import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Anti-lemot image loader

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai desain HTML
    const Color primaryColor = Color(0xFF228B22);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);
    const Color secondaryContainer = Color(0xFFFD8B00);

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
          'Kebijakan Privasi',
          style: TextStyle(
            color: Color(0xFF1A1C1C),
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
            // 2. Hero Section: Editorial Style
            const Text(
              'Keamanan & Transaksi GuideIn',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: primaryColor,
                height: 1.1,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                    width: 48,
                    height: 2,
                    decoration: BoxDecoration(
                        color: secondaryContainer,
                        borderRadius: BorderRadius.circular(99))),
                const SizedBox(width: 12),
                const Text(
                  'Pembaruan Terakhir: 15 Agustus 2024',
                  style: TextStyle(
                      color: onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 3. Decorative Element
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: const AspectRatio(
                aspectRatio: 21 / 9,
                child: CustomNetworkImage(
                  imageUrl:
                      'https://picsum.photos/seed/a6ags6/600/400',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 64),

            // 4. Content Canvas (Numbered Sections)
            _buildNumberedSection(
              number: '1',
              title: 'Verifikasi Identitas & Akun',
              content:
                  'Untuk menjamin keamanan ekosistem rental, kami mengumpulkan identitas resmi (KTP/Passport) dan foto diri sebagai validasi penyewa. Data ini digunakan secara ketat untuk mencegah penipuan.',
              primaryColor: primaryColor,
            ),

            _buildNumberedSection(
              number: '2',
              title: 'Keamanan Transaksi & Alat',
              content:
                  'Informasi transaksi Anda, termasuk detail pembayaran dan riwayat penyewaan, dikelola dengan sistem terenkripsi. Kami juga menyimpan catatan kualitas & kondisi alat sebelum dan sesudah rental.',
              primaryColor: primaryColor,
            ),

            // 5. Tonal Shift Card (Security Callout)
            Container(
              margin: const EdgeInsets.only(bottom: 64),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                    left: BorderSide(color: primaryColor, width: 4)),
              ),
              child: _buildNumberedSection(
                number: '3',
                title: 'Perlindungan Data Marketplace',
                content:
                    'GuideIn bertindak sebagai jembatan aman. Kami hanya membagikan informasi kontak terbatas kepada Mountain Kit atau vendor rental yang telah Anda pilih untuk keperluan logistik.',
                primaryColor: primaryColor,
                isCallout: true,
              ),
            ),

            _buildNumberedSection(
              number: '4',
              title: 'Transparansi & Kontrol',
              content:
                  'Anda memiliki kendali penuh atas data yang Anda bagikan di marketplace kami. Anda berhak untuk meninjau riwayat transaksi atau mengajukan penutupan akun permanen.',
              primaryColor: primaryColor,
            ),

            // 6. Footer Contact
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Pertanyaan mengenai transaksi atau privasi rental Anda?',
                    style: TextStyle(color: onSurfaceVariant, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C871E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99)),
                        elevation: 4,
                      ),
                      child: const Text('Hubungi Support Rental',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Decorative grayscale icons
                  Opacity(
                    opacity: 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.inventory_2, size: 28),
                        SizedBox(width: 32),
                        Icon(Icons.home_repair_service, size: 28),
                        SizedBox(width: 32),
                        Icon(Icons.person_pin_circle, size: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER SECTION BUILDER ---
  Widget _buildNumberedSection({
    required String number,
    required String title,
    required String content,
    required Color primaryColor,
    bool isCallout = false,
  }) {
    return Stack(
      children: [
        // Watermark Number
        Positioned(
          left: isCallout ? -10 : 0,
          top: -10,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w900,
              color: primaryColor.withOpacity(0.1),
              height: 1,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: isCallout ? 0 : 24, bottom: isCallout ? 0 : 64, top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: const TextStyle(
                    fontSize: 16, height: 1.6, color: Color(0xFF3F4A3B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
