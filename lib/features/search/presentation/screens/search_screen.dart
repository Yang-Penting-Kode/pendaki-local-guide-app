import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/components/modals/filter_modal.dart';
import 'package:pendaki_local_guide_app/core/constants/app_colors.dart';
import 'package:pendaki_local_guide_app/widgets/custom_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.trim().isEmpty) return;
    if (query.toLowerCase() == 'kosong') {
      Navigator.pushNamed(context, '/search-empty');
    } else {
      Navigator.pushNamed(context, '/product-search-result', arguments: query);
    }
  }

  void _showNotificationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          heightFactor: 1,
          child: Text('Belum ada notifikasi baru', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        toolbarHeight: 80,
        // 🚀 FIX: titleSpacing 16 agar search bar mepet rapi ke sisi layar
        titleSpacing: 16,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
            onPressed: () => _showNotificationModal(context),
          ),
        ],
        title: Row(
          children: [
            Expanded(
              child: CustomTextField(
                hint: 'Ketik nama alat...',
                controller: _searchController,
                onSubmitted: _handleSearch,
                prefixIcon: Icons
                    .search, // 🚀 Gunakan prefix icon yang sudah ada di widget
                borderRadius: 99, // 🚀 Pill shape konsisten
                showShadow:
                    false, // 🚀 Matikan shadow agar tidak sumpek di header
                // 🚀 FIX: Padding vertikal 10 agar teks tidak terhimpit
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                onChanged: (value) => setState(() {}),
                suffixIcon:
                    _searchController.text.isNotEmpty ? Icons.close : null,
                onSuffixTap: () {
                  _searchController.clear();
                  setState(() {}); // 👈 Refresh UI agar ikon X langsung hilang
                },
              ),
            ),
            const SizedBox(width: 12),
            // Tombol Filter (Tune)
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const FilterModal(),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outline.withOpacity(0.1)),
                ),
                child:
                    const Icon(Icons.tune, color: AppColors.primary, size: 20),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        // 🚀 FIX: Paksa kategori dan grid melebar penuh layar VIVO
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          // Tab Kategori Horizontal
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildCategoryTab('Semua', isSelected: true),
                _buildCategoryTab('Tenda'),
                _buildCategoryTab('Carrier'),
                _buildCategoryTab('Sleeping Bag'),
                _buildCategoryTab('Masak'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Grid Produk
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75, // Proporsi kartu produk
              children: [
                _buildProductCard(
                    context: context,
                    title: 'Tenda Dome 4P',
                    price: '40.000',
                    distance: '1.5 km',
                    imageUrl:
                        'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400'),
                _buildProductCard(
                    context: context,
                    title: 'Carrier 60L Pro',
                    price: '35.000',
                    distance: '0.8 km',
                    imageUrl:
                        'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400'),
                _buildProductCard(
                    context: context,
                    title: 'Sleeping Bag Zero',
                    price: '15.000',
                    distance: '2.1 km',
                    imageUrl:
                        'https://images.unsplash.com/photo-1533038590840-1cde6e668a91?q=80&w=400'),
                _buildProductCard(
                    context: context,
                    title: 'Cooking Set Ultralight',
                    price: '20.000',
                    distance: '1.2 km',
                    imageUrl:
                        'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?q=80&w=400'),
                _buildProductCard(
                    context: context,
                    title: 'Headlamp 300 Lumens',
                    price: '10.000',
                    distance: '3.4 km',
                    imageUrl:
                        'https://images.unsplash.com/photo-1508672019048-805c876b67e2?q=80&w=400'),
                _buildProductCard(
                    context: context,
                    title: 'Matras Alumunium',
                    price: '5.000',
                    distance: '1.9 km',
                    imageUrl:
                        'https://images.unsplash.com/photo-1525811902-f23426213fd0?q=80&w=400'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : Colors.white,
          foregroundColor:
              isSelected ? Colors.white : AppColors.onSurfaceVariant,
          elevation: 0,
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
            side: isSelected
                ? BorderSide.none
                : const BorderSide(color: AppColors.outline, width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
      ),
    );
  }

  Widget _buildProductCard(
      {required BuildContext context,
      required String title,
      required String price,
      required String distance,
      required String imageUrl}) {
    return GestureDetector(
      // 🚀 Navigasi ke halaman detail produk
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product-detail',
          arguments: {
            'title': title,
            'price': price,
            'imageUrl': imageUrl,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // 🚀 FIX: Isi kartu melebar penuh
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.surfaceContainerLow,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          height: 1.2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      text: 'Rp $price',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                      children: const [
                        TextSpan(
                            text: '/hari',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 10))
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 10, color: Colors.grey),
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
      ),
    );
  }
}
