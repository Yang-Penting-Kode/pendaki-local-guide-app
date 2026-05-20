import 'package:flutter/material.dart';
import 'package:pendaki_local_guide_app/models/tracking_model.dart';
import 'package:pendaki_local_guide_app/core/constants/app_colors.dart';
import 'package:pendaki_local_guide_app/components/modals/delivery_proof_modal.dart';
// 🚀 REFAKTOR: Impor widget kustom global agar kode ringkas & sat-set
import 'package:pendaki_local_guide_app/widgets/custom_image.dart';
import 'package:pendaki_local_guide_app/widgets/primary_button.dart';

class TrackingOrderScreen extends StatefulWidget {
  const TrackingOrderScreen({super.key});

  @override
  State<TrackingOrderScreen> createState() => _TrackingOrderScreenState();
}

class _TrackingOrderScreenState extends State<TrackingOrderScreen> {
  // Mockup daftar linimasa status pelacakan pengiriman barang
  final List<TrackingStageModel> _stages = [
    TrackingStageModel(
      title: 'Pesanan Diterima',
      timeAndDesc: '10:30 WIB - Sistem telah memverifikasi pesanan Anda.',
      status: TrackingStatus.completed,
    ),
    TrackingStageModel(
      title: 'Alat Sedang Disiapkan',
      timeAndDesc: '11:15 WIB - Tim logistik mengemas perlengkapan ekspedisi.',
      status: TrackingStatus.completed,
      hasProof: true,
      proofImageUrl:
          'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400',
    ),
    TrackingStageModel(
      title: 'Dalam Pengantaran',
      timeAndDesc: '13:45 WIB - Kurir menuju lokasi pengiriman Anda.',
      status: TrackingStatus.current,
    ),
    TrackingStageModel(
      title: 'Tiba di Lokasi',
      timeAndDesc: 'Estimasi kedatangan: 14:30 WIB.',
      status: TrackingStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            // Konten Scrollable Linimasa Pelacakan
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildScreenHeader(),
                    const SizedBox(height: 40),
                    _buildVerticalTimeline(),
                  ],
                ),
              ),
            ),

            // Kartu Informasi Profil Kurir (Fixed Sticky Bottom)
            _buildStickyCourierCard(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF9F9F9),
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Pelacakan Pesanan',
        style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 2.0),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline_rounded, color: Colors.black54),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildScreenHeader() {
    return const Center(
      child: Column(
        children: [
          Text(
            'Pesanan',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: -0.5),
          ),
          SizedBox(height: 6),
          Text(
            'ID: #TRX-89247-ALP',
            style: TextStyle(
                color: Color(0xFF3E4942),
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalTimeline() {
    return Stack(
      children: [
        Positioned(
          left: 10,
          top: 12,
          bottom: 32,
          child: Container(
            width: 1.5,
            color: const Color(0xFFE2E2E2),
          ),
        ),
        Positioned(
          left: 10,
          top: 12,
          height: 140,
          child: Container(
            width: 1.5,
            color: AppColors.primary,
          ),
        ),
        Column(
          children: List.generate(_stages.length, (index) {
            final stage = _stages[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimelineNode(stage.status),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stage.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: stage.status == TrackingStatus.pending
                                ? FontWeight.w500
                                : FontWeight.bold,
                            color: stage.status == TrackingStatus.current
                                ? AppColors.primary
                                : (stage.status == TrackingStatus.pending
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stage.timeAndDesc,
                          style: TextStyle(
                              fontSize: 13,
                              color: const Color(0xFF3E4942).withOpacity(
                                  stage.status == TrackingStatus.pending
                                      ? 0.6
                                      : 1.0),
                              height: 1.4),
                        ),
                        if (stage.hasProof && stage.proofImageUrl != null) ...[
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => DeliveryProofModal.show(
                              context,
                              imageUrl: stage.proofImageUrl!,
                              title: stage.title,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.image_outlined,
                                      color: AppColors.primary, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Lihat Bukti Pengantaran',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTimelineNode(TrackingStatus status) {
    if (status == TrackingStatus.completed) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: const Center(
            child: Icon(Icons.check, color: Colors.white, size: 12)),
      );
    } else if (status == TrackingStatus.current) {
      return Container(
        width: 22,
        height: 22,
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Center(
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
          ),
        ),
      );
    } else {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
            color: Color(0xFFE2E2E2), shape: BoxShape.circle),
      );
    }
  }

  Widget _buildStickyCourierCard() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, -8))
          ],
          // 🚀 FIX CRASH 291: Menghapus 'border: Border(top: ...)' untuk menghindari konflik gambar borderRadius uniform
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // 🚀 REFAKTOR IMAGE: Menggunakan CustomNetworkImage anti-crash 404 bawaan Abang
                SizedBox(
                  width: 56,
                  height: 56,
                  child: ClipOval(
                    child: CustomNetworkImage(
                      imageUrl:
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Budi Santoso',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('Kurir Marketplace',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 6),
                          const Icon(Icons.star_rounded,
                              color: AppColors.primary, size: 14),
                          const SizedBox(width: 2),
                          const Text('4.9',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
                _smallCourierActionBtn(Icons.chat_bubble_outline_rounded),
                const SizedBox(width: 10),
                _smallCourierActionBtn(Icons.phone_in_talk_outlined),
              ],
            ),
            const SizedBox(height: 20),

            // 🚀 REFAKTOR BUTTON: Memakai PrimaryButton kustom Abang agar baris kodingan ramping & rapi
            PrimaryButton(
              text: 'Lihat Koordinat Tujuan',
              onTap: () {
                // Jalankan logika maps dev nanti disini
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallCourierActionBtn(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F3F3),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: () {},
        customBorder: const CircleBorder(),
        child: Icon(icon, size: 18, color: const Color(0xFF3E4942)),
      ),
    );
  }
}
