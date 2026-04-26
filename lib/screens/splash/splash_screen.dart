import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi animasi untuk icon loading (progress_activity)
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Timer 3 detik lalu pindah ke Onboarding
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definisi warna dari Tailwind Config
    const Color primaryColor = Color(0xFF006C0C); 
    const Color onPrimaryColor = Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: primaryColor, // bg-primary
      body: Stack(
        children: [
          // Ambient background layer (Gradient)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1C871E).withOpacity(0.2), // primary-container/20
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
                // Icon Container dengan Backdrop Blur effect (Simulated)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: onPrimaryColor.withOpacity(0.1), // on-primary/10
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_pin, // person_pin icon
                    size: 80,
                    color: onPrimaryColor,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Local Guide',
                  style: TextStyle(
                    color: onPrimaryColor,
                    fontSize: 48,
                    fontWeight: FontWeight.w800, // font-extrabold
                    letterSpacing: -1.5,
                    fontFamily: 'Manrope', // font-display
                  ),
                ),
              ],
            ),
          ),

          // Footer (Loading & Tagline)
          Positioned(
            bottom: 64, // pb-16
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Animated Loading Icon (progress_activity)
                RotationTransition(
                  turns: _controller,
                  child: Icon(
                    Icons.refresh, // progress_activity equivalent
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
                    letterSpacing: 4.0, // tracking-[0.25em]
                    fontFamily: 'Inter', // font-label
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}