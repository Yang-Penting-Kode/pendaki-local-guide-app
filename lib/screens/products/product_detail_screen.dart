import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_image.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isWishlisted = false;

  final List<String> _productImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuA50SYWomaWs3kn8LOjDY8eA7P175MyayGISgtIUf8Duf-fCzqUymvow8pXqzCBlDVDdLByogMCSkjSk-5DuAVPqKIkKNseCKPSu24dIoqMfLLO9_5n5iHblfElIL02Bh1qqtE-eBmAkSDShTrpPHPHdHxnuYWk322jltXUfLa_UHUhOG8EEFv0ebXLekkPY4t5QuXSuh4lXqSYv_BRcjElgqYg1YXXV033nyLTXqyRYvdv2Dr3bnTydQhNSrfpYVLB5BfYktfd93uD',
    'https://picsum.photos/seed/djmaqx/600/400',
    'https://picsum.photos/seed/e8pfoz/600/400',
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C1C)),
          onPressed: () => Navigator.pop(context), //
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
            onPressed: () => setState(() => _isWishlisted = !_isWishlisted), //
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()), //
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Slider Gambar[cite: 4]
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) =>
                            setState(() => _currentPage = index),
                        itemCount: _productImages.length,
                        itemBuilder: (context, index) => CustomNetworkImage(
                          imageUrl: _productImages[index],
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
                              '${_currentPage + 1}/${_productImages.length}',
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
                      // 2. Info Utama[cite: 4]
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text('Tenda Kapasitas 4 Orang',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5)),
                          ),
                          _buildBadge('TERSEDIA', primaryContainer),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Rp 50.000 /hari',
                          style: TextStyle(
                              color: primaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      const SizedBox(height: 32),

                      // 3. Partner Card[cite: 4]
                      _buildPartnerCard(context, primaryContainer),
                      const SizedBox(height: 32),

                      // 4. Deskripsi & Specs[cite: 4]
                      const _SectionTitle(title: 'DESKRIPSI PRODUK'),
                      const SizedBox(height: 12),
                      const Text(
                        'Tenda dome premium dengan kapasitas luas untuk 4 orang dewasa. Menggunakan material Double Layer Polyester yang tahan terhadap hujan intensitas tinggi dan angin kencang. Sangat cocok untuk pendakian gunung.',
                        style: TextStyle(
                            color: onSurfaceVariant, height: 1.6, fontSize: 15),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildSpecItem(Icons.layers, 'Lapisan',
                              'Double Layer', primaryContainer),
                          const SizedBox(width: 16),
                          _buildSpecItem(Icons.groups, 'Kapasitas', '4-5 Orang',
                              primaryContainer),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 5. Aturan Sewa[cite: 4]
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
                          'Tenda harus dikembalikan kering dan bersih.',
                          primaryContainer),
                      const SizedBox(height: 32),

                      // 6. Review Section (DITAMBAHKAN)[cite: 4]
                      const _SectionTitle(title: 'REVIEW PENDAKI'),
                      const SizedBox(height: 16),
                      _buildReviewItem(
                        name: 'Adi Chandra',
                        rating: 5,
                        date: '2 hari yang lalu',
                        comment:
                            'Tendanya bersih banget, beneran double layer jadi pas hujan badai di Arjuno tetap aman jaya!',
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

                      const SizedBox(
                          height:
                              140), // Spacer agar tidak tertutup Footer[cite: 4]
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 7. Footer[cite: 4]
          _buildFooter(primaryContainer),
        ],
      ),
    );
  }

  // --- UI HELPERS ---

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
                  'https://picsum.photos/seed/43aujc/600/400')),
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

  Widget _buildFooter(Color primary) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  width: 180,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/checkout'),
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
