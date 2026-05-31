import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrackLocationScreen extends StatelessWidget {
  const TrackLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Koordinat simulasi (User & Toko)
    final LatLng userLocation = LatLng(-7.7050, 112.6300);
    final LatLng shopLocation = LatLng(-7.7020, 112.6350);

    const Color primaryColor = Color(0xFF007A52);
    const Color surfaceColor = Color(0xFFF9F9F9);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Map Layer
          Positioned.fill(
            child: FlutterMap(
              options: MapOptions(
                initialCenter:
                    LatLng(-7.7035, 112.6325), // Center di antara keduanya
                initialZoom: 15.5,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.localguide.app',
                ),
                // Garis Rute (Dashed Line)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [userLocation, shopLocation],
                      color: primaryColor.withOpacity(0.4),
                      strokeWidth: 4,
                      isDotted: true, // Membuat garis putus-putus
                    ),
                  ],
                ),
                // Marker Layer
                MarkerLayer(
                  markers: [
                    // User Location dengan Animasi Pulsing
                    Marker(
                      point: userLocation,
                      width: 60,
                      height: 60,
                      child: _buildUserLocationDot(primaryColor),
                    ),
                    // Partner/Shop Pin
                    Marker(
                      point: shopLocation,
                      width: 50,
                      height: 60,
                      child: _buildShopPin(primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Custom App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              // 🛡️ Tambahkan ClipRect agar blur tidak bocor ke luar area
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10, sigmaY: 10), // 🚀 Sekarang blur dikenali
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top, bottom: 10),
                  decoration: BoxDecoration(
                    // Gunakan warna dengan opacity agar efek blur di belakang terlihat
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: const Text(
                      'Lacak Lokasi',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    centerTitle: true,
                  ),
                ),
              ),
            ),
          ),

          // 3. Floating Controls (My Location)
          Positioned(
            top: 130,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.white,
              mini: true,
              child:
                  const Icon(Icons.my_location, color: Colors.black, size: 20),
            ),
          ),

          // 4. Bottom Sheet Info
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(height: 24),
                  // Trip Info
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '850 Meter • 5 Menit',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Partner Profile
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1551632811-561732d1e306'),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Toko Merdeka Outdoor',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      color: primaryColor, size: 16),
                                  SizedBox(width: 6),
                                  Text('Siap Diambil',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.chat),
                            label: const Text('Chat Mitra',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(99)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: primaryColor, width: 2),
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Icon(Icons.call, color: primaryColor),
                        ),
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

  // --- UI HELPERS ---

  Widget _buildUserLocationDot(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing Effect
        TweenAnimationBuilder(
          tween: Tween(begin: 1.0, end: 2.5),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) {
            return Container(
              width: 20 * value,
              height: 20 * value,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3 / value),
                shape: BoxShape.circle,
              ),
            );
          },
          onEnd:
              () {}, // Untuk me-loop, biasanya pakai AnimationController di StatefulWidget
        ),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ],
    );
  }

  Widget _buildShopPin(Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10)
              ]),
          child: const Icon(Icons.storefront, color: Colors.white, size: 20),
        ),
        // Tip of the pin
        Transform.translate(
          offset: const Offset(0, -4),
          child: Transform.rotate(
            angle: 0.785, // 45 degrees
            child: Container(width: 10, height: 10, color: color),
          ),
        ),
      ],
    );
  }
}
