import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  bool _isBiometricEnabled = false;
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // 🛡️ MODAL 1: Konfirmasi Login Biometrik (FIX OVERFLOW)
  void _showBiometricConfirmation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // 🚀 FIX 1: Biar modal bisa fleksibel melebihi 50% layar
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        // 🚀 FIX 2: Gunakan padding dinamis agar aman di HP dengan notch bawah
        padding: EdgeInsets.only(
            left: 32,
            right: 32,
            top: 16,
            bottom: MediaQuery.of(context).padding.bottom + 24),
        child: SingleChildScrollView(
          // 🚀 FIX 3: Bungkus dengan SingleChildScrollView agar konten bisa di-scroll jika layar kecil
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 32),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                    color: const Color(0xFF006C0C).withOpacity(0.1),
                    shape: BoxShape.circle),
                child: const Icon(Icons.fingerprint,
                    size: 64, color: Color(0xFF006C0C)),
              ),
              const SizedBox(height: 24),
              const Text('Aktifkan Login Biometrik?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5)),
              const SizedBox(height: 12),
              const Text(
                  'Gunakan sidik jari atau pengenalan wajah untuk akses yang lebih cepat dan aman ke akun LocalGuide Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF3F4A3B), fontSize: 14, height: 1.5)),
              const SizedBox(
                  height:
                      32), // 🚀 Dikecilkan dikit dari 40 ke 32 biar lebih pas
              // Button Aktifkan Sekarang
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF006C0C), Color(0xFF1C871E)]),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showPasswordVerification();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white),
                    child: const Text('Aktifkan Sekarang',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ),
              const SizedBox(height: 8), // 🚀 Dikecilkan dikit dari 12 ke 8
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nanti Saja',
                    style: TextStyle(
                        color: Color(0xFF3F4A3B), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🛡️ MODAL 2: Verifikasi Kata Sandi
  void _showPasswordVerification() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Biar tidak tertutup keyboard
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 32),
                const Text('Verifikasi Kata Sandi',
                    style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 24,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                const Text(
                    'Masukkan kata sandi akun LocalGuide Anda untuk melanjutkan pengaktifan login biometrik.',
                    style: TextStyle(
                        color: Color(0xFF3F4A3B), fontSize: 14, height: 1.5)),
                const SizedBox(height: 32),
                const Text('KATA SANDI',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3F4A3B),
                        letterSpacing: 1.5)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Masukkan kata sandi Anda',
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF006C0C))),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey),
                      onPressed: () => setModalState(
                          () => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF006C0C), Color(0xFF1C871E)]),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _isBiometricEnabled = true);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Login Biometrik Berhasil Aktif!'),
                                backgroundColor: Color(0xFF006C0C)));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white),
                      child: const Text('Konfirmasi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
                Center(
                    child: TextButton(
                        onPressed: () {},
                        child: const Text('Lupa Kata Sandi?',
                            style: TextStyle(
                                color: Color(0xFF006C0C),
                                fontWeight: FontWeight.bold)))),
                const SizedBox(height: 24),
                const Center(
                  child: Column(
                    children: [
                      Text('LocalGuide',
                          style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black12)),
                      Text('SECURE TACTICAL SHIELD',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.black12,
                              letterSpacing: 2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color primaryContainer = Color(0xFF1C871E);
    const Color surfaceColor = Color(0xFFF9F9F9);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: primaryColor),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Keamanan & Privasi',
            style: TextStyle(
                color: primaryColor,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSafetyBanner(primaryContainer),
            const SizedBox(height: 32),
            _buildSectionHeader('Keamanan Akun'),
            _buildSettingsGroup([
              _buildOptionTile(Icons.lock_reset, 'Ubah Kata Sandi',
                  onTap: () =>
                      Navigator.pushNamed(context, '/change-password')),
              _buildOptionTile(Icons.verified_user, 'Otentikasi Dua Faktor',
                  subtitle: 'Lapisan keamanan tambahan untuk login',
                  onTap: () {}),
              // 🚀 Trigger: Klik switch untuk modal biometric[cite: 6]
              _buildSwitchTile(Icons.fingerprint, 'Login Biometrik'),
            ]),
            const SizedBox(height: 32),
            _buildSectionHeader('Legalitas'),
            _buildSettingsGroup([
              _buildOptionTile(Icons.description, 'Syarat & Ketentuan',
                  onTap: () =>
                      Navigator.pushNamed(context, '/terms-conditions')),
              _buildOptionTile(Icons.policy, 'Kebijakan Privasi',
                  onTap: () => Navigator.pushNamed(context, '/privacy-policy')),
            ]),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                    child: _buildBentoCard(
                        Icons.gpp_maybe,
                        'Pusat Bantuan',
                        'Butuh bantuan terkait keamanan akun?',
                        'Hubungi Kami',
                        Icons.support_agent)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildBentoCard(
                        Icons.history,
                        'Riwayat Login',
                        'Pantau aktivitas akses masuk terakhir Anda.',
                        'Lihat Semua',
                        Icons.manage_search)),
              ],
            ),
            const SizedBox(height: 48),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSafetyBanner(Color bg) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: bg.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.security, color: Colors.white, size: 32)),
          const SizedBox(width: 16),
          const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Kami berkomitmen menjaga data Anda',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Manrope')),
                SizedBox(height: 4),
                Text(
                    'Privasi Anda adalah prioritas utama kami. LocalGuide menggunakan enkripsi tingkat lanjut.',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ])),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 16),
        child: Text(title,
            style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                fontSize: 20)));
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100)),
        child: Column(children: children));
  }

  Widget _buildOptionTile(IconData icon, String title,
      {String? subtitle, required VoidCallback onTap}) {
    return InkWell(
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Icon(icon, color: const Color(0xFF007A52)),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    if (subtitle != null)
                      Text(subtitle,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                  ])),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ])));
  }

  Widget _buildSwitchTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(Icons.fingerprint, color: Color(0xFF007A52)),
          const SizedBox(width: 16),
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15))),
          CupertinoSwitch(
            activeColor: const Color(0xFF007A52),
            value: _isBiometricEnabled,
            onChanged: (val) {
              if (val) {
                _showBiometricConfirmation(); // 🚀 Trigger modal[cite: 6]
              } else {
                setState(() => _isBiometricEnabled = false);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCard(IconData icon, String title, String desc,
      String btnText, IconData bgIcon) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100)),
      child: Stack(children: [
        Positioned(
            right: -20,
            bottom: -20,
            child:
                Icon(bgIcon, size: 100, color: Colors.grey.withOpacity(0.05))),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: const Color(0xFF007A52)),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 4),
          Text(desc,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              maxLines: 2),
          const Spacer(),
          Text(btnText,
              style: const TextStyle(
                  color: Color(0xFF007A52),
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ]),
      ]),
    );
  }

  Widget _buildFooter() {
    return Column(children: [
      const Text('Versi Aplikasi 2.4.1 (Mountain Kit Official)',
          style: TextStyle(color: Colors.grey, fontSize: 11)),
      const SizedBox(height: 12),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              3,
              (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: Colors.grey, shape: BoxShape.circle)))),
    ]);
  }
}
