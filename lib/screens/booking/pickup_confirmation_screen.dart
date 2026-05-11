import 'package:flutter/material.dart';
import '../../widgets/custom_image.dart'; // 🚀 Import widget custom agar anti-lemot

class PickupConfirmationScreen extends StatelessWidget {
  const PickupConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Konfirmasi Pengambilan',
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
        child: Column(
          children: [
            _buildPickupCodeCard(primaryColor, onSurfaceVariant),
            const SizedBox(height: 24),
            _buildItemListHeader(primaryColor),
            const SizedBox(height: 12),
            _buildItemsList(primaryColor, onSurfaceVariant),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('LOKASI PENGAMBILAN',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                      letterSpacing: 1.5)),
            ),
            const SizedBox(height: 12),
            _buildLocationBento(primaryColor, onSurfaceVariant),
            const SizedBox(height: 24),
            _buildSafetyInfo(primaryColor, onSurfaceVariant),
          ],
        ),
      ),
      bottomNavigationBar: _buildStickyFooter(context, primaryContainer),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildPickupCodeCard(Color primary, Color variant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          const Text('KODE PENGAMBILAN',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1)),
          const SizedBox(height: 8),
          Text('GDN-8829',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: primary,
                  letterSpacing: -1)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade100, width: 2)),
            // 🚀 PERBAIKAN: Gunakan CustomNetworkImage untuk QR Code
            child: const CustomNetworkImage(
              imageUrl:
                  'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=GDN-8829',
              width: 160,
              height: 160,
              fit: BoxFit.contain, // Agar QR tidak terdistorsi
            ),
          ),
          const SizedBox(height: 20),
          Text('Tunjukkan kode ini kepada Mitra untuk diverifikasi',
              textAlign: TextAlign.center,
              style: TextStyle(color: variant, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildItemListHeader(Color primary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('RINCIAN ALAT',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.grey,
                letterSpacing: 1.5)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(99)),
          child: Text('2 ITEM',
              style: TextStyle(
                  color: primary, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildItemsList(Color primary, Color variant) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          _buildItemRow(
              'Tenda Eiger 4P',
              'Kapasitas 4 Orang • Waterproof',
              '1x',
              'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4',
              primary),
          const Divider(height: 1),
          _buildItemRow(
              'Tas Carrier 60L',
              'Ergonomic Backsystem',
              '1x',
              'https://images.unsplash.com/photo-1551632811-561732d1e306',
              primary),
        ],
      ),
    );
  }

  Widget _buildItemRow(
      String title, String sub, String qty, String img, Color primary) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // 🚀 PERBAIKAN: Gunakan CustomNetworkImage untuk thumbnail alat
              child: CustomNetworkImage(
                  imageUrl: img, width: 56, height: 56, fit: BoxFit.cover)),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(sub,
                    style: const TextStyle(color: Colors.grey, fontSize: 11))
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('JUMLAH',
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            Text(qty,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: primary, fontSize: 16))
          ]),
        ],
      ),
    );
  }

  Widget _buildLocationBento(Color primary, Color variant) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: Color(0xFFC5ECD4), shape: BoxShape.circle),
                      child: const Icon(Icons.storefront,
                          color: Color(0xFF496C59), size: 20)),
                  const SizedBox(width: 12),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Toko Merdeka Outdoor',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(children: [
                          Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: primary, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text('Siap Diambil',
                              style: TextStyle(
                                  color: primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold))
                        ])
                      ]),
                ],
              ),
              const Icon(Icons.directions, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(12)),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                        'Jl. Merdeka No. 45, Kota Bandung. Dekat Alun-alun Kota.',
                        style: TextStyle(color: variant, fontSize: 12)))
              ]))
        ],
      ),
    );
  }

  Widget _buildSafetyInfo(Color primary, Color variant) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user, color: primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Safety & Quality Check',
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                    'Pastikan Anda telah memeriksa kelengkapan dan kondisi alat sebelum meninggalkan lokasi.',
                    style: TextStyle(color: variant, fontSize: 12))
              ])),
        ],
      ),
    );
  }

  Widget _buildStickyFooter(BuildContext context, Color primaryContainer) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/return-equipment'),
          icon: const Icon(Icons.task_alt, size: 20),
          label: const Text('Selesai Mengambil Alat',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryContainer,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
            elevation: 8,
          ),
        ),
      ),
    );
  }
}
