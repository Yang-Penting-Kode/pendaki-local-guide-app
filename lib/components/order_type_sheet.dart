import 'package:flutter/material.dart';

class OrderTypeSheet extends StatelessWidget {
  const OrderTypeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C0C);
    const Color secondaryColor = Color(0xFF904D00);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar tinggi menyesuaikan konten
        children: [
          // Handle
          Container(
            width: 48,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),
          // Header
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Jenis Pemesanan',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Pilihan Anda akan menentukan jangkauan radius mitra rental di sekitar lokasi.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Card 1: Pesan Sekarang
          _buildOptionCard(
            context,
            icon: Icons.bolt,
            title: 'Pesan Sekarang',
            subtitle: 'Lihat alat yang tersedia untuk langsung diambil atau diantar hari ini.',
            iconBg: const Color(0xFF92FA83).withOpacity(0.3),
            iconColor: primaryColor,
            onTap: () {
              Navigator.pop(context); // Tutup sheet
              // Navigasi dengan radius sempit (misal: 2km)
              Navigator.pushNamed(context, '/basecamp-partners', arguments: 2000.0);
            },
          ),
          const SizedBox(height: 16),
          // Card 2: Booking Dulu
          _buildOptionCard(
            context,
            icon: Icons.calendar_month,
            title: 'Booking Dulu',
            subtitle: 'Pesan perlengkapan untuk tanggal pendakian di masa depan dengan pilihan mitra lebih luas.',
            iconBg: const Color(0xFFFFDCC3).withOpacity(0.4),
            iconColor: secondaryColor,
            onTap: () {
              Navigator.pop(context); // Tutup sheet
              // Navigasi dengan radius lebar (misal: 10km)
              Navigator.pushNamed(context, '/basecamp-partners', arguments: 10000.0);
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

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
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}