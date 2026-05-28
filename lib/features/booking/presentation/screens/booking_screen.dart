import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/order_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/transactions/order_model.dart';
import 'package:pendaki_local_guide_app/shared/models/enums/app_enums.dart';
import '../../../../widgets/custom_image.dart'; // 🚀 Import agar anti-lemot

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 🛡️ MODAL: Menunggu Konfirmasi
  void _showWaitingModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                    color: Color(0xFFF0F9F4), shape: BoxShape.circle),
                child: const Icon(Icons.schedule,
                    color: Color(0xFF007A52), size: 40),
              ),
              const SizedBox(height: 24),
              const Text('Menunggu Konfirmasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                  'Permintaan sewa Anda telah terkirim. Mohon tunggu konfirmasi dari Mitra dalam waktu maksimal 30 menit.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, height: 1.5)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // 🚀 FIX: Tutup modal dulu sebelum pindah halaman[cite: 6]
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/waiting-confirmation');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007A52),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99))),
                  child: const Text('Lihat Detail Pesanan',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/dashboard', (route) => false),
                child: const Text('Kembali ke Beranda',
                    style: TextStyle(
                        color: Color(0xFF007A52), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🛡️ MODAL: Pesanan Dibatalkan
  void _showCancelledModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.grey.shade50, shape: BoxShape.circle),
                child: const Icon(Icons.cancel_outlined,
                    color: Colors.grey, size: 48),
              ),
              const SizedBox(height: 24),
              const Text('Pesanan Dibatalkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                  'Maaf, pesanan Anda telah dibatalkan. Jika ini adalah kesalahan, silakan hubungi pusat bantuan kami.',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.grey, fontSize: 14, height: 1.5)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // 🚀 FIX: Tutup modal dulu sebelum pindah halaman[cite: 6]
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/order-cancelled');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007A52),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99))),
                  child: const Text('Lihat Riwayat Pesanan',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/dashboard', (route) => false),
                child: const Text('Kembali ke Beranda',
                    style: TextStyle(
                        color: Color(0xFF007A52), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color surfaceColor = Color(0xFFF9F9F9);

    final ordersAsync = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pesanan Alat',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Aktif'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Terjadi kesalahan: $err')),
        data: (orders) {
          final activeOrders = orders.where((o) =>
              o.status == OrderStatus.awaitingConfirmation ||
              o.status == OrderStatus.activeRental ||
              o.status == OrderStatus.readyForReturn).toList();

          final historyOrders = orders.where((o) =>
              o.status == OrderStatus.completed ||
              o.status == OrderStatus.cancelled).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              // TAB 1: AKTIF
              activeOrders.isEmpty
                  ? const Center(child: Text('Belum ada pesanan aktif'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: activeOrders.length,
                      itemBuilder: (context, index) {
                        final order = activeOrders[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildOrderCardFromModel(context, order),
                        );
                      },
                    ),

              // TAB 2: RIWAYAT
              historyOrders.isEmpty
                  ? const Center(child: Text('Belum ada riwayat pesanan'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: historyOrders.length,
                      itemBuilder: (context, index) {
                        final order = historyOrders[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildOrderCardFromModel(context, order),
                        );
                      },
                    ),
            ],
          );
        },
      ),
    );
  }

  // --- HELPER METHODS ---

  Widget _buildOrderCardFromModel(BuildContext context, OrderModel order) {
    final title = order.items.isNotEmpty
        ? order.items.first.productName
        : "Pesanan #${order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id}";
    
    // Tampilkan jumlah item lain jika lebih dari 1
    final displayTitle = order.items.length > 1
        ? "$title (+${order.items.length - 1} item lain)"
        : title;

    final dateStr = "${order.rentalStartDate.day}/${order.rentalStartDate.month}/${order.rentalStartDate.year}";
    final priceStr = "Rp ${order.totalGrossPrice.toStringAsFixed(0)}";
    
    // Fallback imageUrl
    const fallbackImage = 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400';
    
    VoidCallback? action;
    if (order.status == OrderStatus.awaitingConfirmation || order.status == OrderStatus.readyForReturn) {
      action = () => Navigator.pushNamed(context, '/qr-generator', arguments: order.id);
    } else if (order.status == OrderStatus.cancelled) {
      action = () => _showCancelledModal(context);
    } else if (order.status == OrderStatus.activeRental) {
      action = () => Navigator.pushNamed(context, '/tracking-order');
    } else {
      action = () => Navigator.pushNamed(context, '/order-detail');
    }

    return _buildOrderCard(
      context: context,
      title: displayTitle,
      store: priceStr, // Menggunakan harga di tempat nama toko untuk UI karena tidak ada field harga di UI Card asli
      date: dateStr,
      status: _getStatusText(order.status),
      statusBg: _getStatusBgColor(order.status),
      statusText: _getStatusTextColor(order.status),
      imageUrl: fallbackImage,
      onTap: action,
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.awaitingConfirmation:
        return 'Menunggu Konfirmasi';
      case OrderStatus.activeRental:
        return 'Sedang Disewa';
      case OrderStatus.readyForReturn:
        return 'Siap Dikembalikan';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  Color _getStatusBgColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.awaitingConfirmation:
        return const Color.fromARGB(255, 255, 252, 216);
      case OrderStatus.activeRental:
      case OrderStatus.readyForReturn:
      case OrderStatus.completed:
        return const Color(0xFFC5ECD4);
      case OrderStatus.cancelled:
        return const Color(0xFFFFDAD8);
    }
  }

  Color _getStatusTextColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.awaitingConfirmation:
        return const Color.fromARGB(255, 184, 181, 0);
      case OrderStatus.activeRental:
      case OrderStatus.readyForReturn:
      case OrderStatus.completed:
        return const Color(0xFF005F3F);
      case OrderStatus.cancelled:
        return const Color.fromARGB(255, 197, 70, 53);
    }
  }

  Widget _buildOrderCard({
    required BuildContext context,
    required String title,
    required String store,
    required String date,
    required String status,
    required Color statusBg,
    required Color statusText,
    required String imageUrl,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          status,
                          style: TextStyle(
                              color: statusText,
                              fontSize: 9,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(store,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(date,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11)),
                      if (onTap != null) ...[
                        const Spacer(),
                        const Icon(Icons.chevron_right,
                            size: 16, color: Colors.grey),
                      ]
                    ],
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
