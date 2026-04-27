import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/components/order_type_sheet.dart';

class MountainSearchResultScreen extends StatelessWidget {
  final String searchQuery;

  const MountainSearchResultScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3F4A3B);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C1C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  searchQuery,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.close, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Meta
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 24),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                      color: onSurfaceVariant,
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
            ),

            // 1. Daftar Hasil Pencarian (Sekarang bisa diklik)
            _buildMountainResultCard(
              context, // Oper context ke sini
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

  // Helper Card dengan Navigasi
  Widget _buildMountainResultCard(
    BuildContext context, {
    // Tambahkan parameter context
    required String title,
    required String location,
    required String elevation,
    required String difficulty,
    required int rentalCount,
    required String imageUrl,
  }) {
    return GestureDetector(
      // Gunakan GestureDetector untuk mendeteksi klik
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              const OrderTypeSheet(), // 🚀 Tampilkan pilihan dulu
        );
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
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.broken_image),
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
                                style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: const Color(0xFF904D00).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(99)),
                            child: Text(difficulty,
                                style: const TextStyle(
                                    color: Color(0xFF904D00),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildIconText(Icons.location_on, location),
                      const SizedBox(height: 4),
                      _buildIconText(Icons.landscape, elevation),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.storefront,
                    size: 16, color: Color(0xFF006C0C)),
                const SizedBox(width: 8),
                Text('$rentalCount Mitra Rental di sekitar basecamp',
                    style: const TextStyle(
                        color: Color(0xFF006C0C),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
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
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
