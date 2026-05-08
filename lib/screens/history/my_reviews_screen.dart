import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_image.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);

    return Scaffold(
      backgroundColor: AppColors.surface,
      // 🚀 Gunakan extend agar konten bisa berada di bawah AppBar transparan
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0.5,
        centerTitle: false,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ulasan Saya',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: -0.5),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        // 🚀 Padding top 110 agar konten tidak tertutup AppBar
        padding: const EdgeInsets.fromLTRB(16, 110, 16, 40),
        child: Column(
          children: [
            _buildStatsSection(primaryColor),
            const SizedBox(height: 24),
            _buildReviewCard(
              context,
              title: 'Tenda Eiger 4P',
              date: '16 Ags 2024',
              content:
                  'Tenda sangat kokoh saat badai di Merbabu. Bersih dan wangi saat diterima.',
              rating: 5,
              imageUrl:
                  'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
              primary: primaryColor,
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              context,
              title: 'Sepatu Hiking Salomon',
              date: '10 Jul 2024',
              content:
                  'Nyaman dipakai, grip masih sangat bagus. Pengiriman tepat waktu.',
              rating: 4,
              imageUrl:
                  'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400',
              primary: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(Color primary) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Ulasan',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              Text('24',
                  style: TextStyle(
                      color: primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  SizedBox(width: 4),
                  Text('4.9',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('Rata-rata Rating',
                  style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    BuildContext context, {
    required String title,
    required String date,
    required String content,
    required int rating,
    required String imageUrl,
    required Color primary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomNetworkImage(
                    imageUrl: imageUrl, width: 80, height: 80),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(date,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(content,
                        style: const TextStyle(
                            color: Color(0xFF3E4942), fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Text('Hapus',
                      style: TextStyle(color: Colors.grey))),
              const SizedBox(width: 12),
              // 🚀 FIX: Bungkus dengan Flexible atau gunakan tombol tanpa infinity width
              Flexible(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/review'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary.withOpacity(0.1),
                    foregroundColor: primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                  ),
                  child: const Text('Edit Ulasan',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
