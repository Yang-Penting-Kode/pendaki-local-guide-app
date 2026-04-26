import 'package:flutter/material.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF007A52);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceColor = Color(0xFF1A1C1C);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);
    const Color outlineVariant = Color(0xFFBECAB7);

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Header Branding
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF92FA83).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.terrain,
                        size: 40,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Local Guide',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                        letterSpacing: -2.0,
                      ),
                    ),
                    const Text(
                      'Marketplace Rental Alat Outdoor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        color: onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // 2. Tombol Daftar dengan Google
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: onSurfaceColor.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Sesuai flow Abang: Lempar ke register
                      Navigator.pushNamed(context, '/register');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: onSurfaceColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                          height: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Daftar dengan Google', // Teks sudah diupdate
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Divider
                Row(
                  children: [
                    Expanded(
                        child: Divider(color: outlineVariant.withOpacity(0.3))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'ATAU',
                        style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6F7A6A)),
                      ),
                    ),
                    Expanded(
                        child: Divider(color: outlineVariant.withOpacity(0.3))),
                  ],
                ),
                const SizedBox(height: 24),

                // 4. Tombol Daftar dengan Email
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: outlineVariant.withOpacity(0.4), width: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99)),
                    ),
                    child: const Text(
                      'Daftar dengan Email',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: onSurfaceColor),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Link Login untuk User Lama
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: onSurfaceVariant),
                    ),
                    GestureDetector(
                      // ✅ Ganti logic-nya jadi pushNamed ke rute email
                      onTap: () {
                        Navigator.pushNamed(context, '/login-email');
                      },
                      child: const Text(
                        'Masuk ke Sini',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
