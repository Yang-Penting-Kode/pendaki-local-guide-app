import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RentalDetailScreen extends StatelessWidget {
  const RentalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Koordinat toko (simulasi dekat basecamp)
    final LatLng shopLocation = LatLng(-7.7020, 112.6350);

    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Map Layer (Gelap)
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: shopLocation,
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none), // Statis
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.localguide.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: shopLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on,
                            color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. Tombol Back Transparan
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: primaryColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 3. Shop Detail Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 50,
                      offset: Offset(0, -20)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  // 🚀 Header: Foto Profil, Nama Toko & Rating (DIPERBARUI)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🖼️ Foto Profil Toko
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10)
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=200',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.storefront,
                                    color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Toko Merdeka Outdoor',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'SPESIALIS TENDA & CARRIER',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC5ECD4),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star,
                                color: Color(0xFF496C59), size: 14),
                            SizedBox(width: 4),
                            Text('4.8',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF496C59))),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Jarak
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.near_me, color: primaryColor, size: 18),
                        SizedBox(width: 8),
                        Text('Berjarak 1.2 km dari lokasi Anda',
                            style: TextStyle(
                                fontSize: 13, color: onSurfaceVariant)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bento Layout Info
                  Row(
                    children: [
                      _buildBentoCard(
                          Icons.verified, 'Status Toko', 'Official Partner'),
                      const SizedBox(width: 16),
                      _buildBentoCard(
                          Icons.schedule, 'Jam Operasional', 'Buka s/d 21:00'),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      // 🚀 Navigasi ke layar Katalog
                      onPressed: () => Navigator.pushNamed(context, '/catalog'),
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('Lihat Katalog Alat',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryContainer,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      // 🚀 Navigasi ke layar Lacak Lokasi
                      onPressed: () =>
                          Navigator.pushNamed(context, '/track-location'),
                      icon: const Icon(Icons.location_on),
                      label: const Text('Lacak Lokasi',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryContainer,
                        side:
                            const BorderSide(color: primaryContainer, width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF005F3F)),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF3E4942))),
            Text(value,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
