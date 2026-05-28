// START REPLACE
// =============================================================================
// 🛒 CATALOG SCREEN — Katalog Produk Sewa (RIVERPOD INJECTED)
// Lokasi: lib/features/catalog/presentation/screens/catalog_screen.dart
//
// Migrasi: screens/home/catalog_screen.dart → features/catalog/presentation/screens/
// Perubahan: StatefulWidget → ConsumerStatefulWidget
// Injeksi: productProvider (AsyncNotifier), cartProvider, cartCountProvider
// UI: Desain asli DIPERTAHANKAN, hanya state management yang diganti.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/catalog/providers/catalog_provider.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/cart_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/catalog/product_model.dart';
import 'package:pendaki_local_guide_app/widgets/custom_image.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  // Search & Filter State — Ephemeral, tetap local
  String _activeCategory = 'Semua Alat';

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);

    // 🔌 Injeksi: Badge keranjang dari cartCountProvider (real-time)
    final cartCount = ref.watch(cartCountProvider);

    // 🔌 Injeksi: Data produk dari productProvider (AsyncNotifier)
    final productsAsync = ref.watch(filteredProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Katalog Sewa',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              // 🔌 Injeksi: Gunakan cartCount dari provider, bukan local state
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    constraints:
                        const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 2. Shop Header Section (Dipertahankan dari desain asli)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                    ),
                    child: const ClipOval(
                      child: CustomNetworkImage(
                        imageUrl:
                            'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=200',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Flexible(
                              child: Text(
                                'Toko Merdeka Outdoor',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Text('Official',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoIcon(Icons.star, '4.8',
                                iconColor: Colors.amber),
                            const SizedBox(width: 12),
                            _buildInfoIcon(Icons.schedule, 'Buka s/d 21:00'),
                            const SizedBox(width: 12),
                            _buildInfoIcon(Icons.location_on, '1.2 km'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 3. Category Tabs (Dipertahankan dari desain asli)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTab('Semua Alat',
                      isActive: _activeCategory == 'Semua Alat'),
                  _buildTab('Tenda', isActive: _activeCategory == 'Tenda'),
                  _buildTab('Carrier', isActive: _activeCategory == 'Carrier'),
                  _buildTab('Logistik',
                      isActive: _activeCategory == 'Logistik'),
                ],
              ),
            ),

            // 4. Product Grid — 🔌 Injeksi: AsyncValue dari productProvider
            productsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text('Gagal memuat produk: $error',
                      style: const TextStyle(color: Colors.grey)),
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Text('Tidak ada produk tersedia.',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) =>
                      _buildProductCard(context, products[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS (Desain asli dipertahankan) ---

  Widget _buildInfoIcon(IconData icon, String text,
      {Color iconColor = Colors.grey}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTab(String label, {required bool isActive}) {
    const Color primaryColor = Color(0xFF005F3F);
    return GestureDetector(
      onTap: () => setState(() => _activeCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: isActive
              ? const Border(bottom: BorderSide(color: primaryColor, width: 2))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }

  // 🔌 Injeksi: Parameter diubah dari (name, price, stock, imgUrl) → (ProductModel product)
  Widget _buildProductCard(BuildContext context, ProductModel product) {
    const Color primaryColor = Color(0xFF005F3F);
    return GestureDetector(
      // 🔌 Injeksi: Kirim ProductModel sebagai route arguments
      onTap: () =>
          Navigator.pushNamed(context, '/product-detail', arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CustomNetworkImage(
                      // 🔌 Injeksi: imageUrl dari product model
                      imageUrl: product.imageUrl ?? '',
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4)),
                      // 🔌 Injeksi: stock dari product model
                      child: Text('Tersedia ${product.stock}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔌 Injeksi: Nama dari product model
                  Text(product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                      children: [
                        // 🔌 Injeksi: Harga dari product.basePrice (Decimal → String)
                        TextSpan(
                            text: 'Rp ${product.basePrice.toStringAsFixed(0)} '),
                        const TextSpan(
                            text: '/ hari',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 9,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      // 🔌 Injeksi: Panggil cartProvider.notifier.addItem()
                      onPressed: () {
                        ref.read(cartProvider.notifier).addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${product.name} ditambahkan ke keranjang!'),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF007A52),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Keranjang',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
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
// END REPLACE
