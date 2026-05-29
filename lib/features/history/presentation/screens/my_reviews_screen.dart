import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../widgets/custom_image.dart';
// import '../../booking/providers/order_provider.dart';
import '../../../../features/booking/providers/order_provider.dart';
import '../../../../shared/models/enums/app_enums.dart';

class MyReviewsScreen extends ConsumerWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color primaryColor = Color(0xFF005F3F);
    
    final ordersAsync = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      // 🚀 Gunakan extend agar konten bisa berada di bawah AppBar transparan
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0.5,
        centerTitle: false,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ulasan Saya',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: -0.5),
        ),
      ),
      body: ordersAsync.when(
        data: (orders) {
          final reviewedOrders = orders.where((o) => o.status == OrderStatus.completed && o.rating != null).toList();
          
          final int totalReviews = reviewedOrders.length;
          final double avgRating = totalReviews > 0
              ? reviewedOrders.map((o) => o.rating!).reduce((a, b) => a + b) / totalReviews
              : 0.0;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 40),
            child: Column(
              children: [
                _buildStatsSection(primaryColor, totalReviews, avgRating),
                const SizedBox(height: 24),
                if (reviewedOrders.isEmpty)
                  const Center(child: Text('Belum ada ulasan', style: TextStyle(color: Colors.grey)))
                else
                  ...reviewedOrders.map((order) {
                    final item = order.items.isNotEmpty ? order.items.first : null;
                    return Column(
                      children: [
                        _buildReviewCard(
                          context,
                          title: item?.productName ?? 'Produk',
                          date: DateFormat('dd MMM yyyy').format(order.updatedAt),
                          content: order.reviewText ?? '',
                          rating: order.rating?.toInt() ?? 0,
                          imageUrl: item != null ? 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4' : '',
                          primary: primaryColor,
                          orderId: order.id,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatsSection(Color primary, int totalReviews, double avgRating) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Ulasan',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              Text('$totalReviews',
                  style: TextStyle(
                      color: primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                  const SizedBox(width: 4),
                  Text(avgRating.toStringAsFixed(1),
                      style:
                          const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text('Rata-rata Rating',
                  style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    BuildContext context, {
    required String title,
    required String date,
    required String content,
    required int rating,
    required String imageUrl,
    required Color primary,
    required String orderId,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomNetworkImage(
                    imageUrl: imageUrl, width: 80, height: 80),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(date,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(content,
                        style: const TextStyle(
                            color: Color(0xFF3E4942), fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Text('Hapus',
                      style: TextStyle(color: Colors.grey))),
              const SizedBox(width: 12),
              // 🚀 FIX: Bungkus dengan Flexible atau gunakan tombol tanpa infinity width
              Flexible(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/review', arguments: orderId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary.withOpacity(0.1),
                    foregroundColor: primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                  ),
                  child: const Text('Edit Ulasan',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
