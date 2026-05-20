import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/custom_image.dart'; // 🚀 Anti-lemot

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color secondaryContainer = Color(0xFFC5ECD4);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    const LatLng courierPos = LatLng(-6.9147, 107.6098);
    const LatLng userPos = LatLng(-6.9247, 107.6298);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0, // Dibuat lebih flat sesuai gaya Alpine
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryContainer),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lacak Pengantaran',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-6.9197, 107.6198),
              initialZoom: 14.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.localguide.app',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [courierPos, userPos],
                    color: primaryContainer,
                    strokeWidth: 4,
                    isDotted: true,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  const Marker(
                    point: userPos,
                    child: Icon(Icons.person_pin,
                        color: primaryContainer, size: 40),
                  ),
                  Marker(
                    point: courierPos,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 10)
                          ]),
                      child: const Icon(Icons.local_shipping,
                          color: primaryContainer, size: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1), blurRadius: 20)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle)),
                      const SizedBox(width: 12),
                      const Text('Tiba dalam 8 menit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const Text('Jarak: 1.2 km',
                      style: TextStyle(color: onSurfaceVariant, fontSize: 13)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1), blurRadius: 40)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=200'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Budi Santoso',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            // 🚀 FIX OVERFLOW: Menggunakan Wrap agar fleksibel
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: secondaryContainer,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: const Text('Kurir Marketplace',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 14),
                                    const Text(' 4.8',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('No. Kendaraan',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10)),
                          Text('D 1234 GID',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.explore, color: primaryColor),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tenda Eiger 4P sedang diantar',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              SizedBox(height: 4),
                              Text(
                                  'Kurir telah mengambil alat dari gudang pusat dan sedang menuju ke titik koordinat Anda.',
                                  style: TextStyle(
                                      color: onSurfaceVariant,
                                      fontSize: 12,
                                      height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call, size: 18),
                          label: const Text('Hubungi Kurir',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side:
                                const BorderSide(color: primaryColor, width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 56,
                        width: 56,
                        decoration: const BoxDecoration(
                            color: primaryColor, shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.chat, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
