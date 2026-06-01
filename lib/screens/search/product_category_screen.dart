import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_image.dart';

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({super.key});

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🚀 FIX: Menggunakan ikon yang pasti ada di semua versi Flutter
  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.terrain_rounded, 'title': 'Tenda', 'count': '12 Alat'},
    {'icon': Icons.backpack_rounded, 'title': 'Carrier', 'count': '24 Alat'},
    {'icon': Icons.hiking_rounded, 'title': 'Sepatu', 'count': '18 Alat'},
    {
      'icon': Icons.outdoor_grill_rounded,
      'title': 'Alat Masak',
      'count': '32 Alat'
    },
    {'icon': Icons.explore_rounded, 'title': 'Navigasi', 'count': '8 Alat'},
    {'icon': Icons.checkroom_rounded, 'title': 'Pakaian', 'count': '45 Alat'},
    {'icon': Icons.hotel_rounded, 'title': 'Sleeping Bag', 'count': '15 Alat'},
    {
      'icon': Icons.grid_view_rounded,
      'title': 'Aksesoris',
      'count': '50+ Alat'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kategori Alat',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                  'https://picsum.photos/seed/7t0z70/600/400'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eksplorasi Perlengkapan',
              style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pilih Kategori\nPetualangan Anda',
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w900, height: 1.2),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              hint: 'Cari perlengkapan...',
              controller: _searchController,
              prefixIcon: Icons.search,
              showShadow: false,
              borderRadius: 16,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.pushNamed(context, '/product-search-result',
                      arguments: value);
                }
              },
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(_categories[index]);
              },
            ),
            const SizedBox(height: 40),
            _buildPromoBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> data) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/product-search-result',
          arguments: data['title']),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: AppColors.primaryContainer, shape: BoxShape.circle),
              child: Icon(data['icon'], color: AppColors.primary, size: 28),
            ),
            const Spacer(),
            Text(data['title'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                data['count'],
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Opacity(
                opacity: 0.4,
                child: const CustomNetworkImage(
                  imageUrl:
                      'https://picsum.photos/seed/iioxvf/600/400',
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sewa Paket Lengkap',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Flexible(
                  child: Text(
                    'Mulai petualanganmu tanpa repot dengan paket camping pilihan kami.',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    // 🚀 FIX: Menggunakan warna fallback yang kontras
                    foregroundColor: Color.fromARGB(255, 252, 252, 252),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                  ),
                  child: const Text('Lihat Paket',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
