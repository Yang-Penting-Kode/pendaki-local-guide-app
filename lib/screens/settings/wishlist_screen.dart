import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Anti-lemot image loader

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  // 🔍 MODAL 1: Pencarian Cepat
  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 24),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari tenda, carrier, atau sepatu...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF006C0C)),
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Pencarian Populer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['Tenda 4P', 'Matras Angin', 'Headlamp', 'Carrier 65L']
                  .map((tag) => ActionChip(
                        label: Text(tag, style: const TextStyle(fontSize: 12)),
                        onPressed: () {},
                        backgroundColor: const Color(0xFFF3F3F3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 🛒 MODAL 2: Keranjang Belanja (Bottom Sheet)
  void _showCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Column(
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Keranjang Saya',
                    style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                Text('Hapus Semua',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCartItem('Tenda Eiger 4P', 'Rp 50.000',
                      'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=200'),
                  _buildCartItem('Matras Ultralight', 'Rp 15.000',
                      'https://images.unsplash.com/photo-1596751303362-78d1fe9007aa?q=80&w=200'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Pembayaran',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      Text('Rp 65.000',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF006C0C))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006C0C),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99)),
                      ),
                      child: const Text('Lanjutkan Pembayaran',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color surfaceColor = Color(0xFFF9F9F9);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Wishlist Alat Outdoor',
            style: TextStyle(
                color: Color(0xFF1A1C1C),
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        actions: [
          IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF1B5E20)),
              onPressed: () => _showSearchModal(context)),
          IconButton(
              icon: const Icon(Icons.shopping_bag_outlined,
                  color: Color(0xFF1B5E20)),
              onPressed: () => _showCartModal(context)),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        children: [
          _buildHeaderStats(primaryColor),
          const SizedBox(height: 48),
          _buildWishlistItem(
              'Tenda Eiger 4P',
              '4.8',
              '128',
              '50.000',
              'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
              primaryColor),
          _buildWishlistItem(
              'Carrier Osprey 65L',
              '4.9',
              '256',
              '75.000',
              'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400',
              primaryColor),
          _buildWishlistItem(
              'Sepatu Trekking Pro',
              '4.7',
              '89',
              '45.000',
              'https://images.unsplash.com/photo-1520211417246-3bb24249a2b5?q=80&w=400',
              primaryColor),
          const SizedBox(height: 24),
          _buildFooterBento(primaryColor),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeaderStats(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('03',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 56,
                fontWeight: FontWeight.w800,
                color: primaryColor,
                letterSpacing: -3,
                height: 1)),
        const SizedBox(height: 8),
        const Text('ITEM DALAM WISHLIST ANDA',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Color(0xFF6F7A6A))),
      ],
    );
  }

  Widget _buildWishlistItem(String title, String rating, String reviews,
      String price, String imageUrl, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ]),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomNetworkImage(
                  imageUrl: imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover)),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      const Icon(Icons.delete_outline,
                          color: Colors.red, size: 18),
                    ]),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star, color: Colors.orange, size: 12),
                  const SizedBox(width: 4),
                  Text(rating,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 11)),
                  const SizedBox(width: 4),
                  Text('($reviews review)',
                      style: const TextStyle(
                          color: Color(0xFF6F7A6A), fontSize: 10))
                ]),
                const SizedBox(height: 12),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text('Rp $price / hari',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: primaryColor,
                                  overflow: TextOverflow.ellipsis))),
                      _buildBookingButton(),
                    ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF006C0C), Color(0xFF1C871E)]),
          borderRadius: BorderRadius.circular(99)),
      child: const Text('Booking',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  Widget _buildCartItem(String title, String price, String img) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomNetworkImage(imageUrl: img, width: 50, height: 50)),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(price,
                    style:
                        const TextStyle(color: Color(0xFF006C0C), fontSize: 12))
              ])),
          const Icon(Icons.remove_circle_outline, color: Colors.grey),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8), child: Text('1')),
          const Icon(Icons.add_circle_outline, color: Color(0xFF006C0C)),
        ],
      ),
    );
  }

  Widget _buildFooterBento(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: const Color(0xFF1C871E),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Siap untuk petualangan berikutnya?',
              style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Lengkapi peralatanmu dan mulai eksplorasi jalur baru.',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99))),
              child: const Text('Cari Peralatan',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
