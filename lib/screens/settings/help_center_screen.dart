import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Anti-lemot image loader

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna sesuai desain HTML
    const Color primaryColor = Color(0xFF007A52);
    const Color surfaceLow = Color(0xFFF1F4F0);
    const Color onSurfaceVariant = Color(0xFF424943);

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pusat Bantuan Rental',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFEBEEE9), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            24, 24, 24, 120), // Padding extra untuk footer
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Hero & Search
            const Text(
              'Ada yang bisa dibantu?',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cari solusi untuk penyewaan alat outdoor Anda.',
              style: TextStyle(color: onSurfaceVariant, fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildSearchBar(primaryColor),

            const SizedBox(height: 48),

            // 3. Category Bento Grid
            _buildCategoryGrid(primaryColor, surfaceLow),

            const SizedBox(height: 48),

            // 4. FAQ Section
            const Text(
              'Pertanyaan Populer',
              style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            _buildFAQItem('Bagaimana jika alat yang disewa rusak?'),
            _buildFAQItem('Kebijakan denda keterlambatan pengembalian?'),
            _buildFAQItem('Cara verifikasi ID untuk penyewa baru?'),

            const SizedBox(height: 48),

            // 5. Decorative Visual
            _buildDecorativeBanner(),
          ],
        ),
      ),
      // 6. Support Actions Footer[cite: 1]
      bottomNavigationBar: _buildSupportFooter(primaryColor),
    );
  }

  // --- UI HELPERS ---

  Widget _buildSearchBar(Color primary) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari masalah transaksi, alat, dll...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFF1F4F0),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primary, width: 2)),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(Color primary, Color bg) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildCategoryCard(
            Icons.assignment_return, 'Penyewaan &\nPengembalian', primary, bg),
        _buildCategoryCard(
            Icons.verified_user, 'Jaminan &\nAsuransi Alat', primary, bg),
        _buildCategoryCard(
            Icons.account_balance_wallet, 'Masalah\nTransaksi', primary, bg),
        _buildCategoryCard(
            Icons.inventory_2, 'Kualitas &\nStok Alat', primary, bg),
      ],
    );
  }

  Widget _buildCategoryCard(
      IconData icon, String title, Color primary, Color bg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: primary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: primary, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7E9E6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(question,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14))),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildDecorativeBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomNetworkImage(
              imageUrl:
                  'https://picsum.photos/seed/ghjil1/600/400',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Kesiapan alat Anda adalah\nprioritas kami.',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportFooter(Color primary) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: const Border(top: BorderSide(color: Color(0xFFEBEEE9))),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call, size: 20),
                label: const Text('Pusat Bantuan',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: BorderSide(color: primary, width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                boxShadow: [
                  BoxShadow(
                      color: primary.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat, size: 20),
                label: const Text('Chat Admin',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
