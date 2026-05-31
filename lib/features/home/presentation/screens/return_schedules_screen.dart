import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/core/local_storage/storage_services.dart';

class ReturnSchedulesScreen extends StatefulWidget {
  const ReturnSchedulesScreen({super.key});

  @override
  State<ReturnSchedulesScreen> createState() => _ReturnSchedulesScreenState();
}

class _ReturnSchedulesScreenState extends State<ReturnSchedulesScreen> {
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
      // Hanya tampilkan yang masih aktif/sedang disewa
      _rentals = parsed
          .where((r) => r['status'] == 'Sedang Disewa')
          .toList();
    });
  }

  /// Cek apakah rentang berakhir <= 1 hari dari sekarang (urgent)
  bool _isUrgent(String? rentalEndIso) {
    if (rentalEndIso == null) return false;
    try {
      final endDate = DateTime.parse(rentalEndIso);
      final diff = endDate.difference(DateTime.now());
      return diff.inDays <= 1;
    } catch (_) {
      return false;
    }
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

  /// Format date untuk section title "Hari ini / dd Mmm yyyy"
  String _buildSectionLabel(String? rentalEndIso) {
    if (rentalEndIso == null) return 'Jadwal Pengembalian';
    try {
      final endDate = DateTime.parse(rentalEndIso);
      final now = DateTime.now();
      final todayDate = DateTime(now.year, now.month, now.day);
      final endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);
      final diff = endDateOnly.difference(todayDate).inDays;
      if (diff == 0) return 'Hari Ini, ${_formatDate(rentalEndIso)}';
      if (diff == 1) return 'Besok, ${_formatDate(rentalEndIso)}';
      return _formatDate(rentalEndIso);
    } catch (_) {
      return 'Jadwal Pengembalian';
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF007A52);
    const Color backgroundColor = Color(0xFFF8FAF9);
    const Color textOnSurface = Color(0xFF191C1C);
    const Color textVariant = Color(0xFF6E7A72);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textOnSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jadwal Pengembalian',
          style: TextStyle(
            color: textOnSurface,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: _rentals.isEmpty
          ? _buildEmptyState(primaryColor)
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: List.generate(_rentals.length, (index) {
                final rental = _rentals[index];
                final itemName =
                    rental['itemName'] as String? ?? 'Alat Pendakian';
                final imageUrl = rental['imageUrl'] as String? ??
                    'https://picsum.photos/seed/rental/200/200';
                final rentalEnd = rental['rentalEnd'] as String?;
                final urgent = _isUrgent(rentalEnd);
                final status =
                    urgent ? 'Segera Dikembalikan' : 'Menunggu Pengambilan';
                final sectionLabel = _buildSectionLabel(rentalEnd);
                final timeLabel =
                    urgent ? 'Sebelum akhir hari ini' : 'Tanggal ${_formatDate(rentalEnd)}';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0 || _buildSectionLabel((_rentals[index - 1])['rentalEnd'] as String?) != sectionLabel) ...[
                      if (index > 0) const SizedBox(height: 24),
                      _buildSectionTitle(sectionLabel, textVariant),
                      const SizedBox(height: 16),
                    ],
                    _buildScheduleCard(
                      title: itemName,
                      time: timeLabel,
                      status: status,
                      imageUrl: imageUrl,
                      isUrgent: urgent,
                      hasAccent: true,
                      primaryColor: primaryColor,
                    ),
                  ],
                );
              }),
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
                Icons.calendar_month_outlined,
                size: 64,
                color: primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Belum ada jadwal\npengembalian',
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
              'Kamu belum menyewa peralatan apapun saat ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                color: Color(0xFF6E7A72),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS (UI Premium dipertahankan) ---

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required String time,
    required String status,
    required String imageUrl,
    required bool isUrgent,
    required bool hasAccent,
    required Color primaryColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // Glass-card effect
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left Status Accent Bar
          if (hasAccent)
            Positioned(
              left: 0,
              top: 12,
              bottom: 12,
              child: Opacity(
                opacity: isUrgent ? 1.0 : 0.4, // Pudar jika tidak urgent
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Typography & Badge
                Expanded(
                  child: Column(
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
                          const Icon(Icons.schedule,
                              size: 16, color: Color(0xFF6E7A72)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              time,
                              style: const TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12,
                                color: Color(0xFF6E7A72),
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Status Badge — warna berbeda berdasarkan urgent
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isUrgent
                              ? const Color(0xFFE6F2ED)
                              : const Color(0xFFF2F4F3),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isUrgent
                                ? primaryColor
                                : const Color(0xFF3E4942),
                          ),
                        ),
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
}
