import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';

class MountainSearchResultScreen extends StatefulWidget {
  final String searchQuery;

  const MountainSearchResultScreen({super.key, required this.searchQuery});

  @override
  State<MountainSearchResultScreen> createState() =>
      _MountainSearchResultScreenState();
}

class _MountainSearchResultScreenState
    extends State<MountainSearchResultScreen> {
  late TextEditingController _searchController;
  late String _currentQuery;

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.searchQuery;
    _searchController = TextEditingController(text: _currentQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchRefresh(String query) {
    if (query.trim().isEmpty) return;
    if (query.toLowerCase() == 'kosong') {
      Navigator.pushReplacementNamed(context, '/search-empty');
    } else {
      setState(() {
        _currentQuery = query;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        // 🚀 FIX: Search Bar interaktif di hasil pencarian
        title: CustomTextField(
          hint: 'Cari gunung lain...',
          controller: _searchController,
          borderRadius: 99,
          showShadow: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          prefixIcon: Icons.search,
          onSubmitted: _handleSearchRefresh,
          suffixIcon: _searchController.text.isNotEmpty ? Icons.close : null,
          onSuffixTap: () => setState(() => _searchController.clear()),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetaInfo(),
            const SizedBox(height: 24),
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
            // Tambahkan hasil lainnya di sini...
            _buildMountainResultCard(
              context,
              title: 'Gunung Arjuno via Purwosari',
              location: 'Pasuruan, Jawa Timur',
              elevation: '3.339 mdpl',
              difficulty: 'SULIT',
              rentalCount: 12,
              imageUrl:
                  'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?q=80&w=400',
            ),
            _buildMountainResultCard(
              context,
              title: 'Gunung Arjuno via Sumber Brantas(Batu)',
              location: 'Pasuruan, Jawa Timur',
              elevation: '3.339 mdpl',
              difficulty: 'SULIT',
              rentalCount: 12,
              imageUrl:
                  'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?q=80&w=400',
            ),
          ],
        ),
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
              text: '"$_currentQuery"',
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
      onTap: () => Navigator.pushNamed(context, '/mountain-detail', arguments: {
        'title': title,
        'location': location,
        'imageUrl': imageUrl,
      }),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: AppColors.surfaceContainerLow,
                          child: const Icon(Icons.broken_image))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Manrope')),
                      const SizedBox(height: 8),
                      _buildIconText(Icons.location_on_outlined, location),
                      _buildIconText(Icons.landscape_outlined, elevation),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              children: [
                const Icon(Icons.storefront_outlined,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('$rentalCount Mitra Rental di sekitar basecamp',
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
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
