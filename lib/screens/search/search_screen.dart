import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/components/filter_modal.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: surfaceColor,
      // 1. Sticky Header dengan Search Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Ketik nama alat...',
                    hintStyle: TextStyle(fontSize: 14, color: onSurfaceVariant),
                    prefixIcon: Icon(Icons.search, color: primaryColor),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.tune, color: primaryColor),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const FilterModal(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 2. Category Section (Horizontal Scroll)
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildCategoryTab('Semua', isSelected: true),
                _buildCategoryTab('Tenda'),
                _buildCategoryTab('Carrier'),
                _buildCategoryTab('Sleeping Bag'),
                _buildCategoryTab('Masak'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Bento Grid / Catalog Section
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75, // Biar card agak memanjang ke bawah
              children: [
                _buildProductCard(
                  title: 'Tenda Dome 4P',
                  price: '40.000',
                  distance: '1.5 km',
                  imageUrl:
                      'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
                ),
                _buildProductCard(
                  title: 'Carrier 60L Pro',
                  price: '35.000',
                  distance: '0.8 km',
                  imageUrl:
                      'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400',
                ),
                _buildProductCard(
                  title: 'Sleeping Bag Zero',
                  price: '15.000',
                  distance: '2.1 km',
                  imageUrl:
                      'https://images.unsplash.com/photo-1533038590840-1cde6e668a91?q=80&w=400',
                ),
                _buildProductCard(
                  title: 'Cooking Set Ultralight',
                  price: '20.000',
                  distance: '1.2 km',
                  imageUrl:
                      'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?q=80&w=400',
                ),
                _buildProductCard(
                  title: 'Headlamp 300 Lumens',
                  price: '10.000',
                  distance: '3.4 km',
                  imageUrl:
                      'https://images.unsplash.com/photo-1508672019048-805c876b67e2?q=80&w=400',
                ),
                _buildProductCard(
                  title: 'Matras Alumunium',
                  price: '5.000',
                  distance: '1.9 km',
                  imageUrl:
                      'https://images.unsplash.com/photo-1525811902-f23426213fd0?q=80&w=400',
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildCategoryTab(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF007A52) : Colors.white,
          foregroundColor: isSelected ? Colors.white : const Color(0xFF3E4942),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
            side: isSelected
                ? BorderSide.none
                : const BorderSide(color: Color(0xFFBDC9C0), width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String title,
    required String price,
    required String distance,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBDC9C0).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
            ),
          ),
          // Info Produk
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'Rp $price',
                    style: const TextStyle(
                        color: Color(0xFF005F3F),
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                    children: const [
                      TextSpan(
                          text: '/hari',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 10)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(distance,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
