import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Anti-lemot image loader

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State untuk menyimpan bahasa yang terpilih
  String _currentLanguage = 'Bahasa Indonesia';

  // 🛡️ MODAL: Pemilihan Bahasa
  void _showLanguageModal(BuildContext context) {
    final List<Map<String, String>> languages = [
      {
        'name': 'Bahasa Indonesia',
        'flag':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDDAWZhTJnMgQfWePKREMt26NTco2hweIJ-Ktg1ppZaqaRjIN7AG5dPNbE4fK-MN6dJWZeweoshWOMYNkTrhDLof_Psa23Uib-5dbHI2ioysF1zFtKH-GS5B_vBy6f28qwc3i85Elf0QDBQdkgFVsRXU_VrN5chYFtdQtMhxCia8WVcnl2M1kdOYobS6sMXFm9jKm5bgxpVvHgysACbzWT7nwUVff6kPgc4L-EqaYNEqm4otAgPo16IEwnIozNk1uaLEipuApY96Vxo'
      },
      {
        'name': 'English',
        'flag':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD1mYT6sC7ZNNBixD1k6VLyrROWQhPBOw_XLmAEN04ZuCv9x9I23TC-jZBDHhJ7-PjG1_6PgBavdutU5XQSap9CDZE4oHnNXnnMkMgLTJMqijmqXyToOwXSn1sspxTp55fmfBkmn2FV4k2VTJ1QPg25yN-J94AC040jlCfP0UncwVqKY4b1CJVwQR_9vU7biFVt9BHn3xKLRC7WE5ssNtcz04kll7wgfviZiRePOlkRDr0_OUSf3PBtFe0d2h3s5RHBjEIBW3EPT1CC'
      },
    ];

    String tempLanguage = _currentLanguage;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handlebar
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Modal Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pilih Bahasa',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F3F3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // List Bahasa[cite: 4]
                  ...languages.map((lang) {
                    bool isSelected = tempLanguage == lang['name'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () =>
                            setModalState(() => tempLanguage = lang['name']!),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF3F3F3)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF006C0C)
                                  : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipOval(
                                child: CustomNetworkImage(
                                  imageUrl: lang['flag']!,
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  lang['name']!,
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle,
                                    color: Color(0xFF006C0C))
                              else
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 2),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  // Tombol Simpan[cite: 4]
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF006C0C), Color(0xFF1C871E)],
                        ),
                        borderRadius: BorderRadius.circular(99),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF006C0C).withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _currentLanguage = tempLanguage);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        child: const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color primaryFixed = Color(0xFF92FA83);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);
    const Color errorContainer = Color(0xFFFFDAD6);
    const Color onErrorContainer = Color(0xFF93000A);
    const Color outlineColor = Color(0xFF6F7A6A);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        centerTitle: false,
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
            // User Hero Card[cite: 4]
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
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/edit-profile'),
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
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

            // Settings Group: Akun & Preferensi[cite: 4]
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
                  onTap: () => Navigator.pushNamed(context, '/document-verification')),
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
                subtitle:
                    _currentLanguage, // Update subtitle sesuai state[cite: 4]
                onTap: () =>
                    _showLanguageModal(context), // Trigger modal[cite: 4]
              ),
            ]),

            const SizedBox(height: 32),

            // Settings Group: Bantuan & Info[cite: 4]
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

            // Logout Button[cite: 4]
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
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
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---[cite: 4]

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
