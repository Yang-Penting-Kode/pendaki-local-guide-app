import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/order_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/transactions/order_model.dart';
import 'package:pendaki_local_guide_app/core/constants/app_colors.dart';
import 'package:pendaki_local_guide_app/widgets/custom_image.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderId = ModalRoute.of(context)?.settings.arguments as String?;
    if (orderId == null) {
      return const Scaffold(body: Center(child: Text('ID Pesanan tidak valid')));
    }

    final ordersAsync = ref.watch(orderProvider);

    return ordersAsync.when(
      data: (orders) {
        final order = orders.firstWhere((o) => o.id == orderId, orElse: () => throw Exception('Order not found'));

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Manrope',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Status Card
            _buildStatusCard(order),
            const SizedBox(height: 32),

            // 2. Produk yang Disewa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Produk yang Disewa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('${order.items.length} Item', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildOrderItem(
                item.productName,
                'ALAT',
                order.storeId,
                'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
              ),
            )).toList(),
            const SizedBox(height: 32),

            // 3. Rincian Pembayaran
            _buildPaymentDetail(order),
            const SizedBox(height: 100), // Spacer untuk footer
          ],
        ),
      ),
      bottomSheet: _buildFooter(context, order.id),
    );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildStatusCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF95F6C4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.status.name.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '#${order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const Icon(Icons.check_circle, color: AppColors.primary, size: 48),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String title, String tag, String shop, String img) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomNetworkImage(imageUrl: img, width: 70, height: 70),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tag,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: [
                    const Icon(Icons.storefront, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(shop,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetail(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rincian Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildPriceRow('Subtotal Sewa', 'Rp ${order.rentalCost.toStringAsFixed(0)}'),
          _buildPriceRow('Biaya Layanan', 'Rp ${order.platformServiceFee.toStringAsFixed(0)}'),
          _buildPriceRow('Biaya Pengantaran', 'Rp ${order.deliveryCost.toStringAsFixed(0)}'),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pembayaran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                'Rp ${order.totalGrossPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDiscount ? AppColors.primary : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, String orderId) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/pickup-confirmation', arguments: orderId),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        ),
        child: const Text(
          'Konfirmasi Pengambilan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
