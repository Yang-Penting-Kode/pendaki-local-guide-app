import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pendaki_local_guide_app/widgets/custom_image.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/order_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/transactions/order_model.dart';
import 'package:pendaki_local_guide_app/shared/models/enums/app_enums.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: 1); // Default ke tab 'Selesai'
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    // 🚀 Ambil data dari provider (Bentuk AsyncValue)
    final ordersAsync = ref.watch(orderProvider);

    Widget buildOrderList(List<OrderModel> list, String emptyMessage) {
      if (list.isEmpty) return Center(child: Text(emptyMessage));
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final order = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildTransactionCard(
              date: DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt),
              status: order.status.name.toUpperCase(),
              title: order.items.isNotEmpty ? order.items.first.productName : 'Pesanan',
              store: order.storeId,
              totalPrice: order.totalGrossPrice.toStringAsFixed(0),
              buttonLabel: (order.status == OrderStatus.completed && order.rating != null) ? 'Lihat Review' : 'Detail',
              imageUrl: 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
              onCardTap: () => Navigator.pushNamed(context, '/order-detail', arguments: order.id),
              onButtonTap: () {
                if (order.status == OrderStatus.completed && order.rating != null) {
                  Navigator.pushNamed(context, '/my-reviews');
                } else {
                  Navigator.pushNamed(context, '/order-detail', arguments: order.id);
                }
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: surfaceColor,
      // 1. Sticky App Bar & Tab Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => _showNotificationModal(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: onSurfaceVariant,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Berlangsung'),
            Tab(text: 'Selesai'),
            Tab(text: 'Dibatalkan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: ordersAsync.when(
          data: (orders) {
            final activeOrders = orders.where((o) => o.status != OrderStatus.completed && o.status != OrderStatus.cancelled).toList();
            final completedOrders = orders.where((o) => o.status == OrderStatus.completed).toList();
            final cancelledOrders = orders.where((o) => o.status == OrderStatus.cancelled).toList();
            
            return [
              buildOrderList(activeOrders, 'Belum ada pesanan berlangsung'),
              buildOrderList(completedOrders, 'Tidak ada pesanan selesai'),
              buildOrderList(cancelledOrders, 'Tidak ada pesanan dibatalkan'),
            ];
          },
          loading: () => [
            const Center(child: CircularProgressIndicator()),
            const Center(child: CircularProgressIndicator()),
            const Center(child: CircularProgressIndicator()),
          ],
          error: (err, stack) => [
            Center(child: Text('Error: $err')),
            Center(child: Text('Error: $err')),
            Center(child: Text('Error: $err')),
          ],
        ),
      ),
    );
  }

  // --- HELPER CARD WIDGET ---
  Widget _buildTransactionCard({
    required String date,
    required String status,
    required String title,
    required String store,
    required String totalPrice,
    required String buttonLabel,
    required String imageUrl,
    required VoidCallback onCardTap,
    required VoidCallback onButtonTap,
  }) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color secondaryContainer = Color(0xFFC5ECD4);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Membungkus area Header dan Body agar dapat diketuk terpisah
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onCardTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Tanggal & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(date,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: secondaryContainer,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                            color: primaryContainer,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Body: Gambar & Nama Produk
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      // 🚀 PERBAIKAN: Gunakan CustomNetworkImage
                      child: CustomNetworkImage(
                        imageUrl: imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(store,
                              style:
                                  const TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Footer: Harga & Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Belanja',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text('Rp $totalPrice',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              OutlinedButton(
                // 🚀 PERBAIKAN: Hitbox terpisah untuk action button
                onPressed: onButtonTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: const BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(buttonLabel,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
