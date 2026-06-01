import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/core/constants/app_colors.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/cart_provider.dart';
import 'package:pendaki_local_guide_app/features/catalog/providers/catalog_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/catalog/package_model.dart';
import 'package:pendaki_local_guide_app/widgets/custom_image.dart';

class PackageDetailScreen extends ConsumerWidget {
  const PackageDetailScreen({super.key});

  bool _isLocalPath(String path) {
    return !path.startsWith('http://') && !path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final package = ModalRoute.of(context)?.settings.arguments as PackageModel?;

    if (package == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Paket')),
        body: const Center(child: Text('Data paket tidak tersedia.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Content Scroll Canvas Layer
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🌄 1. Hero Cover Section (Asymmetric Banner Layout)
                _buildHeroCoverSection(context, package),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Paket Title Header
                      Text(
                        package.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: -1.0,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 💳 Pricing Bento Card Box
                      _buildPricingBentoBox(package),
                      const SizedBox(height: 36),

                      // 📊 2. Technical Specs (Bento Grid Style)
                      const Text(
                        'SPESIFIKASI UTAMA',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.grey,
                            letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 12),
                      _buildTechnicalSpecsBentoGrid(package),
                      const SizedBox(height: 36),

                      // ⛺ 3. Item List Penyusun Paket Bundling
                      const Text(
                        'DAFTAR PRODUK DALAM PAKET',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.grey,
                            letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 12),
                      _buildProductBundleItemsList(ref, package),
                      const SizedBox(height: 36),

                      // 📝 4. Description Editorial Paragraphs
                      const Text(
                        'DESKRIPSI PAKET',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.grey,
                            letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        package.description ?? 'Belum ada deskripsi untuk paket ini.',
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF3E4942),
                            height: 1.6,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 32),

                      // START REPLACE
                      // 7. Section Profil Toko
                      _buildStoreProfile(),
                      const SizedBox(height: 32),

                      // 8. Section Ulasan
                      _buildReviewSection(),
                      // END REPLACE
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🛠️ 5. Fixed Top Floating Translucent Navigation Head Bar
          _buildFloatingAppBar(context),

          // 🛠️ 6. Fixed Absolute Bottom Sticky Edit CTA Button Panel
          _buildStickyBottomActionBar(context, ref, package),
        ],
      ),
    );
  }

  Widget _buildFloatingAppBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        padding: const EdgeInsets.only(top: 24, left: 12, right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.4), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 26),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCoverSection(BuildContext context, PackageModel package) {
    return Container(
      width: double.infinity,
      height: 380,
      margin: const EdgeInsets.only(bottom: 28), //
      child: Stack(
        children: [
          // Background Real-Photo Image Layer
          Positioned.fill(
            child: package.imageUrl != null 
                ? (_isLocalPath(package.imageUrl!) 
                    ? Image.file(File(package.imageUrl!), fit: BoxFit.cover)
                    : Image.network(package.imageUrl!, fit: BoxFit.cover))
                : Image.network(
                    'https://picsum.photos/seed/qmenqu/600/400',
                    fit: BoxFit.cover,
                  ),
          ),
          // Gradient Bottom Fading Layer
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.white, Colors.black.withOpacity(0.1)],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),
          // Floating Absolute Decorative Badges
          Positioned(
            bottom: 16,
            left: 24,
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: const Text('PAKET BUNDLING',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingBentoBox(PackageModel package) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBDC9C0).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1B1B1B).withOpacity(0.03),
              blurRadius: 24,
              offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('HARGA SEWA',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E4942),
                        letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        'Rp ${package.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -0.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('/ hari',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3E4942),
                            fontWeight: FontWeight.w500)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
                color: const Color(0xFFC5ECD4),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inventory_2_rounded,
                    color: Color(0xFF2B4E3C), size: 14),
                const SizedBox(width: 6),
                Text('${package.items.length} Item Termasuk',
                    style: const TextStyle(
                        color: Color(0xFF2B4E3C),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTechnicalSpecsBentoGrid(PackageModel package) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.35,
      children: [
        _buildSpecCard(Icons.inventory_2_rounded, 'SISA STOK PAKET', '${package.stock} Paket'),
        _buildSpecCard(Icons.scale_rounded, 'BERAT TOTAL', package.weight != null && package.weight!.isNotEmpty ? '${package.weight} kg' : '-'),
      ],
    );
  }

  Widget _buildSpecCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3E4942),
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductBundleItemsList(WidgetRef ref, PackageModel package) {
    final allProducts = ref.watch(productProvider).valueOrNull ?? [];

    if (package.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('Belum ada produk di dalam paket ini.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Column(
      children: package.items.map((item) {
        final productName = allProducts.any((p) => p.id == item.productId) 
            ? allProducts.firstWhere((p) => p.id == item.productId).name 
            : 'Alat ID: ${item.productId}';
        final productCategory = allProducts.any((p) => p.id == item.productId) 
            ? 'Produk' 
            : '-';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBDC9C0).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.inventory_2_rounded, color: Color(0xFF3E4942), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(productCategory,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF3E4942),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Text('${item.quantity}x',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStickyBottomActionBar(BuildContext context, WidgetRef ref, PackageModel package) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 32,
                    offset: const Offset(0, -4))
              ],
            ),
            child: Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF007A52)]),
                borderRadius: BorderRadius.circular(99),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.24),
                      blurRadius: 24,
                      offset: const Offset(0, 8))
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(cartProvider.notifier).addPackage(package);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Paket ditambahkan ke keranjang!'),
                      backgroundColor: AppColors.primary,
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pushNamed(context, '/cart');
                },
                icon: const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white, size: 20),
                label: const Text('Sewa Paket Ini',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99))),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INFORMASI MITRA',
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.grey,
              letterSpacing: 1.5),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEEEEE)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: const NetworkImage('https://picsum.photos/seed/store/100/100'),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Basecamp Gunung Gede',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Cibodas, Jawa Barat',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Kunjungi',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ULASAN PELANGGAN',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey,
                  letterSpacing: 1.5),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                const Text('4.8',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(' (124 Ulasan)',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: const NetworkImage('https://picsum.photos/seed/user1/100/100'),
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Budi Santoso',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text('2 hari yang lalu',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey)),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(
                        5,
                        (index) => const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 14)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Barangnya bagus banget, kondisinya masih sangat prima. Penjual juga ramah dan responsif saat ditanya-tanya.',
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3E4942),
                    height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
