import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../components/filter_modal.dart';

class BasecampPartnersScreen extends StatelessWidget {
  const BasecampPartnersScreen({super.key});

  // Fungsi untuk menampilkan modal filter
  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 TANGKAP ARGUMEN RADIUS (Default 5000.0 meter jika tidak ada)
    final double radiusValue =
        ModalRoute.of(context)?.settings.arguments as double? ?? 5000.0;

    // Koordinat simulasi untuk Basecamp Tretes (Arjuno)
    final LatLng basecampLocation = LatLng(-7.7000, 112.6333);

    const Color primaryColor = Color(0xFF006C0C);
    const Color surfaceColor = Color(0xFFF9F9F9);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Interactive Map Area (OSM + Flutter Map)
          Positioned.fill(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: basecampLocation,
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.localguide.app',
                ),
                // RADIUS DINAMIS BERDASARKAN PILIHAN USER
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: basecampLocation,
                      radius: radiusValue,
                      useRadiusInMeter: true,
                      color: primaryColor.withOpacity(0.1),
                      borderColor: primaryColor,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                // Marker Layer (Basecamp & Mitra)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: basecampLocation,
                      width: 80,
                      height: 80,
                      child: _buildLocationPin(
                        icon: Icons.home,
                        label: 'Basecamp Tretes',
                        color: Colors.red,
                      ),
                    ),
                    _buildMitraMarker(LatLng(-7.7020, 112.6350)),
                    _buildMitraMarker(LatLng(-7.6980, 112.6300)),
                    _buildMitraMarker(LatLng(-7.7050, 112.6380)),
                  ],
                ),
              ],
            ),
          ),

          // 2. Custom TopAppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10, bottom: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: primaryColor),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8)),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Mitra Basecamp',
                          style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // 3. Bottom Sheet: Partner List
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                              children: [
                                const TextSpan(text: '12 Mitra di\n'),
                                TextSpan(
                                    text:
                                        'Radius ${(radiusValue / 1000).toStringAsFixed(0)} km',
                                    style: const TextStyle(
                                        color: primaryColor, fontSize: 18)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.tune),
                            style: IconButton.styleFrom(
                                backgroundColor: surfaceColor),
                            onPressed: () => _showFilter(context),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        children: [
                          // 🚀 Tambahkan 'context' sebagai parameter pertama
                          _buildPartnerCard(
                              context,
                              'Tretes Gear Hub',
                              '4.9',
                              '1.2 km',
                              'https://images.unsplash.com/photo-1551632811-561732d1e306'),
                          _buildPartnerCard(
                              context,
                              'Arjuno Provisions',
                              '4.7',
                              '2.5 km',
                              'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2'),
                          _buildPartnerCard(
                              context,
                              'Puncak Supply Co.',
                              '4.5',
                              '3.8 km',
                              'https://images.unsplash.com/photo-1520639889413-5d5586198482'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildLocationPin(
      {required IconData icon, required String label, required Color color}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2)),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(4)),
          child: Text(label,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Marker _buildMitraMarker(LatLng point) {
    return Marker(
      point: point,
      width: 30,
      height: 30,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF006C0C),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2)),
        child: const Icon(Icons.storefront, color: Colors.white, size: 14),
      ),
    );
  }

  // 🚀 PERBAIKAN: Tambahkan parameter 'BuildContext context' agar Navigator bisa jalan
  Widget _buildPartnerCard(BuildContext context, String name, String rating,
      String distance, String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage(imgUrl)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(rating,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '• $distance dari Basecamp',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                context, '/rental-detail'), // Sekarang context sudah dikenali
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006C0C),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Katalog',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
