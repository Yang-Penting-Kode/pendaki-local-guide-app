import 'package:flutter/material.dart';

class ReturnConfirmationScreen extends StatelessWidget {
  const ReturnConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai desain HTML
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);
    const Color secondaryContainer = Color(0xFFC5ECD4);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Konfirmasi Pengembalian',
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Section 1: QR Code Card
            _buildReturnCodeCard(primaryColor, onSurfaceVariant),

            const SizedBox(height: 24),

            // 3. Section 2: Lokasi Pengembalian
            const _SectionTitle(title: 'LOKASI PENGEMBALIAN'),
            const SizedBox(height: 12),
            _buildLocationCard(secondaryContainer, primaryColor),

            const SizedBox(height: 24),

            // 4. Section 3: Rincian Alat
            const _SectionTitle(title: 'RINCIAN ALAT'),
            const SizedBox(height: 12),
            _buildItemsList(secondaryContainer, primaryColor, onSurfaceVariant),

            const SizedBox(height: 24),

            // 5. Section 4: Notice Box (Pengecekan Akhir)
            _buildNoticeBox(secondaryContainer, primaryColor),
          ],
        ),
      ),
      // 6. Footer Button (Sticky Bottom)
      bottomNavigationBar: _buildStickyFooter(context, primaryContainer),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildReturnCodeCard(Color primary, Color variant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          const Text('KODE PENGEMBALIAN',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text('RTN-8829',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: primary,
                  letterSpacing: -0.5)),
          const SizedBox(height: 24),
          // QR Code with decorative corners
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(20)),
                child: Image.network(
                  'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=RTN-8829',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 140,
                    height: 140,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              // Decorative Corners
              ..._buildQRDecoration(primary),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Tunjukkan kode ini kepada Mitra untuk verifikasi pengembalian alat.',
            textAlign: TextAlign.center,
            style: TextStyle(color: variant, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQRDecoration(Color primary) {
    return [
      Positioned(
          top: 8,
          left: 8,
          child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: primary, width: 2),
                      left: BorderSide(color: primary, width: 2))))),
      Positioned(
          top: 8,
          right: 8,
          child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: primary, width: 2),
                      right: BorderSide(color: primary, width: 2))))),
      Positioned(
          bottom: 8,
          left: 8,
          child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: primary, width: 2),
                      left: BorderSide(color: primary, width: 2))))),
      Positioned(
          bottom: 8,
          right: 8,
          child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: primary, width: 2),
                      right: BorderSide(color: primary, width: 2))))),
    ];
  }

  Widget _buildLocationCard(Color bg, Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(Icons.store, color: primary, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Toko Merdeka Outdoor',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Jl. Merdeka No. 45, Kota Bandung.',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(Color bg, Color primary, Color variant) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          _buildItemRow(
              'Tenda Eiger 4P',
              'Kondisi Baik',
              '1x',
              'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4',
              bg,
              primary),
          const Divider(height: 1),
          _buildItemRow(
              'Tas Carrier 60L',
              'Kondisi Baik',
              '1x',
              'https://images.unsplash.com/photo-1551632811-561732d1e306',
              bg,
              primary),
        ],
      ),
    );
  }

  Widget _buildItemRow(String title, String status, String qty, String img,
      Color bg, Color primary) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              img,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 48,
                height: 48,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(Icons.broken_image, size: 20, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Text(status,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: bg, borderRadius: BorderRadius.circular(99)),
            child: Text(qty,
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBox(Color bg, Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: bg.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bg)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user, color: primary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pengecekan Akhir',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text(
                    'Pastikan alat dikembalikan dalam kondisi bersih dan lengkap sesuai saat pengambilan.',
                    style: TextStyle(fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter(BuildContext context, Color primaryContainer) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: Colors.grey.shade100))),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/review'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryContainer,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
            elevation: 8,
          ),
          child: const Text('Selesai Mengembalikan Alat',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: Colors.grey));
}
