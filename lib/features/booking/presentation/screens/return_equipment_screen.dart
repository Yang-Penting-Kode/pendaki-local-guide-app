import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../widgets/custom_image.dart';
import '../../providers/order_provider.dart';
import '../../../../shared/models/transactions/order_model.dart';

class ReturnEquipmentScreen extends ConsumerStatefulWidget {
  const ReturnEquipmentScreen({super.key});

  @override
  ConsumerState<ReturnEquipmentScreen> createState() => _ReturnEquipmentScreenState();
}

class _ReturnEquipmentScreenState extends ConsumerState<ReturnEquipmentScreen> {
  Timer? _countdownTimer;
  Duration _timeLeft = Duration.zero;
  String? _orderId;
  OrderModel? _order;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_orderId == null) {
      _orderId = ModalRoute.of(context)?.settings.arguments as String?;
      if (_orderId != null) {
        _startTimer();
      }
    }
  }

  void _startTimer() {
    // Initial fetch to set time
    final asyncOrders = ref.read(orderProvider);
    if (asyncOrders.hasValue) {
      final orders = asyncOrders.value!;
      _order = orders.firstWhere((o) => o.id == _orderId, orElse: () => throw Exception('Order not found'));
      _updateTimeLeft();
      
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _updateTimeLeft();
          });
        }
      });
    }
  }

  void _updateTimeLeft() {
    if (_order != null) {
      final now = DateTime.now();
      if (_order!.rentalEndDate.isAfter(now)) {
        _timeLeft = _order!.rentalEndDate.difference(now);
      } else {
        _timeLeft = Duration.zero;
        _countdownTimer?.cancel();
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_orderId == null) {
      return const Scaffold(body: Center(child: Text('ID Pesanan tidak valid')));
    }

    final ordersAsync = ref.watch(orderProvider);
    return ordersAsync.when(
      data: (orders) {
        final order = orders.firstWhere((o) => o.id == _orderId, orElse: () => throw Exception('Order not found'));
        _order = order; // Keep sync
        
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
          'Pengembalian Alat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Manrope',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Countdown Card
            _buildCountdownCard(),
            const SizedBox(height: 32),

            // 2. Rincian Alat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rincian Alat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('${order.items.length} Item Dipinjam',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            ...order.items.map((item) => Column(
              children: [
                _buildGearItem(
                  item.productName,
                  'Rp ${item.unitPrice.toStringAsFixed(0)}',
                  'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
                  item.quantity
                ),
                const SizedBox(height: 12),
              ],
            )),
            const SizedBox(height: 20),

            // 3. Lokasi Pengembalian
            const Text(
              'Lokasi Pengembalian',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildLocationCard(order.storeId),
            const SizedBox(height: 32),

            // 4. Informasi Denda
            _buildPenaltyInfo(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(context, order.id),
    );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildCountdownCard() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String hours = twoDigits(_timeLeft.inHours);
    final String minutes = twoDigits(_timeLeft.inMinutes.remainder(60));
    final String seconds = twoDigits(_timeLeft.inSeconds.remainder(60));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            'WAKTU TERSISA',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$hours:$minutes:$seconds',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, color: AppColors.primary, size: 16),
                SizedBox(width: 8),
                Text(
                  'Tepat Waktu',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGearItem(String title, String sub, String img, int quantity) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomNetworkImage(imageUrl: img, width: 60, height: 60),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(sub,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${quantity}x',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(String storeId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          // 🚀 PERBAIKAN: OSM Map Placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: FlutterMap(
                options: const MapOptions(
                    initialCenter: LatLng(-6.7725, 106.9489), initialZoom: 15),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.localguide.app',
                  ),
                  const MarkerLayer(markers: [
                    Marker(
                        point: LatLng(-6.7725, 106.9489),
                        child: Icon(Icons.location_on, color: Colors.red, size: 36)),
                  ]),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.store,
                      color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Basecamp / Toko Mitra',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text(
                        'Alamat menyesuaikan dengan gerbang pendakian atau store pesanan Anda.',
                        style: TextStyle(
                            color: Colors.grey, fontSize: 12, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenaltyInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6).withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBA1A1A).withOpacity(0.1)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: Color(0xFFBA1A1A), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Denda',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF410002)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keterlambatan pengembalian akan dikenakan denda sebesar Rp 50.000 per jam. Pastikan Anda mengembalikan alat sebelum batas waktu berakhir.',
                  style: TextStyle(
                      fontSize: 12, color: Colors.black87, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, String orderId) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/return-confirmation', arguments: orderId),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
          elevation: 8,
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Lanjut ke Konfirmasi QR',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
