import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // 1. Controller untuk animasi masuk (Bouncy Logo & Fade Text)
  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // 2. Controller untuk icon loading yang berputar terus
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();

    // Setup Animasi Masuk (Durasi 2 detik)
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Efek Bouncy (Memantul) untuk Logo
    _scaleAnimation = CurvedAnimation(
      parent: _entranceController,
      curve:
          const Interval(0.0, 0.6, curve: Curves.elasticOut), // Spring physics
    );

    // Efek Fade In lambat untuk Teks agar elegan
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );

    // Jalankan animasi masuk 1 kali
    _entranceController.forward();

    // Setup Animasi Spinning (Berulang)[cite: 6]
    _spinController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Timer 3 detik lalu pindah ke Onboarding[cite: 6]
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color onPrimaryColor = Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          // Ambient background layer (Gradient)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1C871E).withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Main Content (Logo & Title)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🚀 ANIMASI: Logo memantul (ScaleTransition)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: onPrimaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_pin,
                      size: 80,
                      color: onPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 🚀 ANIMASI: Teks muncul perlahan (FadeTransition)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Local Guide',
                    style: TextStyle(
                      color: onPrimaryColor,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Footer (Loading & Tagline)[cite: 6]
          Positioned(
            bottom: 64,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation, // Tagline ikut fade-in bareng teks utama
              child: Column(
                children: [
                  // Animated Loading Icon (progress_activity)
                  RotationTransition(
                    turns: _spinController,
                    child: Icon(
                      Icons.refresh,
                      color: onPrimaryColor.withOpacity(0.8),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'MARKETPLACE RENTAL ALAT OUTDOOR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: onPrimaryColor.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4.0,
                      fontFamily: 'Inter',
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
}
