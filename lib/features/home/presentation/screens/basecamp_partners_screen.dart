import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pendaki_local_guide_app/core/utils/geolocation_utils.dart';
import '../../../../core/constants/app_colors.dart'; // 🚀 Pastikan sinkron dengan AppColors
import '../../../../components/modals/filter_modal.dart';

class BasecampPartnersScreen extends StatelessWidget {
  const BasecampPartnersScreen({super.key});

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
    // 🚀 FIX NULL CHECK: Tangkap argumen secara aman (MountainData, double, atau Map)
    final args = ModalRoute.of(context)?.settings.arguments;
    double radiusValue = 5000.0; // Default
    MountainData? mountain;
    DateTime? startDate;
    DateTime? endDate;

    if (args is MountainData) {
      mountain = args;
    } else if (args is double) {
      radiusValue = args;
    } else if (args is Map) {
      radiusValue = (args['radius'] as num?)?.toDouble() ?? 5000.0;
      mountain = args['mountain'] as MountainData?;
      startDate = args['startDate'] as DateTime?;
      endDate = args['endDate'] as DateTime?;
    }

    // 🚀 Koordinat peta mengikuti gunung yang dipilih, fallback ke Tretes
    final mapCenter = mountain != null
        ? LatLng(mountain.lat, mountain.lng)
        : const LatLng(-7.7000, 112.6333);
    
    final appBarTitle = mountain?.name ?? 'Mitra Basecamp';

    return Scaffold(
      body: Stack(
        children: [
          // 1. Interactive Map Area
          Positioned.fill(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: mapCenter,
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.localguide.app',
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: mapCenter,
                      radius: radiusValue,
                      useRadiusInMeter: true,
                      color: AppColors.primary.withOpacity(0.1),
                      borderColor: AppColors.primary,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: mapCenter,
                      width: 80,
                      height: 80,
                      child: _buildLocationPin(
                          icon: Icons.home,
                          label: mountain?.name ?? 'Basecamp',
                          color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Custom TopAppBar[cite: 8]
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withOpacity(0.9), Colors.transparent],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.primary),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.white, elevation: 2),
                    ),
                    const Expanded(
                      child: Text('Mitra Basecamp',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // 3. Bottom Sheet: Partner List[cite: 8]
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.35,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Handle Bar
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            width: 48,
                            height: 6,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(3)),
                          ),

                          // Header Info
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('12 Mitra di',
                                        style: TextStyle(
                                            fontFamily: 'Manrope',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        'Radius ${(radiusValue / 1000).toStringAsFixed(0)} km — ${appBarTitle}',
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    if (startDate != null && endDate != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.tune),
                                  style: IconButton.styleFrom(
                                      backgroundColor:
                                          AppColors.surfaceContainerLow),
                                  onPressed: () => _showFilter(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🚀 FIX: Menggunakan SliverList untuk menghindari error child.hasSize
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
// START REPLACE
                            // 🚀 Koordinat dummy mitra (bergeser dari pusat gunung berdasarkan index)
                            final partnerLat = mapCenter.latitude + (index * 0.005) + 0.002;
                            final partnerLng = mapCenter.longitude + (index * 0.005) + 0.002;

                            // 🚀 Eksekusi Haversine Formula
                            final distKm = GeolocationUtils.calculateDistance(
                              mapCenter.latitude, mapCenter.longitude,
                              partnerLat, partnerLng,
                            );
                            final distStr = distKm < 1
                                ? '${(distKm * 1000).toInt()} m'
                                : '${distKm.toStringAsFixed(1)} km';
// END REPLACE
                            return _buildPartnerCard(
                              context,
                              'Tretes Gear Hub #$index',
                              '4.9',
                              distStr, // 🚀 Jarak nyata dari Haversine
                              'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400',
                            );
                          },
                          childCount: 10,
                        ),
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
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.white)),
      ],
    );
  }

  // 🚀 PERBAIKAN: Tangani Infinite Width & Image 404
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
          // ClipRRect + Image.network lebih aman dari CircleAvatar untuk handle 404
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imgUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 56,
                height: 56,
                color: AppColors.surfaceContainerLow,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Expanded sangat penting agar teks tidak mendorong keluar layar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(rating,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text('• $distance',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Batasi ukuran tombol agar tidak "BoxConstraints infinite width"
          SizedBox(
            height: 36,
            width: 90,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/rental-detail'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99)),
                elevation: 0,
              ),
              child: const Text('Katalog',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
