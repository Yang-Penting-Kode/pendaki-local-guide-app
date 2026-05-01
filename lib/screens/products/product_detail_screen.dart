import 'package:flutter/material.dart';
import 'dart:ui';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // 🚀 Logic: Controller untuk Image Slider & State Counter[cite: 6]
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 🚀 STATE: Untuk status tombol wishlist
  bool _isWishlisted = false;

  final List<String> _productImages = [
    'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=800',
    'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=800',
    'https://images.unsplash.com/photo-1537225228614-56cc3556d7ed?q=80&w=800',
  ];

  void _handleAddToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil ditambahkan ke keranjang!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF007A52),
      ),
    );
  }

  // 🚀 FUNGSI: Toggle state wishlist
  void _toggleWishlist() {
    setState(() {
      _isWishlisted = !_isWishlisted;
    });

    // Opsional: Tampilkan feedback ke pengguna
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isWishlisted
            ? 'Ditambahkan ke Wishlist'
            : 'Dihapus dari Wishlist'),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF007A52),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C1C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Alat',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.share, color: Colors.grey),
              onPressed: () {}),
          // 🚀 ADDED: Ikon Love untuk Wishlist[cite: 6]
          IconButton(
            icon: Icon(
              _isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: _isWishlisted ? Colors.red : Colors.grey,
            ),
            onPressed: _toggleWishlist,
          ),
          const SizedBox(width: 8),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddToCart,
        backgroundColor: primaryContainer,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Slider[cite: 6]
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: _productImages.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        _productImages[index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        '${_currentPage + 1}/${_productImages.length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
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
                  // Info Utama Alat[cite: 6]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('Tenda Kapasitas 4 Orang',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryContainer.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                              color: primaryContainer.withOpacity(0.2)),
                        ),
                        child: const Text('TERSEDIA',
                            style: TextStyle(
                                color: primaryContainer,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          color: primaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      children: [
                        TextSpan(text: 'Rp 50.000'),
                        TextSpan(
                            text: '/hari',
                            style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Partner Card[cite: 6]
                  _buildPartnerCard(context, primaryContainer),

                  const SizedBox(height: 32),

                  // Deskripsi & Spesifikasi[cite: 6]
                  const _SectionTitle(title: 'DESKRIPSI PRODUK'),
                  const SizedBox(height: 12),
                  const Text(
                    'Tenda dome premium dengan kapasitas luas untuk 4 orang dewasa. Menggunakan material Double Layer Polyester yang tahan terhadap hujan intensitas tinggi dan angin kencang.',
                    style: TextStyle(
                        color: onSurfaceVariant, height: 1.6, fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildSpecItem(Icons.layers, 'Lapisan', 'Double Layer'),
                      const SizedBox(width: 16),
                      _buildSpecItem(Icons.groups, 'Kapasitas', '4-5 Orang'),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Aturan Sewa & Jaminan[cite: 6]
                  const _SectionTitle(title: 'ATURAN SEWA & JAMINAN'),
                  const SizedBox(height: 16),
                  _buildRuleItem(Icons.badge,
                      'Penyewa wajib meninggalkan KTP asli sebagai jaminan.'),
                  _buildRuleItem(Icons.schedule,
                      'Pengembalian tepat waktu. Keterlambatan didenda biaya 1 hari.'),
                  _buildRuleItem(Icons.clean_hands,
                      'Tenda harus dikembalikan dalam kondisi kering dan bersih.'),

                  const SizedBox(height: 32),

                  // Review Section[cite: 6]
                  const _SectionTitle(title: 'REVIEW PENDAKI'),
                  const SizedBox(height: 16),
                  _buildReviewItem(
                    name: 'Adi Chandra',
                    rating: 5,
                    date: '2 hari yang lalu',
                    comment:
                        'Tendanya bersih banget, beneran double layer jadi pas hujan badai di Arjuno tetap aman jaya!',
                  ),
                  const SizedBox(height: 16),
                  _buildReviewItem(
                    name: 'Rizky Amalia',
                    rating: 4,
                    date: '1 minggu yang lalu',
                    comment:
                        'Proses ambil alatnya cepet karena deket banget sama basecamp. Mantap!',
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      // Sticky Footer[cite: 6]
      bottomSheet: _buildStickyFooter(primaryContainer),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildPartnerCard(BuildContext context, Color primaryContainer) {
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
                'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=200'),
          ),
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
            onPressed: () => Navigator.pushNamed(context, '/rental-detail'),
            child: Text('Lihat Toko',
                style: TextStyle(
                    color: primaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
      {required String name,
      required int rating,
      required String date,
      required String comment}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, size: 14, color: Colors.grey)),
            const SizedBox(width: 8),
            Text(name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                  color: index < rating ? Colors.amber : Colors.grey.shade300)),
        ),
        const SizedBox(height: 6),
        Text(comment,
            style: const TextStyle(
                color: Color(0xFF3E4942), fontSize: 13, height: 1.4)),
        const SizedBox(height: 12),
        const Divider(),
      ],
    );
  }

  Widget _buildStickyFooter(Color primaryContainer) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TOTAL ESTIMASI',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              Text('Rp 50.000',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryContainer,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99)),
            ),
            child: const Text('Sewa Sekarang',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF007A52), size: 20),
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

  Widget _buildRuleItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF007A52), size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF3E4942)))),
        ],
      ),
    );
  }
}

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
