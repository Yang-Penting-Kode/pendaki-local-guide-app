import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/core/local_storage/storage_services.dart';

// START REPLACE
class ActiveRentalsScreen extends StatefulWidget {
  const ActiveRentalsScreen({super.key});

  @override
  State<ActiveRentalsScreen> createState() => _ActiveRentalsScreenState();
}

class _ActiveRentalsScreenState extends State<ActiveRentalsScreen> {
  List<Map<String, dynamic>> _rentals = [];

  @override
  void initState() {
    super.initState();
    _loadRentals();
  }

  void _loadRentals() {
    final rawList = StorageService.getActiveRentals();
    final parsed = rawList.map((jsonStr) {
      try {
        return jsonDecode(jsonStr) as Map<String, dynamic>;
      } catch (_) {
        return <String, dynamic>{};
      }
    }).where((m) => m.isNotEmpty).toList();

    setState(() {
      _rentals = parsed;
    });
  }

  /// Format DateTime ke "dd Mmm yyyy" — misal: "12 Okt 2026"
  String _formatDate(String? isoString) {
    if (isoString == null) return '-';
    try {
      final dt = DateTime.parse(isoString);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return '-';
    }
  }

  String _formatDateRange(String? start, String? end) {
    return '${_formatDate(start)} - ${_formatDate(end)}';
  }
// END REPLACE

  @override
  Widget build(BuildContext context) {
    // Definisi warna berdasarkan Tailwind config dari Stitch
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color backgroundColor = Color(0xFFF8FAF9);
    const Color surfaceContainerLow = Color(0xFFF2F4F3);
    const Color onBackground = Color(0xFF191C1C);
    const Color onSurfaceVariant = Color(0xFF3E4942);
    const Color outlineVariant = Color(0xFFBDC9C0);

    final firstId = _rentals.isNotEmpty
        ? (_rentals.first['id'] as String? ?? '#TRX-00000')
        : '#TRX-00000';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rented Equipment',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: _rentals.isEmpty
          ? _buildEmptyState(primaryColor)
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                // HEADER: ID Transaksi (dinamis dari data pertama)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: outlineVariant.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ID TRANSAKSI',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: onSurfaceVariant,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${firstId.replaceAll('#', '')}',
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: onBackground,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F2ED),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                              color: primaryContainer.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF007A52),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Aktif',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF007A52),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // LIST DINAMIS: Iterasi dari StorageService
                ...List.generate(_rentals.length, (index) {
                  final rental = _rentals[index];
                  final itemName = rental['itemName'] as String? ?? 'Alat Pendakian';
                  final imageUrl = rental['imageUrl'] as String? ??
                      'https://picsum.photos/seed/rental/200/200';
                  final rentalStart = rental['rentalStart'] as String?;
                  final rentalEnd = rental['rentalEnd'] as String?;
                  final status = rental['status'] as String? ?? 'Sedang Disewa';
                  final dateRange = _formatDateRange(rentalStart, rentalEnd);

                  return _buildRentalCard(
                    title: itemName,
                    dateRange: dateRange,
                    status: status,
                    imageUrl: imageUrl,
                    primaryContainer: primaryContainer,
                  );
                }),
              ],
            ),
    );
  }

  // --- EMPTY STATE ---
  Widget _buildEmptyState(Color primaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Belum ada alat yang\nsedang disewa',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF191C1C),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ayo mulai petualanganmu! Cari dan sewa peralatan mendaki terbaik dari mitra kami.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                color: Color(0xFF6E7A72),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/catalog'),
              icon: const Icon(Icons.search, size: 18),
              label: const Text(
                'Jelajahi Katalog',
                style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER (UI Premium dipertahankan) ---

  Widget _buildRentalCard({
    required String title,
    required String dateRange,
    required String status,
    required String imageUrl,
    required Color primaryContainer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBDC9C0).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007A52).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Accent Bar (Garis Hijau Kiri)
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),

            // Main Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail Image
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F3),
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                          onError: (_, __) {},
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Typography & Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF191C1C),
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 14, color: Color(0xFF3E4942)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      dateRange,
                                      style: const TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF3E4942),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6E9E8),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: const Color(0xFFBDC9C0)
                                      .withOpacity(0.5)),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3E4942),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
