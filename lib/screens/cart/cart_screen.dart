import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // 🚀 Logic: Data simulasi item di keranjang
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': 1,
      'name': 'Tenda Eiger 4P',
      'subtitle': 'Kapasitas 4 Orang',
      'price': 50000,
      'quantity': 1,
      'isSelected': true,
      'image': 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4',
    },
    {
      'id': 2,
      'name': 'Carrier Osprey 60L',
      'subtitle': 'Termasuk Raincover',
      'price': 50000,
      'quantity': 1,
      'isSelected': true,
      'image': 'https://images.unsplash.com/photo-1551632811-561732d1e306',
    },
  ];

  bool _isStoreSelected = true;

  int get _totalPrice {
    return _cartItems.where((item) => item['isSelected']).fold(
        0,
        (sum, item) =>
            sum + (item['price'] as int) * (item['quantity'] as int));
  }

  int get _selectedCount {
    return _cartItems.where((item) => item['isSelected']).length;
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQty = _cartItems[index]['quantity'] + delta;
      if (newQty > 0) {
        _cartItems[index]['quantity'] = newQty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color surfaceColor = Color(0xFFF3F3F3);

    return Scaffold(
      backgroundColor: surfaceColor,
      // 1. Top AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context, ),
        ),
        title: const Text(
          'Keranjang Sewa',
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 2. Store Group Header
            Row(
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
                const Text(
                  'Toko Merdeka Outdoor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 3. Cart Items List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return _buildCartItem(index, item, primaryColor);
              },
            ),
          ],
        ),
      ),
      // 4. Sticky Footer
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Estimasi',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  'Rp $_totalPrice',
                  style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/checkout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99)),
                elevation: 0,
              ),
              child: Text(
                'Booking (${_selectedCount})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(
      int index, Map<String, dynamic> item, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox per item
          Checkbox(
            value: item['isSelected'],
            activeColor: primaryColor,
            onChanged: (val) {
              setState(() => item['isSelected'] = val);
            },
          ),
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Product Info & Quantity
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(item['subtitle'],
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp ${item['price']} / hari',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    // Quantity Selector
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          _buildQtyBtn(
                              Icons.remove, () => _updateQuantity(index, -1)),
                          SizedBox(
                            width: 30,
                            child: Text(
                              '${item['quantity']}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          _buildQtyBtn(
                              Icons.add, () => _updateQuantity(index, 1)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: Colors.grey.shade700),
      ),
    );
  }
}
