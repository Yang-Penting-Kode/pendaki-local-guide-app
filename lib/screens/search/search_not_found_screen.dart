import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart';

class SearchNotFoundScreen extends StatelessWidget {
  const SearchNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai desain HTML
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color secondaryContainer = Color(0xFFC5ECD4);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      // 1. TopAppBar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.search, color: primaryColor),
          onPressed: () {},
        ),
        title: const Text(
          'Cari Alat & Mitra',
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            children: [
              // 2. Empty State Illustration
              _buildEmptyStateIllustration(secondaryContainer, primaryColor),

              const SizedBox(height: 32),

              // 3. Text Content
              const Text(
                'Maaf, hasil tidak ditemukan',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Kami tidak dapat menemukan alat atau mitra yang Anda cari. Coba sesuaikan kata kunci atau ubah filter pencarian Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: onSurfaceVariant, fontSize: 16, height: 1.5),
                ),
              ),

              const SizedBox(height: 40),

              // 4. Action Button
              _buildResetButton(primaryContainer),

              const SizedBox(height: 60),

              // 5. Recommendation Section
              _buildRecommendations(primaryColor, onSurfaceVariant),
            ],
          ),
        ),
      ),
      // 6. BottomNavBar
      bottomNavigationBar: _buildBottomNav(primaryColor),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildEmptyStateIllustration(Color bg, Color iconColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 192,
          height: 192,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: ClipOval(
            child: Opacity(
              opacity: 0.6,
              child: CustomNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=400',
                width: 192,
                height: 192,
              ),
            ),
          ),
        ),
        Icon(Icons.search_off, size: 96, color: iconColor.withOpacity(0.8)),
        Positioned(
          bottom: 0,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
            child: const Icon(Icons.error, color: Colors.red, size: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton(Color bg) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.refresh),
      label: const Text('Atur Ulang Filter',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        elevation: 4,
      ),
    );
  }

  Widget _buildRecommendations(Color primary, Color variant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rekomendasi Populer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Icon(Icons.trending_up, color: primary),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildChip(Icons.hiking, 'Alat Pendaki', primary),
            _buildChip(Icons.campaign, 'Tenda & Camping', primary),
            _buildChip(Icons.map, 'Pemandu Lokal', primary),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(IconData icon, String label, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: primary),
          const SizedBox(width: 8),
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildBottomNav(Color primary) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: BottomNavigationBar(
        currentIndex: 2, // Cari aktif
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'BERANDA'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'BOOKING'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'CARI'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'RIWAYAT'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'PENGATURAN'),
        ],
      ),
    );
  }
}
