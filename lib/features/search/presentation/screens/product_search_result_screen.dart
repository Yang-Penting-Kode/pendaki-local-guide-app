import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/custom_image.dart';
import '../../../../components/modals/filter_modal.dart';

class ProductSearchResultScreen extends StatefulWidget {
  final String initialQuery;

  const ProductSearchResultScreen({super.key, required this.initialQuery});

  @override
  State<ProductSearchResultScreen> createState() =>
      _ProductSearchResultScreenState();
}

class _ProductSearchResultScreenState extends State<ProductSearchResultScreen> {
  late TextEditingController _searchController;
  late String _currentQuery;

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.initialQuery;
    _searchController = TextEditingController(text: _currentQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
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
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomTextField(
          hint: 'Cari alat lain...',
          controller: _searchController,
          borderRadius: 99,
          showShadow: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          prefixIcon: Icons.search,
          onSubmitted: _handleSearch,
          suffixIcon: _searchController.text.isNotEmpty ? Icons.close : null,
          onSuffixTap: () {
            _searchController.clear();
            setState(() {});
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.primary),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const FilterModal(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER INFO (FIX OVERFLOW) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  // 🚀 FIX: Mencegah overflow jika query sangat panjang
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('HASIL PENCARIAN',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Text(
                        'Ditemukan 24 Alat untuk "$_currentQuery"',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sort, size: 16),
                  label: const Text('Terbaru',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- LIST PRODUK ---
            _buildGearCard(
              context,
              title: 'Tenda Eiger 4P',
              store: 'Toko Merdeka Outdoor',
              price: '100.000',
              rating: '4.8',
              reviewCount: 120,
              imageUrl:
                  'https://picsum.photos/seed/tenda4p/400/300',
              isAvailable: true,
            ),
            _buildGearCard(
              context,
              title: 'Carrier Osprey 60L Pro',
              store: 'Toko Merdeka Outdoor',
              price: '150.000',
              rating: '4.9',
              reviewCount: 85,
              imageUrl:
                  'https://picsum.photos/seed/carrier60l/400/300',
              isAvailable: true,
            ),
            _buildGearCard(
              context,
              title: 'Tenda Consina Magnum 4',
              store: 'Batu Adventure Rental',
              price: '75.000',
              rating: '4.7',
              reviewCount: 64,
              imageUrl:
                  'https://picsum.photos/seed/tendaConsina/400/300',
              isAvailable: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGearCard(
    BuildContext context, {
    required String title,
    required String store,
    required String price,
    required String rating,
    required int reviewCount,
    required String imageUrl,
    required bool isAvailable,
  }) {
    return GestureDetector(
      // 🚀 Navigasi ke Detail Produk (Hanya jika tersedia)
      onTap: isAvailable
          ? () => Navigator.pushNamed(
                context,
                '/product-detail',
                arguments: {
                  'title': title,
                  'store': store,
                  'price': price,
                  'imageUrl': imageUrl,
                },
              )
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
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
            // Area Gambar
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: ColorFiltered(
                    colorFilter: isAvailable
                        ? const ColorFilter.mode(
                            Colors.transparent, BlendMode.multiply)
                        : const ColorFilter.mode(
                            Colors.grey, BlendMode.saturation),
                    child: CustomNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 200),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? AppColors.primary
                          : const Color(0xFF303030),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      isAvailable ? 'TERSEDIA' : 'PENUH (BOOKING)',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            // Detail Info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          // 🚀 FIX: Mencegah overflow pada nama produk yang panjang
                          child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(rating,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(' ($reviewCount)',
                              style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.storefront,
                          size: 16, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(store,
                          style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color:
                                  isAvailable ? AppColors.primary : Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                          children: [
                            TextSpan(text: 'Rp $price'),
                            const TextSpan(
                                text: ' / hari',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: isAvailable ? () {} : null,
                        icon: Icon(isAvailable
                            ? Icons.add_shopping_cart
                            : Icons.block),
                        style: IconButton.styleFrom(
                          backgroundColor: isAvailable
                              ? AppColors.primary
                              : Colors.grey.shade200,
                          foregroundColor:
                              isAvailable ? Colors.white : Colors.grey,
                        ),
                      ),
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
