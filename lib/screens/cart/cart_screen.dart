import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_image.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': 1,
      'name': 'Tenda Eiger 4P',
      'subtitle': 'Kapasitas 4 Orang',
      'price': 50000,
      'quantity': 1,
      'isSelected': true,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAbeaAQ5uQ5cSJvfM03-aKTngdAG-XMV13mFmm0IgVAZPkbD8kIb911egh6vk-BoHmJ_k8DPlbCG3yqEpMyVn9lJJ5urJRXQ7p0mkQc9cAPsj1EUtUXFVGxGa7sD7-UbdHL0zNuB_c_hsj-bPtr_FIdAjZEh0QfdHRMOSzpt6sKl3SmX0Fxhase8GGJVtHARrF79lPTX6C9MmDXcsDNjIbdkE7KCzRvLbU5iq5IsVVQQdgbrvu3971LaWhC0zzVsbaYutmQ016XWUQb',
    },
    {
      'id': 2,
      'name': 'Carrier Osprey 60L',
      'subtitle': 'Termasuk Raincover',
      'price': 50000,
      'quantity': 1,
      'isSelected': true,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA1sCAPkoD2C50h0mBviqHVNYX6p12CF_0b9dRmnShQW2d3jM87i7OnLyoc0DrUn_76z_oDBBzNqyMRUjBefarFjdxYl1Ukk9DYV-pwk5zaxWi2NizvikwA_9R13OhQBNuSFn8alvFuXHRu2wXEKSJ_g2dMtMsA2sabH50lhat5ZAiV3xswumh0NveP1te34v69dHe3F2csnYkFuvy6gY4w8V4XWJE2GY3mZGlZfAPhY0mzr_HIuRuys_sjJWrZGAb6nIDmYCwokM6m',
    },
  ];

  bool _isStoreSelected = true;

  int get _totalPrice {
    return _cartItems.where((item) => item['isSelected']).fold(
        0,
        (sum, item) =>
            sum + (item['price'] as int) * (item['quantity'] as int));
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQty = _cartItems[index]['quantity'] + delta;
      if (newQty > 0) _cartItems[index]['quantity'] = newQty;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color surfaceColor = Color(0xFFF3F3F3);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Keranjang Sewa',
            style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStoreHeader(primaryColor),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _cartItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _buildCartItem(index, _cartItems[index], primaryColor),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
          // Footer dipisahkan agar logic constraint lebih bersih
          _buildFixedFooter(primaryColor),
        ],
      ),
    );
  }

  Widget _buildStoreHeader(Color primaryColor) {
    return Row(
      children: [
        Checkbox(
          value: _isStoreSelected,
          activeColor: primaryColor,
          onChanged: (val) {
            setState(() {
              _isStoreSelected = val!;
              for (var item in _cartItems) {
                item['isSelected'] = val;
              }
            });
          },
        ),
        const Text('Toko Merdeka Outdoor',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildCartItem(
      int index, Map<String, dynamic> item, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // 🚀 FIX: Beri border & shadow tipis agar kartu terlihat di layar VIVO
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: item['isSelected'],
            activeColor: primaryColor,
            onChanged: (val) => setState(() => item['isSelected'] = val),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomNetworkImage(
                imageUrl: item['image'], width: 70, height: 70),
          ),
          const SizedBox(width: 12),
          // 🚀 FIX: Gunakan Expanded untuk mencegah teks mendorong UI keluar layar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(item['subtitle'],
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text('Rp ${item['price']}',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis),
                    ),
                    _buildQtyControl(index),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyControl(int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQtyBtn(Icons.remove, () => _updateQuantity(index, -1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('${_cartItems[index]['quantity']}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          _buildQtyBtn(Icons.add, () => _updateQuantity(index, 1)),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Padding(
          padding: const EdgeInsets.all(6), child: Icon(icon, size: 16)),
    );
  }

  Widget _buildFixedFooter(Color primaryColor) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4))
          ],
        ),
        child: Row(
          children: [
            // 🚀 FIX: Expanded pada teks agar tombol punya ruang yang pasti
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Estimasi',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('Rp $_totalPrice',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // 🚀 FIX: SizedBox dengan lebar tetap untuk mengatasi "Infinite Width"
            SizedBox(
              width: 140,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/checkout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size.zero, // 🚀 Reset paksa tema global
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                ),
                child: const Text('Booking',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
