import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Anti-lemot image loader

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai HTML
    const Color primaryColor = Color(0xFF006C0C);
    const Color primaryFixed = Color(0xFF92FA83);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);
    const Color errorContainer = Color(0xFFFFDAD6);
    const Color onErrorContainer = Color(0xFF93000A);
    const Color outlineColor = Color(0xFF6F7A6A);

    return Scaffold(
      backgroundColor: surfaceColor,
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Color(0xFF1A1C1C),
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. User Hero Card (Bento Style)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFEEEEEE), width: 4),
                        ),
                        child: const ClipOval(
                          child: CustomNetworkImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1527631746610-bca00a040d60?q=80&w=400',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4)
                            ],
                          ),
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    // 🚀 Sentuhan personal untuk profil utama
                    'Adi Chandra Isro\' Salsabilla',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Penjelajah Level 12 • 48 Jalur Selesai',
                    style: TextStyle(
                        color: onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 3. Settings Group: Akun & Preferensi
            _buildSectionHeader('AKUN & PREFERENSI', outlineColor),
            _buildSettingsGroup([
              _buildSettingsItem(
                  context, Icons.person, 'Profil', primaryColor, primaryFixed,
                  onTap: () => Navigator.pushNamed(context, '/profile')),
              _buildSettingsItem(context, Icons.shield, 'Keamanan & Privasi',
                  primaryColor, primaryFixed,
                  onTap: () {}),
              _buildSettingsItem(context, Icons.verified_user,
                  'Verifikasi Dokumen', primaryColor, primaryFixed,
                  onTap: () {}),
              _buildSettingsItem(context, Icons.notifications, 'Notifikasi',
                  primaryColor, primaryFixed,
                  onTap: () {}),
              _buildSettingsItem(
                context,
                Icons.language,
                'Bahasa',
                primaryColor,
                primaryFixed,
                subtitle: 'Bahasa Indonesia',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 32),

            // 4. Settings Group: Bantuan & Info
            _buildSectionHeader('BANTUAN & INFO', outlineColor),
            _buildSettingsGroup([
              _buildSettingsItem(context, Icons.help, 'Bantuan & Dukungan',
                  primaryColor, primaryFixed,
                  isPrimary: false, onTap: () {}),
              _buildSettingsItem(context, Icons.info, 'Tentang Aplikasi',
                  primaryColor, primaryFixed,
                  isPrimary: false, onTap: () {}),
            ]),

            const SizedBox(height: 40),

            // 5. Logout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  // 🚀 Logika keluar: Bersihkan navigasi dan kembali ke halaman utama (Dashboard / Login)
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Keluar',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorContainer,
                  foregroundColor: onErrorContainer,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'GuideIn Versi 2.4.0 (Alpine Edition)',
                style: TextStyle(color: outlineColor, fontSize: 12),
              ),
            ),
            const SizedBox(height: 100), // Spacer untuk Bottom Nav
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title,
      Color primaryColor, Color primaryFixed,
      {String? subtitle, bool isPrimary = true, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isPrimary
                    ? primaryFixed.withOpacity(0.3)
                    : const Color(0xFFF3F3F3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: isPrimary ? primaryColor : const Color(0xFF3F4A3B),
                  size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  if (subtitle != null)
                    Text(subtitle,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

}
