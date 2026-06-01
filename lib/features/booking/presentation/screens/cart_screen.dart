// START REPLACE
// =============================================================================
// 🛒 CART SCREEN — Keranjang Sewa (RIVERPOD INJECTED)
// Lokasi: lib/features/booking/presentation/screens/cart_screen.dart
//
// Migrasi: screens/cart/cart_screen.dart → features/booking/presentation/screens/
// Perubahan: StatefulWidget → ConsumerStatefulWidget
// Injeksi: cartProvider (List<OrderItemModel>), cartTotalProvider (Decimal)
// UI: Desain asli (shadow, border, warna) DIPERTAHANKAN.
// Skema Biaya: Total dari cartTotalProvider sudah include markup Rp 1.000/item.
//   Biaya Admin Rp 5.000 ditampilkan sebagai baris info terpisah.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/cart_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/transactions/order_model.dart';
import 'package:pendaki_local_guide_app/widgets/custom_image.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  // _isStoreSelected dihapus — tidak relevan dengan model OrderItemModel
  // _cartItems dihapus — data dari cartProvider
  // _totalPrice dihapus — data dari cartTotalProvider
  // _updateQuantity dihapus — gunakan cartProvider.notifier methods

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color surfaceColor = Color(0xFFF3F3F3);

    // 🔌 Injeksi: List item dari cartProvider
    final cartItems = ref.watch(cartProvider);

    // 🔌 Injeksi: Total harga dari cartTotalProvider (sudah include markup Rp 1.000/item)
    final cartTotal = ref.watch(cartTotalProvider);

    // Total tagihan = cart total + biaya admin Rp 5.000
    final adminFee = Decimal.parse('5000');
    final grandTotal = cartTotal + adminFee;

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
          // 🔌 Injeksi: Kondisional — kosong atau isi
          cartItems.isEmpty
              ? _buildEmptyCart(primaryColor)
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Store header (dipertahankan dari desain asli)
                      _buildStoreHeader(primaryColor),
                      const SizedBox(height: 12),
                      // 🔌 Injeksi: List dari cartProvider
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            _buildCartItem(cartItems[index], primaryColor),
                      ),
                      // Spacer agar tidak tertutup footer
                      const SizedBox(height: 180),
                    ],
                  ),
                ),
          // Footer selalu tampil
          _buildFixedFooter(primaryColor, cartTotal, adminFee, grandTotal,
              cartItems.isEmpty),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildEmptyCart(Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Keranjang Kosong',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Tambahkan alat dari katalog untuk mulai menyewa.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/catalog'),
            icon: const Icon(Icons.explore),
            label: const Text('Lihat Katalog'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreHeader(Color primaryColor) {
    return Row(
      children: [
        Icon(Icons.store, color: primaryColor, size: 20),
        const SizedBox(width: 8),
        const Text('Toko Merdeka Outdoor',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  // 🔌 Injeksi: Parameter berubah dari Map → OrderItemModel
  Widget _buildCartItem(OrderItemModel item, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Desain asli: border & shadow dipertahankan
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
          // Gambar produk — CustomNetworkImage dipertahankan
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomNetworkImage(
              imageUrl:
                  'https://picsum.photos/seed/z41jvl/600/400',
              width: 70,
              height: 70,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔌 Injeksi: Nama produk dari OrderItemModel
                Text(item.productName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                // 🔌 Injeksi: Subtitle — tampilkan qty info
                const Text('Unit Sewa',
                    style:
                        TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      // 🔌 Injeksi: Harga dari item.unitPrice (Decimal → String)
                      child: Text(
                          'Rp ${item.unitPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis),
                    ),
                    // 🔌 Injeksi: Qty control menggunakan cartProvider.notifier
                    _buildQtyControl(item, primaryColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔌 Injeksi: Terima OrderItemModel sebagai parameter
  Widget _buildQtyControl(OrderItemModel item, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQtyBtn(
            Icons.remove,
            // 🔌 Injeksi: decrementQty via cartProvider
            () => ref.read(cartProvider.notifier).decrementQty(item.productId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // 🔌 Injeksi: quantity dari OrderItemModel
            child: Text('${item.quantity}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          _buildQtyBtn(
            Icons.add,
            // 🔌 Injeksi: incrementQty via cartProvider
            () => ref.read(cartProvider.notifier).incrementQty(item.productId),
          ),
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

  Widget _buildFixedFooter(Color primaryColor, Decimal cartTotal,
      Decimal adminFee, Decimal grandTotal, bool isEmpty) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Baris info biaya admin (Skema Flat Fee)
            if (!isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal Sewa',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text('Rp ${cartTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            if (!isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Biaya Admin',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text('Rp ${adminFee.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            if (!isEmpty) const Divider(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Tagihan',
                          style:
                              TextStyle(color: Colors.grey, fontSize: 12)),
                      // 🔌 Injeksi: Grand total = cartTotal + adminFee
                      Text(
                        isEmpty
                            ? 'Rp 0'
                            : 'Rp ${grandTotal.toStringAsFixed(0)}',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 140,
                  height: 50,
                  child: ElevatedButton(
                    // Disable jika keranjang kosong
                    onPressed: isEmpty
                        ? null
                        : () => Navigator.pushNamed(context, '/checkout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99)),
                    ),
                    child: const Text('Booking',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// END REPLACE
