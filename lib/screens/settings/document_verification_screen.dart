import 'dart:ui';
import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Anti-lemot image loader

class DocumentVerificationScreen extends StatelessWidget {
  const DocumentVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai Desain HTML
    const Color primaryColor = Color(0xFF006C0C);
    const Color primaryContainer = Color(0xFF1C871E);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);
    const Color outlineColor = Color(0xFF6F7A6A);

    return Scaffold(
      backgroundColor: surfaceColor,
      extendBody: true, // Agar konten bisa mengalir di bawah footer
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF228B22)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verifikasi Dokumen',
          style: TextStyle(
            color: Color(0xFF1A1C1C),
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.more_vert, color: Color(0xFF228B22)),
        //     onPressed: () {},
        //   ),
        //   const SizedBox(width: 8),
        // ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Success Banner
                _buildSuccessBanner(primaryContainer, onSurfaceVariant),

                const SizedBox(height: 32),

                const Text(
                  'Dokumen Terunggah',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),

                _buildDocumentCard(
                  'Kartu Identitas (KTP)',
                  'ktp_adi_chandra_2026.jpg',
                  'https://picsum.photos/seed/fljpe3/600/400',
                  primaryColor,
                ),
                const SizedBox(height: 16),
                // _buildDocumentCard(
                //   'Surat Keterangan Sehat',
                //   'surat_dokter_terbaru.pdf',
                //   'https://picsum.photos/seed/6k01jy/600/400',
                //   primaryColor,
                // ),

                const SizedBox(height: 32),

                // Informational Footer[cite: 3]
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lock_outline,
                        size: 18, color: outlineColor),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Data Anda telah tersimpan secara aman dan digunakan hanya untuk proses validasi layanan.',
                        style: TextStyle(
                            color: outlineColor, fontSize: 13, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🚀 FIXED: Menambahkan surfaceColor sebagai parameter[cite: 3]
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: _buildStickyFooter(
          //       context, primaryColor, primaryContainer, surfaceColor),
          // ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSuccessBanner(Color primaryContainer, Color subText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: primaryContainer,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: primaryContainer.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 12))
              ],
            ),
            child:
                const Icon(Icons.check_circle, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          const Text(
            'Verifikasi Berhasil',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 280,
            child: Text(
              'Semua dokumen Anda telah berhasil diverifikasi oleh sistem kami.',
              textAlign: TextAlign.center,
              style: TextStyle(color: subText, fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
      String title, String fileName, String imageUrl, Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomNetworkImage(
                imageUrl: imageUrl, width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(fileName,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 12, color: primary),
                      const SizedBox(width: 6),
                      Text(
                        'TERVERIFIKASI',
                        style: TextStyle(
                            color: primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 FIXED: Sekarang menerima parameter surfaceColor[cite: 3]
  // // Widget _buildStickyFooter(
  // //     BuildContext context, Color primary, Color container, Color surface) {
  // //   return Container(
  // //     padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
  // //     decoration: BoxDecoration(
  // //       gradient: LinearGradient(
  // //         begin: Alignment.topCenter,
  // //         end: Alignment.bottomCenter,
  // //         colors: [
  // //           surface.withOpacity(0),
  // //           surface.withOpacity(0.9),
  // //           surface,
  // //         ],
  // //       ),
  // //     ),
  // //     child: Container(
  // //       width: double.infinity,
  // //       height: 56,
  // //       decoration: BoxDecoration(
  // //         gradient: LinearGradient(colors: [primary, container]),
  // //         borderRadius: BorderRadius.circular(99),
  // //         boxShadow: [
  // //           BoxShadow(
  // //               color: primary.withOpacity(0.2),
  // //               blurRadius: 20,
  // //               offset: const Offset(0, 10))
  // //         ],
  // //       ),
  // //       child: ElevatedButton(
  // //         onPressed: () {
  // //           Navigator.pushReplacementNamed(context, '/home');
  // //         },
  // //         style: ElevatedButton.styleFrom(
  // //           backgroundColor: Colors.transparent,
  // //           shadowColor: Colors.transparent,
  // //           shape:
  // //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
  // //         ),
  // //         child: const Row(
  // //           mainAxisAlignment: MainAxisAlignment.center,
  // //           children: [
  // //             Text(
  // //               'Lanjutkan ke Beranda',
  // //               style: TextStyle(
  // //                   color: Colors.white,
  // //                   fontWeight: FontWeight.bold,
  // //                   fontSize: 16),
  // //             ),
  // //             SizedBox(width: 12),
  // //             Icon(Icons.arrow_forward, color: Colors.white, size: 20),
  // //           ],
  // //         ),
  // //       ),
  //     ),
  //   );
  // }
}
