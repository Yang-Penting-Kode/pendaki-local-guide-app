import 'package:flutter/material.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data konten dari 3 file HTML
  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Penyewaan Alat\nOutdoor Terpercaya',
      'subtitle':
          'Sewa perlengkapan pendakian berkualitas tinggi dari mitra lokal kami yang berada dekat dengan basecamp tujuan Anda.',
      'image':
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80&w=1000',
      'badge': 'Sewa Peralatan',
    },
    {
      'title': 'Eksplorasi Tanpa\nBatas & Aman',
      'subtitle':
          'Dilengkapi dengan sistem tracking dan peta offline untuk memastikan keamanan pendakian Anda di medan manapun.',
      'image':
          'https://images.unsplash.com/photo-1501555088652-021faa106b9b?auto=format&fit=crop&q=80&w=1000',
      'badge': 'Live Tracking',
    },
    {
      'title': 'Sewa Alat Outdoor\nTerlengkap',
      'subtitle':
          'Sewa berbagai perlengkapan mendaki gunung berkualitas dari mitra lokal terpercaya dengan mudah dan cepat.',
      'image':
          'https://images.unsplash.com/photo-1526772662000-3f88f10405ff?auto=format&fit=crop&q=80&w=1000',
      'badge': 'Mitra Lokal',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // 1. PageView untuk konten onboarding
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return _buildPageContent(index);
            },
          ),

          // 2. Custom Top Bar (Landscape & Lewati)
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.landscape,
                          color: Color(0xFF228B22), size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'LOCAL GUIDE',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: -0.5,
                          color: const Color(0xFF228B22),
                        ),
                      ),
                    ],
                  ),
                  if (_currentPage !=
                      2) // Sembunyikan 'Lewati' di halaman terakhir
                    TextButton(
                      onPressed: () => _pageController.jumpToPage(2),
                      child: Text(
                        'Lewati',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index) {
    final data = _onboardingData[index];
    return Stack(
      children: [
        // Background Image dengan Atmospheric Overlay
        Positioned.fill(
          child: Image.network(
            data['image']!,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black45,
                  Colors.black,
                ],
              ),
            ),
          ),
        ),

        // Text & Action Area
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Text(
                  data['badge']!.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Headline
              Text(
                data['title']!,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 48,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 24),
              // Subtitle
              Text(
                data['subtitle']!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 48),
              // Button & Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Navigasi ke Login
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: index == 2
                          ? const Color(0xFF904D00)
                          : const Color(0xFF006C0C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(index == 2 ? 'Mulai Sekarang' : 'Lanjut',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        const SizedBox(width: 12),
                        const Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                  // Pagination Dots
                  Row(
                    children: List.generate(3, (dotIndex) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(left: 6),
                        height: 6,
                        width: _currentPage == dotIndex ? 24 : 6,
                        decoration: BoxDecoration(
                          color: _currentPage == dotIndex
                              ? const Color(0xFF92FA83)
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
