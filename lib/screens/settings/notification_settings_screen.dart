import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/custom_image.dart'; // 🚀 Anti-lemot image loader

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // State untuk toggle
  bool _statusPesanan = true;
  bool _pengingatKembali = true;
  bool _cuacaEkstrem = true;
  bool _updateJalur = false;
  bool _promoInfo = false;
  bool _updateApp = true;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color secondaryColor = Color(0xFF904D00);
    const Color tertiaryColor = Color(0xFFA52A66);
    const Color surfaceContainer = Color(0xFFEEEEEE);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF007A52)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan Notifikasi',
          style: TextStyle(
            color: Color(0xFF1A1C1C),
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.only(right: 24),
        //     child: Center(
        //       child: Text(
        //         'Mountain Kit',
        //         style: TextStyle(
        //           color: Color(0xFF00560A),
        //           fontFamily: 'Manrope',
        //           fontWeight: FontWeight.w900,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Hero Visual Card
            _buildHeroCard(),

            const SizedBox(height: 40),

            // 3. Section 1: Aktivitas Booking
            _buildSectionHeader(
                Icons.confirmation_number, 'Aktivitas Booking', primaryColor),
            _buildNotificationItem(
              'Status Pesanan',
              'Pembaruan mengenai konfirmasi booking dan kedatangan pemandu.',
              _statusPesanan,
              (val) => setState(() => _statusPesanan = val),
            ),
            _buildNotificationItem(
              'Pengingat Pengembalian',
              'Notifikasi untuk tenggat waktu pengembalian alat pendakian.',
              _pengingatKembali,
              (val) => setState(() => _pengingatKembali = val),
            ),

            const SizedBox(height: 32),

            // 4. Section 2: Keamanan & Cuaca
            _buildSectionHeader(
                Icons.warning, 'Keamanan & Cuaca', secondaryColor),
            _buildNotificationItem(
              'Peringatan Cuaca Ekstrem',
              'Peringatan langsung untuk ancaman cuaca di sepanjang jalur pendakian.',
              _cuacaEkstrem,
              (val) => setState(() => _cuacaEkstrem = val),
              hasLeftBorder: true,
              borderColor: secondaryColor,
            ),
            _buildNotificationItem(
              'Pembaruan Jalur',
              'Informasi penutupan jalur atau peringatan keamanan terkini.',
              _updateJalur,
              (val) => setState(() => _updateJalur = val),
            ),

            const SizedBox(height: 32),

            // 5. Section 3: Promosi & Info
            _buildSectionHeader(
                Icons.campaign, 'Promosi & Info', tertiaryColor),
            _buildNotificationItem(
              'Promo & Penawaran',
              'Pemberitahuan pemasaran dan penawaran khusus paket wisata.',
              _promoInfo,
              (val) => setState(() => _promoInfo = val),
            ),
            _buildNotificationItem(
              'Update Aplikasi',
              'Pengumuman fitur baru dan peningkatan aplikasi.',
              _updateApp,
              (val) => setState(() => _updateApp = val),
            ),

            const SizedBox(height: 32),

            // 6. Footer Visual Card[cite: 1]
            _buildFooterCard(primaryColor),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeroCard() {
    return Container(
      height: 192,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFEEEEEE),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1000',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
              ),
            ),
          ),
          const Positioned(
            bottom: 24,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelola Pemberitahuan',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Tetap terinformasi di setiap perjalanan',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String desc,
    bool value,
    Function(bool) onChanged, {
    bool hasLeftBorder = false,
    Color borderColor = Colors.transparent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
        border: hasLeftBorder
            ? Border(left: BorderSide(color: borderColor, width: 4))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                      color: Color(0xFF3F4A3B), fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CupertinoSwitch(
            value: value,
            activeColor: const Color(0xFF00560A),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterCard(Color primary) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: primary, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: primary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.bolt, color: primary, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sinkronisasi Real-time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Perubahan disimpan secara otomatis ke akun Anda.',
                  style: TextStyle(color: Color(0xFF3F4A3B), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
