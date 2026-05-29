import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/catalog/providers/catalog_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/catalog/product_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);
    // Definisi warna dari desain
    const Color primaryColor = Color(0xFF006C0C);
    const Color secondaryColor = Color(0xFF904D00);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color outlineColor = Color(0xFF6F7A6A);

    return Scaffold(
      backgroundColor: surfaceColor,
      // 1. Custom AppBar (Header)
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Mountain Kit',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: primaryColor),
            onPressed: () => _showNotificationModal(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: const NetworkImage(
                  'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=100'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Search Bar
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GestureDetector(
                // 🚀 Navigasi ke halaman pencarian gunung
                onTap: () => Navigator.pushNamed(context, '/mountain-search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const TextField(
                    enabled:
                        false, // Supaya tidak bisa diketik langsung di sini
                    decoration: InputDecoration(
                      hintText: 'Cari gunung atau jalur pendakian...',
                      hintStyle:
                          TextStyle(color: Color(0xFF6F7A6A), fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF6F7A6A)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Status Sewa Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildStatusCard(
                    icon: Icons.shopping_bag,
                    title: 'Sedang Disewa',
                    subtitle: '1 Alat Aktif',
                    iconColor: primaryColor,
                    bgColor: primaryColor.withOpacity(0.1),
                    onTap: () => Navigator.pushNamed(context, '/active-rentals'),
                  ),
                  const SizedBox(width: 16),
                  _buildStatusCard(
                    icon: Icons.calendar_month,
                    title: 'Pengembalian',
                    subtitle: 'Besok, 10:00 WIB',
                    iconColor: secondaryColor,
                    bgColor: const Color(0xFFFD8B00).withOpacity(0.2),
                    subtitleColor: secondaryColor,
                    onTap: () => Navigator.pushNamed(context, '/return-schedules'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 4. Quick Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAction(Icons.qr_code_scanner, 'QR Ambil Alat',
                      onTap: () =>
                          Navigator.pushNamed(context, '/pickup-confirmation')),
                  _buildQuickAction(Icons.category, 'Kategori Alat',
                      onTap: () =>
                          Navigator.pushNamed(context, '/product-category')),
                  _buildQuickAction(Icons.history, 'Riwayat',
                      onTap: () => Navigator.pushNamed(context, '/dashboard')),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 5. Gunung Terpopuler Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gunung Terpopuler',
                        style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Pilihan favorit pendaki minggu ini',
                        style: TextStyle(color: outlineColor, fontSize: 12),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Lihat Semua',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 6. Horizontal Scrollable Mountain Cards
            SizedBox(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 24, right: 8, bottom: 20),
                children: [
                  _buildMountainCard(
                    context, // Oper context untuk navigasi
                    onTap: () => Navigator.pushNamed(context,
                        '/basecamp-partners'), // Navigasi ke peta mitra
                    title: 'Gunung Prau',
                    location: 'Wonosobo, Jawa Tengah',
                    elevation: '2,565 mdpl',
                    duration: '3-4 Jam',
                    rating: '4.8',
                    tag: 'Pemula',
                    imageUrl:
                        'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400',
                  ),
                  _buildMountainCard(
                    context,
                    onTap: () =>
                        Navigator.pushNamed(context, '/basecamp-partners'),
                    title: 'Gunung Bromo',
                    location: 'Probolinggo, Jatim',
                    elevation: '2,329 mdpl',
                    duration: '1 Jam',
                    rating: '4.9',
                    tag: 'Wisata',
                    imageUrl:
                        'https://images.unsplash.com/photo-1588392382834-a8af9f50e869?q=80&w=400',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 7. Rekomendasi Alat Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rekomendasi Alat',
                        style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Siapkan perlengkapan terbaikmu',
                        style: TextStyle(color: outlineColor, fontSize: 12),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/catalog'),
                    child: const Text('Lihat Semua',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 8. Horizontal Scrollable Product Cards (Riverpod Data)
            SizedBox(
              height: 260,
              child: productsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('Gagal memuat produk: $error')),
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(child: Text('Belum ada rekomendasi alat.'));
                  }
                  
                  // Tampilkan maksimal 5 item
                  final displayProducts = products.take(5).toList();
                  
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 24, right: 8, bottom: 20),
                    itemCount: displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayProducts[index];
                      // Rule Finansial: Harga produk = (basePrice + Rp 1.000)
                      final displayPrice = (product.basePrice + Decimal.parse('1000')).toStringAsFixed(0);
                      
                      return _buildProductCard(
                        context,
                        product: product,
                        displayPrice: displayPrice,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product-detail',
                          arguments: product,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 100), // Spacer untuk Bottom Nav
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color bgColor,
    Color? subtitleColor,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 12),
              Text(title,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subtitle,
                  style: TextStyle(
                      color: subtitleColor ?? Colors.grey, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, // 🚀 Aktifkan fungsi klik
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1C871E).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF006C0C), size: 28),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 64,
            child: Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600, height: 1.2)),
          ),
        ],
      ),
    );
  }

  Widget _buildMountainCard(
    BuildContext context, {
    // Tambahkan BuildContext
    required VoidCallback onTap, // Tambahkan callback navigasi
    required String title,
    required String location,
    required String elevation,
    required String duration,
    required String rating,
    required String tag,
    required String imageUrl,
  }) {
    return GestureDetector(
      // Gunakan GestureDetector agar bisa diklik
      onTap: onTap,
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // 🛡️ Penanganan jika gambar gagal dimuat
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 160,
                        color: Colors.grey.shade200,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image,
                                color: Colors.grey, size: 40),
                            SizedBox(height: 8),
                            Text('Gambar Gagal Dimuat',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        const SizedBox(width: 4),
                        Text(rating,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: const Color(0xFF006C0C).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(99)),
                        child: Text(tag,
                            style: const TextStyle(
                                color: Color(0xFF006C0C),
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text(location,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.landscape,
                          color: Color(0xFF006C0C), size: 16),
                      const SizedBox(width: 4),
                      Text(elevation,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      const Icon(Icons.timer,
                          color: Color(0xFF006C0C), size: 16),
                      const SizedBox(width: 4),
                      Text(duration,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w500)),
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

  Widget _buildProductCard(
    BuildContext context, {
    required ProductModel product,
    required String displayPrice,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? Image.network(
                      product.imageUrl!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp $displayPrice / hari',
                    style: const TextStyle(
                      color: Color(0xFF006C0C),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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

  Widget _buildPlaceholderImage() {
    return Container(
      height: 120,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
    );
  }
}
