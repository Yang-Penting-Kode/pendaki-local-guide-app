import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi warna dari Tailwind Config
    const Color primaryColor = Color(0xFF006C0C);
    const Color secondaryColor = Color(0xFF904D00);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: surfaceColor,
      // TopAppBar
      appBar: AppBar(
        backgroundColor: surfaceColor.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF228B22)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lupa Kata Sandi',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1C1C),
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Illustration/Icon Section
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_reset,
                        size: 60,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Typography Section
              const Text(
                'Atur Ulang Kata Sandi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Masukkan email yang terdaftar untuk menerima instruksi pengaturan ulang kata sandi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Form Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '  ALAMAT EMAIL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'nama@email.com',
                      filled: true,
                      fillColor: const Color(0xFFEEEEEE),
                      suffixIcon: Icon(
                        Icons.mail_outline,
                        color: Colors.grey.withOpacity(
                            0.3), // Mengatur transparansi lewat warna
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // 1. Bersihkan banner yang mungkin masih nempel
                    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

                    // 2. Tampilkan Banner di ATAS
                    ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(
                        elevation: 0,
                        backgroundColor:
                            const Color(0xFF006C0C), // Hijau brand kita
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Silahkan cek akun gmail kamu!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentMaterialBanner();
                              Navigator.pushNamed(context, '/reset-password');
                            },
                            child: const Text(
                              'SIMULASI LINK',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner(),
                          ),
                        ],
                      ),
                    );

                    // 3. 🕒 Opsional: Biar otomatis hilang sendiri setelah 3 detik
                    Future.delayed(const Duration(seconds: 3), () {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                    elevation: 4,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kirim Instruksi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.send, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),

              // Decorative Element
              const SizedBox(height: 48),
              Divider(color: Colors.grey.withOpacity(0.3)),
              const SizedBox(height: 16),
              const Text(
                'KEAMANAN TERJAMIN • LOCAL GUIDE DESIGN',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),

              // Support Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.help_outline, color: secondaryColor),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Butuh Bantuan?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Hubungi pusat dukungan kami jika Anda tidak menerima email dalam waktu 5 menit.',
                            style: TextStyle(
                              fontSize: 12,
                              color: onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
