import 'dart:ui';
import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Pastikan import ini benar

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 📝 Konten Edukasi Tutorial Penggunaan Aplikasi
  final List<Map<String, dynamic>> _tutorialData = [
    {
      'badge': 'LANGKAH 1: IDENTITAS',
      'title': 'Verifikasi Akun\nLebih Aman',
      'subtitle':
          'Lengkapi profil dan upload KTP Anda. Akun terverifikasi akan mendapatkan asuransi pendakian otomatis dan limit sewa alat yang lebih besar.',
      'image':
          'https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=800', // Foto profil profesional
      'type': 'full',
      'btnColor': const Color(0xFF006C0C),
    },
    {
      'badge': 'LANGKAH 2: EKSPLORASI',
      'title': 'Pesan Alat &\nCari Pemandu',
      'subtitle':
          'Cari perlengkapan outdoor terbaik berdasarkan basecamp terdekat. Anda juga bisa menyewa jasa pemandu lokal yang sudah bersertifikat.',
      'image':
          'https://images.unsplash.com/photo-1533632359083-0185df1be85d?q=80&w=800', // Foto alat camping premium
      'type': 'bento',
      'btnColor': const Color(0xFF006C0C),
    },
    {
      'badge': 'LANGKAH 3: KEAMANAN',
      'title': 'Tracking & Peta\nOffline',
      'subtitle':
          'Aktifkan Live Tracking saat memulai pendakian. Tetap aman dengan peta offline yang tetap berfungsi meskipun tanpa sinyal internet.',
      'image':
          'https://images.unsplash.com/photo-1526628953301-3e589a6a8b74?q=80&w=800', // Foto navigasi di smartphone
      'type': 'full',
      'btnColor': const Color(0xFF904D00),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // 1. PageView Konten[cite: 6]
          PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemCount: _tutorialData.length,
            itemBuilder: (context, index) => _buildPage(index),
          ),

          // 2. Custom Top Bar[cite: 6]
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.landscape, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'LOCAL GUIDE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (_currentPage < 2)
                  TextButton(
                    onPressed: () => _pageController.jumpToPage(2),
                    child: Text(
                      'Lewati',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    final data = _tutorialData[index];
    final bool isLast = index == 2;

    return Stack(
      children: [
        // Background Image & Gradient[cite: 6]
        Positioned.fill(
          child: CustomNetworkImage(imageUrl: data['image'], fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.5),
                  const Color(0xFFF9F9F9).withOpacity(index == 2 ? 1.0 : 0.85),
                ],
                stops: const [0.0, 0.4, 0.85],
              ),
            ),
          ),
        ),

        // Khusus Halaman 2: Bento Grid Preview (Visualisasi Gear & Guide)[cite: 6]
        if (data['type'] == 'bento')
          Positioned(
            top: 180,
            left: 24,
            right: 24,
            child: Row(
              children: [
                Expanded(
                    child: _buildGlassCard('GEAR',
                        'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=400')),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildGlassCard('GUIDE',
                        'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400')),
              ],
            ),
          ),

        // Text & Action Area[cite: 6]
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge[cite: 6]
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF92FA83).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                      color: const Color(0xFF92FA83).withOpacity(0.3)),
                ),
                child: Text(
                  data['badge'],
                  style: const TextStyle(
                      color: Color(0xFF006C0C),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5),
                ),
              ),
              const SizedBox(height: 24),
              // Headline[cite: 6]
              Text(
                data['title'],
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 34,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1C1C),
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle[cite: 6]
              Text(
                data['subtitle'],
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF404A3C),
                ),
              ),
              const SizedBox(height: 48),

              // Bottom Actions[cite: 6]
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Pagination Dots[cite: 6]
                  Row(
                    children: List.generate(3, (dotIndex) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 6,
                        width: _currentPage == dotIndex ? 24 : 6,
                        decoration: BoxDecoration(
                          color: _currentPage == dotIndex
                              ? const Color(0xFF006C0C)
                              : Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      );
                    }),
                  ),

                  // Action Button[cite: 6]
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      } else {
                        // 🚀 Navigasi ke Beranda
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: data['btnColor'],
                      padding: EdgeInsets.symmetric(
                          horizontal: isLast ? 32 : 20, vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99)),
                      elevation: 0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          isLast ? 'Mulai Sekarang' : 'Lanjut',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        if (!isLast) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward,
                              color: Colors.white, size: 18),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard(String label, String img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            CustomNetworkImage(
                imageUrl: img, fit: BoxFit.cover, width: double.infinity),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
