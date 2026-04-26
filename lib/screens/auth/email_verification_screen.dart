import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color surfaceColor =
        Color(0xFFF9F9F9); // Warna solid penambal ghosting
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      // Pastikan warna background solid biar layar di bawahnya nggak ngintip
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verifikasi Email',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Manrope'),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: surfaceColor, // Double protection biar nggak ghosting
          child: Column(
            children: [
              // Bagian Konten Tengah (Expanded biar fleksibel)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ilustrasi Asimetris
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: const Icon(Icons.mark_email_read_outlined,
                          size: 100, color: primaryColor),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Cek Email Kamu',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Manrope'),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Kami telah mengirimkan tautan verifikasi ke email kamu. Silakan klik tautan tersebut untuk mengaktifkan akun.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, color: onSurfaceVariant, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Tombol Buka Gmail
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/register-success');
                          },
                          icon: Image.network(
                            'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                            height: 20,
                          ),
                          label: const Text(
                            'Buka Gmail',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer (Bagian yang tadinya kepotong)
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Tidak menerima email?',
                        style: TextStyle(color: onSurfaceVariant)),
                    TextButton(
                      onPressed: () {
                        // 🚀 Logic Kirim Ulang & Munculin SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Email sudah dikirim ulang, silahkan cek gmail!',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor:
                                primaryColor, // Pakai hijau brand kita
                            behavior: SnackBarBehavior
                                .floating, // Biar melayang, nggak nempel bawah
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.all(
                                20), // Jarak dari pinggir layar
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      child: const Text(
                        'Kirim Ulang',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
