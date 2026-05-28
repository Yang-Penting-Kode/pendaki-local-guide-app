// START REPLACE
// =============================================================================
// 📦 PRODUCT DETAIL SCREEN — Detail Alat Sewa (RIVERPOD INJECTED)
// Lokasi: lib/features/catalog/presentation/screens/product_detail_screen.dart
//
// Migrasi: screens/products/product_detail_screen.dart → features/catalog/...
// Perubahan: StatefulWidget → ConsumerStatefulWidget
// Injeksi: Menerima ProductModel via ModalRoute.arguments, cartProvider.addItem()
// UI: Desain asli (BackdropFilter, PageView, reviews) DIPERTAHANKAN.
// =============================================================================

import 'package:flutter/material.dart';
import 'dart:ui'; // ⚠️ WAJIB untuk BackdropFilter (glassmorphism footer)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/cart_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/catalog/product_model.dart';
import 'package:pendaki_local_guide_app/widgets/custom_image.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isWishlisted = false;

  // Gambar fallback — dipakai kalau product.imageUrl kosong
  final List<String> _fallbackImages = [
    'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800',
    'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=800',
    'https://images.unsplash.com/photo-1537225228614-56cc3556d7ed?q=80&w=800',
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    // 🔌 Injeksi: Terima ProductModel dari route arguments
    final product =
        ModalRoute.of(context)?.settings.arguments as ProductModel?;

    // Guard: Jika tidak ada arguments (navigasi langsung), tampilkan error
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Alat')),
        body: const Center(
          child: Text('Data produk tidak tersedia.',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    // Gunakan imageUrl produk jika ada, atau fallback ke gambar demo
    final imageList = product.imageUrl != null
        ? [product.imageUrl!, ..._fallbackImages.skip(1)]
        : _fallbackImages;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C1C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Alat',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 18)),
        actions: [
          IconButton(
              icon: const Icon(Icons.share, color: Colors.grey),
              onPressed: () {}),
          IconButton(
            icon: Icon(_isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: _isWishlisted ? Colors.red : Colors.grey),
            onPressed: () => setState(() => _isWishlisted = !_isWishlisted),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Slider Gambar (Dipertahankan — PageView)
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) =>
                            setState(() => _currentPage = index),
                        itemCount: imageList.length,
                        itemBuilder: (context, index) => CustomNetworkImage(
                          imageUrl: imageList[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                              '${_currentPage + 1}/${imageList.length}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Info Utama — 🔌 Injeksi: nama & harga dari product
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name, // 🔌 Injeksi
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5),
                            ),
                          ),
                          _buildBadge('TERSEDIA', primaryContainer),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 🔌 Injeksi: Harga dari Decimal → String
                      Text(
                        'Rp ${product.basePrice.toStringAsFixed(0)} /hari',
                        style: const TextStyle(
                            color: primaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(height: 32),

                      // 3. Partner Card (Dipertahankan)
                      _buildPartnerCard(context, primaryContainer),
                      const SizedBox(height: 32),

                      // 4. Deskripsi & Specs — 🔌 Injeksi: dari product model
                      const _SectionTitle(title: 'DESKRIPSI PRODUK'),
                      const SizedBox(height: 12),
                      Text(
                        product.description ??
                            'Peralatan outdoor premium untuk mendukung pendakian Anda.',
                        style: const TextStyle(
                            color: onSurfaceVariant, height: 1.6, fontSize: 15),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildSpecItem(Icons.monitor_weight, 'Berat',
                              product.weight ?? 'N/A', primaryContainer),
                          const SizedBox(width: 16),
                          _buildSpecItem(Icons.groups, 'Kapasitas',
                              product.capacity ?? 'N/A', primaryContainer),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 5. Aturan Sewa (Dipertahankan)
                      const _SectionTitle(title: 'ATURAN SEWA & JAMINAN'),
                      const SizedBox(height: 16),
                      _buildRuleItem(
                          Icons.badge,
                          'Penyewa wajib meninggalkan KTP asli sebagai jaminan.',
                          primaryContainer),
                      _buildRuleItem(
                          Icons.schedule,
                          'Pengembalian tepat waktu. Keterlambatan didenda 1 hari.',
                          primaryContainer),
                      _buildRuleItem(
                          Icons.clean_hands,
                          'Alat harus dikembalikan dalam kondisi bersih dan kering.',
                          primaryContainer),
                      const SizedBox(height: 32),

                      // 6. Review Section (Dipertahankan)
                      const _SectionTitle(title: 'REVIEW PENDAKI'),
                      const SizedBox(height: 16),
                      _buildReviewItem(
                        name: 'Adi Chandra',
                        rating: 5,
                        date: '2 hari yang lalu',
                        comment:
                            'Alatnya bersih banget, kondisi prima. Sangat worth it untuk pendakian!',
                        primary: primaryContainer,
                      ),
                      _buildReviewItem(
                        name: 'Rizky Amalia',
                        rating: 4,
                        date: '1 minggu yang lalu',
                        comment:
                            'Proses ambil alatnya cepet karena deket banget sama basecamp. Mantap!',
                        primary: primaryContainer,
                      ),

                      const SizedBox(height: 140), // Spacer untuk Footer
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 7. Footer — 🔌 Injeksi: addItem + navigasi ke cart
          _buildFooter(context, product, primaryContainer),
        ],
      ),
    );
  }

  // --- UI HELPERS (Desain asli dipertahankan) ---

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(99)),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPartnerCard(BuildContext context, Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=200')),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Toko Outdoor Merdeka',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Jarak: 1.2 km',
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Lihat Toko',
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required int rating,
    required String date,
    required String comment,
    required Color primary,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey.shade200,
                  child:
                      const Icon(Icons.person, size: 14, color: Colors.grey)),
              const SizedBox(width: 8),
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              const Spacer(),
              Text(date,
                  style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
                5,
                (index) => Icon(Icons.star,
                    size: 14,
                    color:
                        index < rating ? Colors.amber : Colors.grey.shade300)),
          ),
          const SizedBox(height: 6),
          Text(comment,
              style: const TextStyle(
                  color: Color(0xFF3E4942), fontSize: 13, height: 1.4)),
          const SizedBox(height: 12),
          const Divider(),
        ],
      ),
    );
  }

  // 🔌 Injeksi: Footer sekarang menerima product dan memanggil cartProvider
  Widget _buildFooter(
      BuildContext context, ProductModel product, Color primary) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
          // ⚠️ WAJIB dipertahankan — Glassmorphism blur effect
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('HARGA / HARI',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    // 🔌 Injeksi: Harga dari product.basePrice
                    Text('Rp ${product.basePrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  width: 180,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // 🔌 Injeksi: Tambah ke keranjang via cartProvider
                      ref.read(cartProvider.notifier).addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} ditambahkan!'),
                          backgroundColor: const Color(0xFF007A52),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pushNamed(context, '/cart');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99)),
                    ),
                    child: const Text('Sewa Sekarang',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(
      IconData icon, String label, String value, Color primary) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: primary, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(IconData icon, String text, Color primary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primary, size: 18),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF3E4942), height: 1.4))),
        ],
      ),
    );
  }
}

// Dipertahankan — Private class dari desain asli
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Colors.grey));
  }
}
// END REPLACE
