import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() {
  // Nanti kalau ada inisialisasi SharedPreferences, taruh di sini
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LocalGuideApp());
}

class LocalGuideApp extends StatelessWidget {
  const LocalGuideApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Guide',
      theme: ThemeData(
        // Kita set warna dasarnya (bisa disesuaikan nanti dengan warna figma)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF007A52)), 
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _fadeRoute(const SplashScreen());
          case '/onboarding':
            return _fadeRoute(const OnboardingScreen());
          // Nanti kita tambah route login, register, dll di sini
          default:
            return null;
        }
      },
    );
  }

  // 🔄 Fungsi transisi Fade halus antar halaman (diambil dari Rasa App)
  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
          child: child,
        );
      },
    );
  }
}