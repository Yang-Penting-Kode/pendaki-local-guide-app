import 'package:flutter/material.dart';

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
          // Tab 1: Pesanan Aktif
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildOrderCard(
                title: 'Tenda Eiger 4P',
                store: 'Toko Merdeka Outdoor',
                date: '15 - 17 Okt 2024',
                status: 'Menunggu Konfirmasi',
                statusBg: const Color(0xFFFFDAD8),
                statusText: const Color(0xFF8A3837),
                imageUrl:
                    'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
              ),
              const SizedBox(height: 12),
              _buildOrderCard(
                title: 'Carrier Osprey 65L',
                store: 'Basecamp Rental',
                date: '16 Okt 2024',
                status: 'Siap Diambil',
                statusBg: const Color(0xFFC5ECD4),
                statusText: const Color(0xFF005F3F),
                imageUrl:
                    'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400',
              ),
              const SizedBox(height: 12),
              _buildOrderCard(
                title: 'Sepatu Hiking Columbia',
                store: 'Jejak Rimba Gear',
                date: '14 - 16 Okt 2024',
                status: 'Sedang Disewa',
                statusBg: const Color(0xFF007A52).withOpacity(0.1),
                statusText: const Color(0xFF007A52),
                imageUrl:
                    'https://images.unsplash.com/photo-1520639889413-5d5586198482?q=80&w=400',
              ),
            ],
          ),
          // Tab 2: Riwayat (Placeholder)
          const Center(child: Text('Belum ada riwayat pesanan')),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required String title,
    required String store,
    required String date,
    required String status,
    required Color statusBg,
    required Color statusText,
    required String imageUrl,
  }) {
    return Container(
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
          // Gambar Produk
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Info Detail
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
                        borderRadius: BorderRadius.circular(4),
                      ),
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
                Text(
                  store,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
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
}
