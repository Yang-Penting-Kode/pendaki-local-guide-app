import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart'; // 🚀 Gunakan warna global terbaru
import 'date_picker_modal.dart'; // 🚀 Import modal tujuan

class OrderTypeSheet extends StatelessWidget {
  final BuildContext? parentContext;

  const OrderTypeSheet({super.key, this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest, // ⚪ Putih bersih premium
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Drag Handle
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Header Section
          const Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Jenis Pemesanan',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Pilihan Anda akan menentukan jangkauan radius mitra rental di sekitar lokasi.',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 13,
                      height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Card 1: Pesan Sekarang (Langsung ke Partners)
          _buildOptionCard(
            context,
            icon: Icons.bolt_rounded,
            title: 'Pesan Sekarang',
            subtitle:
                'Lihat alat yang tersedia untuk langsung diambil atau diantar hari ini.',
            iconBg: AppColors.primaryContainer.withOpacity(0.2),
            iconColor: AppColors.primary,
            onTap: () {
              Navigator.pop(context);
              final contextToUse = parentContext ?? context;
              final parentArgs = parentContext != null 
                  ? ModalRoute.of(parentContext!)?.settings.arguments as Map<String, dynamic>? 
                  : null;
              
              Navigator.pushNamed(contextToUse, '/basecamp-partners', arguments: {
                'mountain': parentArgs?['mountain'],
                'startDate': DateTime.now(),
                'endDate': DateTime.now().add(const Duration(days: 1)), // Default 1 hari
              });
            },
          ),
          const SizedBox(height: 16),

          // 4. Card 2: Booking Dulu (Buka Modal Tanggal)
          _buildOptionCard(
            context,
            icon: Icons.calendar_month_rounded,
            title: 'Booking Dulu',
            subtitle:
                'Pesan perlengkapan untuk tanggal pendakian di masa depan.',
            iconBg: AppColors.secondary.withOpacity(0.1),
            iconColor: AppColors.secondary,
            onTap: () async {
              // 🚀 STEP 1: Tutup modal saat ini[cite: 12]
              Navigator.pop(context);

              // 🚀 STEP 2: Buka modal Pilih Tanggal dengan parentContext untuk menghindari stale context[cite: 12]
              final contextToUse = parentContext ?? context;
              final selectedDates = await showModalBottomSheet(
                context: contextToUse,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const DatePickerModal(),
              );

              // START REPLACE
              if (selectedDates != null && selectedDates is Map) {
                final parentArgs = parentContext != null 
                    ? ModalRoute.of(parentContext!)?.settings.arguments as Map<String, dynamic>? 
                    : null;
                
                Navigator.pushNamed(
                  contextToUse, 
                  '/basecamp-partners', 
                  arguments: {
                    'mountain': parentArgs?['mountain'], // Data gunung eksisting
                    'startDate': selectedDates['startDate'],
                    'endDate': selectedDates['endDate'],
                  }
                );
              }
              // END REPLACE
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // --- REUSABLE OPTION CARD WIDGET ---
  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow, // Sesuai desain HTML[cite: 10]
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Manrope')),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          height: 1.3)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
