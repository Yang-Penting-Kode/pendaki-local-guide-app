import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Import agar anti-lemot

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
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
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildOrderCard(
                context: context,
                title: 'Tenda Eiger 4P',
                store: 'Toko Merdeka Outdoor',
                date: '15 - 17 Okt 2024',
                status: 'Menunggu Konfirmasi',
                statusBg: const Color.fromARGB(255, 255, 252, 216),
                statusText: const Color.fromARGB(255, 184, 181, 0),
                imageUrl:
                    'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
                onTap: () => _showWaitingModal(context),
              ),
              const SizedBox(height: 12),
              _buildOrderCard(
                context: context,
                title: 'Carrier Osprey 65L',
                store: 'Basecamp Rental',
                date: '16 Okt 2024',
                status: 'Sedang Diantar',
                statusBg: const Color(0xFFC5ECD4),
                statusText: const Color(0xFF005F3F),
                imageUrl:
                    'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400',
                onTap: () => Navigator.pushNamed(context, '/tracking-order'),
              ),
              const SizedBox(height: 12),
              _buildOrderCard(
                context: context,
                title: 'Carrier Osprey 65L',
                store: 'Basecamp Rental',
                date: '18 Okt 2024',
                status: 'Dibatalkan',
                statusBg: const Color(0xFFFFDAD8),
                statusText: const Color.fromARGB(255, 197, 70, 53),
                imageUrl:
                    'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400',
                onTap: () => _showCancelledModal(context),
              ),
            ],
          ),
          const Center(child: Text('Belum ada riwayat pesanan')),
        ],
      ),
    );
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
