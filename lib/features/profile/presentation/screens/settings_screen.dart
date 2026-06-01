import 'package:flutter/material.dart';
import '../../../../widgets/custom_image.dart';
import '../../../../components/modals/language_modal.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/auth/providers/auth_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/auth/user_model.dart';
import 'package:pendaki_local_guide_app/features/settings/providers/settings_provider.dart'; // 🚀 Import Provider baru

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // 🚀 Inisialisasi Provider (Manual sebelum migrasi penuh ke Riverpod)
  final SettingsProvider _settingsProvider = SettingsProvider();

  @override
  void initState() {
    super.initState();
    // 🔄 Mendaftarkan listener agar UI update otomatis saat data di Provider berubah
    _settingsProvider.addListener(_onProviderUpdate);
  }

  @override
  void dispose() {
    // 🧹 Membersihkan listener saat layar ditutup agar tidak memory leak
    _settingsProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }

  void _onProviderUpdate() {
    if (mounted) setState(() {});
  }

  void _showNotificationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          heightFactor: 1,
          child: Text('Belum ada notifikasi baru', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // 🛡️ MODAL: Pemilihan Bahasa (Sudah bersih, data diambil dari Provider)
  void _showLanguageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors
          .transparent, // Transparan agar border radius modal terlihat[cite: 10]
      isScrollControlled: true,
      builder: (context) => LanguageModal(
        initialLanguage: _settingsProvider.currentLanguage,
        languages:
            _settingsProvider.availableLanguages, // Ambil list dari Provider
        onLanguageSelected: (selectedLanguage) {
          // 🚀 Update data melalui provider (otomatis simpan ke SharedPreferences)[cite: 8, 9]
          _settingsProvider.updateLanguage(selectedLanguage);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    // Warna sesuai desain Alpine Minimalist[cite: 10]
    const Color primaryColor = Color(0xFF006C0C);
    const Color primaryFixed = Color(0xFF92FA83);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);
    const Color outlineColor = Color(0xFF6F7A6A);
    const Color errorContainer = Color(0xFFFFDAD6);
    const Color onErrorContainer = Color(0xFF93000A);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Color(0xFF1A1C1C),
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => _showNotificationModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 User Hero Card
            _buildUserHeroCard(primaryColor, onSurfaceVariant, user),

            const SizedBox(height: 32),

            // ⚙️ Settings Group: Akun & Preferensi
            _buildSectionHeader('AKUN & PREFERENSI', outlineColor),
            _buildSettingsGroup([
              _buildSettingsItem(
                  context, Icons.person, 'Profil', primaryColor, primaryFixed,
                  onTap: () => Navigator.pushNamed(context, '/profile')),
              _buildSettingsItem(context, Icons.shield, 'Keamanan & Privasi',
                  primaryColor, primaryFixed,
                  onTap: () =>
                      Navigator.pushNamed(context, '/security-privacy')),
              _buildSettingsItem(context, Icons.verified_user,
                  'Verifikasi Dokumen', primaryColor, primaryFixed,
                  onTap: () =>
                      Navigator.pushNamed(context, '/document-verification')),
              _buildSettingsItem(context, Icons.notifications, 'Notifikasi',
                  primaryColor, primaryFixed,
                  onTap: () =>
                      Navigator.pushNamed(context, '/notification-settings')),
              _buildSettingsItem(
                context,
                Icons.language,
                'Bahasa',
                primaryColor,
                primaryFixed,
                subtitle: _settingsProvider
                    .currentLanguage, // 🚀 REAKTIF: Data dari Provider[cite: 9]
                onTap: () => _showLanguageModal(context),
              ),
            ]),

            const SizedBox(height: 32),

            // ℹ️ Settings Group: Bantuan & Info
            _buildSectionHeader('BANTUAN & INFO', outlineColor),
            _buildSettingsGroup([
              _buildSettingsItem(context, Icons.help, 'Bantuan & Dukungan',
                  primaryColor, primaryFixed,
                  isPrimary: false,
                  onTap: () => Navigator.pushNamed(context, '/help-center')),
              _buildSettingsItem(context, Icons.info, 'Tentang Aplikasi',
                  primaryColor, primaryFixed,
                  isPrimary: false,
                  onTap: () => Navigator.pushNamed(context, '/about-app')),
            ]),

            const SizedBox(height: 40),

            // 🚪 Logout Button
            _buildLogoutButton(context, errorContainer, onErrorContainer),

            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Mountain Kit Versi 2.4.0 (Alpine Edition)',
                style: TextStyle(color: outlineColor, fontSize: 12),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- 🛠️ SUB-WIDGET HELPERS ---

  Widget _buildUserHeroCard(Color primary, Color variantText, UserModel? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4))
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
                  border: Border.all(color: const Color(0xFFEEEEEE), width: 4),
                ),
                child: ClipOval(
                  child: user?.profilePhotoUrl != null
                      ? Image.file(File(user!.profilePhotoUrl!), fit: BoxFit.cover, width: 96, height: 96)
                      : const CustomNetworkImage(
                          imageUrl:
                              'https://picsum.photos/seed/77yjdx/600/400',
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user?.fullName ?? 'Pendaki',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Penjelajah Level 12 • 48 Jalur Selesai',
            style: TextStyle(
                color: variantText, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(
      BuildContext context, Color bgColor, Color textColor) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          ref.read(authProvider.notifier).logout();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        },
        icon: const Icon(Icons.logout, size: 20),
        label: const Text('Keluar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(title,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: color)),
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
      Color primary, Color primaryFixed,
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
                  shape: BoxShape.circle),
              child: Icon(icon,
                  color: isPrimary ? primary : const Color(0xFF3F4A3B),
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
