import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 🎨 Konfigurasi Warna Alpine
  final Color primaryGreen = const Color(0xFF006C0C);
  final Color secondaryOrange = const Color(0xFF904D00);
  final Color background = const Color(0xFFF9F9F9);
  final Color textGrey = const Color(0xFF3F4A3B);

  // 📝 Data Konten sesuai HTML Onboarding 1, 2, 3
  final List<Map<String, String>> _pages = [
    {
      'title': 'Sewa Alat di Basecamp',
      'desc':
          'Pesan perlengkapan mendaki dari mitra lokal di sekitar basecamp. Aman, praktis, dan terpercaya.',
      'image':
          'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=600',
      'icon': 'backpack',
    },
    {
      'title': 'Pendakian Lebih Terorganisir',
      'desc':
          'Atur jadwal, pilih rute, dan koordinasi dengan tim dalam satu aplikasi yang terintegrasi.',
      'image':
          'https://images.unsplash.com/photo-1515408320194-59643816c5b2?q=80&w=600',
      'icon': 'terrain',
    },
    {
      'title': 'Sewa Alat & Guide Lebih Aman',
      'desc':
          'Temukan guide lokal terpercaya. Dilengkapi fitur pantau posisi real-time dan SOS darurat bahkan saat offline.',
      'image':
          'https://images.unsplash.com/photo-1526628953301-3e589a6a8b74?q=80&w=600',
      'icon': 'emergency',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // 1. AREA KONTEN (PAGEVIEW)
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) => setState(() => _currentPage = page),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPageContent(_pages[index]);
            },
          ),

          // 2. FIXED HEADER (STAY STILL)
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: _buildHeader(),
          ),

          // 3. FIXED BOTTOM ACTIONS (STAY STILL)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomActions(),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: HEADER ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: primaryGreen),
          ),
          const Text(
            'Alpine',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF005307),
              letterSpacing: -1,
            ),
          ),
          TextButton(
            onPressed: () => _pageController.jumpToPage(2),
            child: Text(
              'Skip',
              style: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.bold,
                fontFamily: 'Manrope',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: PAGE CONTENT ---
  Widget _buildPageContent(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hero Image Container
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  CustomNetworkImage(
                    imageUrl: data['image']!,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          background.withOpacity(0.4)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Typography
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title']!,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data['desc']!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: textGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Spacer agar konten tidak tertutup bottom action
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: BOTTOM ACTIONS ---
  Widget _buildBottomActions() {
    bool isLast = _currentPage == 2;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 8),
                height: 8,
                width: _currentPage == index ? 32 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? primaryGreen
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(99),
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          // Primary Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (isLast) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isLast ? secondaryOrange : primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // 🚀 FIX: Solusi Infinite Width
                children: [
                  Text(
                    isLast ? 'Mulai Sekarang' : 'Lanjutkan',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
