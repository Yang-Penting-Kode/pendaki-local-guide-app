import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Import sudah benar

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int _cartCount = 0;

  void _addToCart() {
    setState(() {
      _cartCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alat berhasil ditambahkan ke keranjang!'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF007A52),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);

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
              if (_cartCount > 0)
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
                      '$_cartCount',
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
            // 2. Shop Header Section
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

            // 3. Category Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTab('Semua Alat', isActive: false),
                  _buildTab('Tenda', isActive: true),
                  _buildTab('Carrier', isActive: false),
                  _buildTab('Logistik', isActive: false),
                ],
              ),
            ),

            // 4. Product Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65,
              children: [
                _buildProductCard(context, 'Tenda Eiger 4P', '50.000', '3',
                    'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4'),
                _buildProductCard(
                    context,
                    'Tenda Consina Magnum 4',
                    '45.000',
                    '1',
                    'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7'),
                _buildProductCard(
                    context,
                    'Tenda Great Outdoor 6P',
                    '75.000',
                    '5',
                    'https://images.unsplash.com/photo-1537225228614-56cc3556d7ed'),
                _buildProductCard(
                    context,
                    'Tenda Naturehike Cloud Up 2',
                    '60.000',
                    '2',
                    'https://images.unsplash.com/photo-1517824806704-9040b037703b'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

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
    return Container(
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
    );
  }

  Widget _buildProductCard(BuildContext context, String name, String price,
      String stock, String imgUrl) {
    const Color primaryColor = Color(0xFF005F3F);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product-detail'),
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
                    // 🚀 PERBAIKAN: Gunakan CustomNetworkImage
                    child: CustomNetworkImage(
                      imageUrl: imgUrl,
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
                      child: Text('Tersedia $stock',
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
                  Text(name,
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
                        TextSpan(text: 'Rp $price '),
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
                      onPressed: _addToCart,
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
