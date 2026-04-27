import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Anti-lemot image loader

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai desain HTML
    const Color primaryColor = Color(0xFF006C0C);
    const Color primaryFixed = Color(0xFF92FA83);
    const Color secondaryFixed = Color(0xFFFFDCC3);
    const Color secondaryColor = Color(0xFF904D00);
    const Color onSurface = Color(0xFF1A1C1C);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);
    const Color errorColor = Color(0xFFBA1A1A);

    return Scaffold(
      backgroundColor: Colors.white,
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
          'Akun GuideIn',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {
              // Arahkan ke Settings Screen jika diperlukan
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.withOpacity(0.1), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            // 2. Profile Header Section
            _buildProfileHeader(primaryColor, secondaryFixed, secondaryColor, onSurfaceVariant),

            const SizedBox(height: 32),

            // 3. Stats Grid: Marketplace & Rental Focus
            _buildStatsGrid(primaryColor, onSurfaceVariant),

            const SizedBox(height: 32),

            // 4. Achievements Section (Badge Marketplace)
            _buildAchievementsSection(primaryColor, primaryFixed, secondaryFixed, secondaryColor),

            const SizedBox(height: 32),

            // 5. Account Menu List
            _buildAccountMenu(context, primaryColor),

            const SizedBox(height: 32),

            // 6. Logout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Kembali ke rute awal (misal: Auth Gate atau Splash)
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Keluar Sesi', style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: errorColor,
                  side: BorderSide(color: errorColor.withOpacity(0.2)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: errorColor.withOpacity(0.05),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'GUIDEIN V2.4.0 • LOCAL GUIDE MARKETPLACE',
              style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildProfileHeader(Color primary, Color badgeBg, Color badgeText, Color variantText) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const ClipOval(
                child: CustomNetworkImage(
                  imageUrl: 'https://images.unsplash.com/photo-1527631746610-bca00a040d60?q=80&w=400',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: primary, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]),
              child: const Icon(Icons.photo_camera, color: Colors.white, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Adi Chandra Isro\' Salsabilla',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Manrope', fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(99)),
              child: Text('Penyewa Elit', style: TextStyle(color: badgeText, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('•', style: TextStyle(color: Colors.grey))),
            const Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text('Malang, Indonesia', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid(Color primary, Color variantText) {
    return Row(
      children: [
        _buildStatItem('12', 'PENYEWAAN', primary, variantText),
        const SizedBox(width: 12),
        _buildStatItem('8', 'ULASAN', primary, variantText),
        const SizedBox(width: 12),
        _buildStatItem('4.9', 'RATING', primary, variantText, icon: Icons.star),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, Color primary, Color variantText, {IconData? icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: TextStyle(color: primary, fontFamily: 'Manrope', fontSize: 24, fontWeight: FontWeight.w800)),
                if (icon != null) ...[
                  const SizedBox(width: 4),
                  Icon(icon, color: primary, size: 14),
                ]
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: variantText, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(Color primary, Color primaryFixed, Color secondaryFixed, Color secondaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('BADGE MARKETPLACE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1.5)),
            Text('Lihat Semua', style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildBadgeItem(Icons.inventory_2, 'Gear\nMaster', primaryFixed, primary),
              _buildBadgeItem(Icons.verified, 'Trusted\nUser', secondaryFixed, secondaryColor),
              _buildBadgeItem(Icons.handshake, 'Good\nPartner', const Color(0xFFF3F3F3), Colors.grey, isActive: false),
              _buildBadgeItem(Icons.eco, 'Eco\nTraveler', const Color(0xFFF3F3F3), Colors.grey, isActive: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeItem(IconData icon, String label, Color bg, Color iconColor, {bool isActive = true}) {
    return Container(
      width: 84,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountMenu(BuildContext context, Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.shopping_bag, 'Pesanan & Penyewaan', primary, onTap: () {}),
          const Divider(height: 1, indent: 56),
          _buildMenuItem(context, Icons.verified_user, 'Verifikasi Identitas', primary, isVerified: true, onTap: () {}),
          const Divider(height: 1, indent: 56),
          _buildMenuItem(context, Icons.favorite, 'Wishlist Alat Outdoor', primary, onTap: () {}),
          const Divider(height: 1, indent: 56),
          _buildMenuItem(context, Icons.help_center, 'Pusat Bantuan & Kebijakan', primary, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Color primary, {bool isVerified = false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: primary, size: 22),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
            if (isVerified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFD1FADF), borderRadius: BorderRadius.circular(99)),
                child: const Text('TERVERIFIKASI', style: TextStyle(color: Color(0xFF005307), fontSize: 8, fontWeight: FontWeight.bold)),
              )
            else
              const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}