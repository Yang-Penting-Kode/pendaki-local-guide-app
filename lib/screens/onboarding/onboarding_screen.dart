import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/services/storage_services.dart';
import '../../models/onboarding_model.dart';
import '../../providers/onboarding_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final OnboardingProvider _provider = OnboardingProvider();

  // 🚀 Controller untuk animasi Bouncy pada tombol
  late AnimationController _btnController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Inisialisasi efek pegas tombol (Gojek Style)
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05, // Mengecil 5% saat ditekan
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _btnController.dispose();
    super.dispose();
  }

  // 🛠️ LOGIK: Navigasi & Simpan Status
  void _handleNext() async {
    if (_currentPage < _provider.slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // 💾 Simpan status "sudah lihat onboarding" agar tidak muncul lagi
      await StorageService.markOnboardingSeen();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // 1. PageView Konten (Data dari Provider)[cite: 13]
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) => setState(() => _currentPage = page),
            itemCount: _provider.slides.length,
            itemBuilder: (context, index) {
              return _buildSlideContent(_provider.slides[index]);
            },
          ),

          // 2. Custom Top Bar (Logo & Skip)[cite: 13]
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: _buildTopBar(),
          ),
        ],
      ),
    );
  }

  // --- 🧱 SUB-WIDGET HELPERS ---

  Widget _buildSlideContent(OnboardingModel slide) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.network(
            slide.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade800,
              child: const Center(
                child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
              ),
            ),
          ),
        ),
        // Dark Gradient Overlay agar teks terbaca[cite: 13]
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black45, Colors.black],
              ),
            ),
          ),
        ),
        // Area Teks & Action
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBadge(slide.badge),
              const SizedBox(height: 24),
              Text(
                slide.title,
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
              Text(
                slide.subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 48),
              _buildBottomActionRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.landscape, color: Color(0xFF228B22), size: 28),
              SizedBox(width: 8),
              Text(
                'Mountain Kit',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.5,
                  color: Color(0xFF228B22),
                ),
              ),
            ],
          ),
          if (_currentPage != 2)
            TextButton(
              onPressed: () => _pageController.jumpToPage(2),
              child: Text(
                'Lewati',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildBottomActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 🚀 TOMBOL BOUNCY (Gojek Style)[cite: 13]
        GestureDetector(
          onTapDown: (_) => _btnController.forward(),
          onTapUp: (_) {
            _btnController.reverse();
            _handleNext();
          },
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 0.95).animate(
              CurvedAnimation(parent: _btnController, curve: Curves.easeOut),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: _currentPage == 2
                    ? const Color(0xFF006C0C)
                    : const Color(0xFF006C0C),
                borderRadius: BorderRadius.circular(99),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentPage == 2 ? 'Mulai Sekarang' : 'Lanjut',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        // Pagination Dots[cite: 13]
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
    );
  }
}
