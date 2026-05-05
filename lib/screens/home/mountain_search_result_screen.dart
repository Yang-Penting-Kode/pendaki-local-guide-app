import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart'; // 🚀 Pastikan import ini benar

class MountainSearchResultScreen extends StatelessWidget {
  final String searchQuery;

  const MountainSearchResultScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.surface, // ⚪ Gunakan warna permukaan global[cite: 2]
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildSearchHeader(context),
      ),
      body: SingleChildScrollView(
        // 🚀 BouncingScrollPhysics memberikan efek premium saat mentok di HP VIVO
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Info Meta
            _buildMetaInfo(),
            const SizedBox(height: 24),

            // 1. Daftar Hasil Pencarian
            _buildMountainResultCard(
              context,
              title: 'Gunung Arjuno via Tretes',
              location: 'Pasuruan, Jawa Timur',
              elevation: '3.339 mdpl',
              difficulty: 'SULIT',
              rentalCount: 12,
              imageUrl:
                  'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?q=80&w=400',
            ),
            const SizedBox(height: 16),
            _buildMountainResultCard(
              context,
              title: 'Gunung Arjuno via Purwosari',
              location: 'Pasuruan, Jawa Timur',
              elevation: '3.339 mdpl',
              difficulty: 'SULIT',
              rentalCount: 8,
              imageUrl:
                  'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400',
            ),
            const SizedBox(height: 16),
            _buildMountainResultCard(
              context,
              title: 'Gunung Arjuno via Lawang',
              location: 'Malang, Jawa Timur',
              elevation: '3.339 mdpl',
              difficulty: 'SULIT',
              rentalCount: 15,
              imageUrl:
                  'https://images.unsplash.com/photo-1588392382834-a8af9f50e869?q=80&w=400',
            ),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildSearchHeader(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors
            .surfaceContainerLow, // 🚀 Gunakan token container low[cite: 2]
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.outline, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              searchQuery,
              overflow: TextOverflow
                  .ellipsis, // 🚀 Cegah teks overflow di layar kecil
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              fontFamily: 'Inter'),
          children: [
            const TextSpan(text: 'Menampilkan hasil untuk '),
            TextSpan(
              text: '"$searchQuery"',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMountainResultCard(
    BuildContext context, {
    required String title,
    required String location,
    required String elevation,
    required String difficulty,
    required int rentalCount,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        // 🚀 Navigasi ke detail dengan data lengkap
        Navigator.pushNamed(context, '/mountain-detail', arguments: {
          'title': title,
          'location': location,
          'imageUrl': imageUrl,
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 80, height: 80,
                    fit: BoxFit.cover,
                    // 🚀 FIX: Tangani gambar 404 agar tidak muncul error merah di terminal
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.surfaceContainerLow,
                      child: const Icon(Icons.broken_image,
                          color: AppColors.outline),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          _buildDifficultyChip(difficulty),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildIconText(Icons.location_on_outlined, location),
                      const SizedBox(height: 4),
                      _buildIconText(Icons.landscape_outlined, elevation),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.surfaceContainer),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.storefront_outlined,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('$rentalCount Mitra Rental di sekitar basecamp',
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(99)),
      child: Text(text,
          style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 9,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.outline),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(color: AppColors.outline, fontSize: 12)),
      ],
    );
  }
}
