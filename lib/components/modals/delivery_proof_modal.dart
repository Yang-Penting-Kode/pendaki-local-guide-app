import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/core/constants/app_colors.dart';

class DeliveryProofModal extends StatelessWidget {
  final String imageUrl;
  final String title;

  const DeliveryProofModal({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  static void show(BuildContext context,
      {required String imageUrl, required String title}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          DeliveryProofModal(imageUrl: imageUrl, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar Atas
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Header Title
          const Text(
            'Bukti Pengantaran',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: -0.5),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF3E4942), fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Foto Bukti Dokumentasi Lapangan (Premium Border Radius)
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: const Color(0xFFBDC9C0).withOpacity(0.5)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Informasi Tambahan Serah Terima
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.assignment_turned_in_outlined,
                    color: AppColors.primary, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Diterima oleh Ybs. Peralatan telah diverifikasi lengkap dan sesuai standar keamanan.',
                    style: TextStyle(
                        fontSize: 13, color: Color(0xFF3E4942), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Tombol Tutup Modal (Pill Button Style)
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              side: const BorderSide(color: Color(0xFFBDC9C0), width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99)),
            ),
            child: const Text(
              'Tutup Dokumentasi',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1B1B1B)),
            ),
          ),
        ],
      ),
    );
  }
}
