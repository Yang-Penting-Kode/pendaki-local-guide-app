import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart'; //
import '../../../../components/modals/order_type_sheet.dart'; //

class MountainDetailScreen extends StatelessWidget {
  final String title;
  final String location;
  final String imageUrl;

  const MountainDetailScreen({
    super.key,
    required this.title,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface, //
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. Hero Image Section
              SliverAppBar(
                expandedHeight: 450,
                pinned: true,
                backgroundColor: Colors.white.withOpacity(0.8),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.surfaceContainerLow,
                          child: const Center(
                            child: Icon(Icons.broken_image,
                                size: 48, color: Colors.grey),
                          ),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 24,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: const Text('JALUR UTAMA',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5)),
                            ),
                            const SizedBox(height: 8),
                            Text(title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Manrope')),
                            Text(location,
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Stats Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildStatCard('Estimasi', '12-14 Jam', Icons.timer),
                          _buildStatCard('Jarak', '18.4 km', Icons.straighten),
                          _buildStatCard(
                              'Ketinggian', '3.339 mdpl', Icons.height),
                          _buildStatCard(
                              'Kesulitan', 'Sulit', Icons.trending_up,
                              color: AppColors.secondary),
                        ],
                      ),

                      const SizedBox(height: 32),
                      const Text('Karakteristik Jalur Tretes',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Manrope')),
                      const SizedBox(height: 16),
                      const Text(
                        'Jalur Tretes merupakan rute tertua dan paling populer menuju puncak Arjuno. Dikenal dengan medan bebatuan yang tertata rapi namun memiliki kemiringan yang konstan.',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant, height: 1.6),
                      ),

                      // Info Card
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16)),
                        child: const Row(
                          children: [
                            Icon(Icons.water_drop, color: AppColors.primary),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Sumber Air Melimpah',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      'Tersedia air permanen di Pos 2 dan Pos 3.',
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      // 3. Rental Banner
                      _buildRentalBanner(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon,
      {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color ?? AppColors.primary, size: 20),
          const SizedBox(height: 8),
          Text(label.toUpperCase(),
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.0)),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color ?? AppColors.onSurface)),
        ],
      ),
    );
  }

  Widget _buildRentalBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
              'https://www.transparenttextures.com/patterns/carbon-fibre.png'),
          opacity: 0.1,
        ),
      ),
      child: Column(
        children: [
          const Text('Sewa Alat di Sekitar Basecamp',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Temukan persewaan terdekat dengan kualitas alat premium.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // 🚀 AKSI: Munculkan Modal Pilih Jenis Pemesanan dengan parentContext
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (modalContext) =>
                    OrderTypeSheet(parentContext: context),
              );
            },
            icon: const Icon(Icons.shopping_bag, size: 18),
            label: const Text('Cari Persewaan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
