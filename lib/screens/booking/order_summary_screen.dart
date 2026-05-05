import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  // 🚀 Logic: Pilihan metode pembayaran
  String _selectedPayment = 'Belum Dipilih';

  // Fungsi untuk menampilkan daftar metode pembayaran
  void _showPaymentPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Metode Pembayaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildPaymentItem('QRIS (BRImo)', Icons.qr_code_scanner),
            _buildPaymentItem('Transfer Bank BRI', Icons.account_balance),
            _buildPaymentItem(
                'E-Wallet (OVO/Dana)', Icons.account_balance_wallet),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF007A52)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () {
        setState(() => _selectedPayment = title);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ringkasan Pesanan',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Order Card Section
            _buildOrderCard(primaryColor, onSurfaceVariant),
            const SizedBox(height: 24),

            // 🚀 REVISI 1: Preview Tiket Pendakian (Sudah Terupload)
            const _SectionTitle(title: 'TIKET PENDAKIAN TERLAMPIR'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.description, color: primaryColor),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Simaksi_Gede_Adi.pdf',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('2.4 MB • Terunggah',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text('Lihat',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Penalty Terms
            _buildPenaltyInfo(primaryColor),
            const SizedBox(height: 24),

            // 🚀 REVISI 2: Fix Map 403 Error
            const _SectionTitle(title: 'TITIK PENGANTARAN BASECAMP'),
            const SizedBox(height: 12),
            _buildLocationCard(primaryColor, onSurfaceVariant),
            const SizedBox(height: 24),

            // 🚀 REVISI 3: Interaksi Pilih Metode Pembayaran
            const _SectionTitle(title: 'METODE PEMBAYARAN'),
            const SizedBox(height: 12),
            InkWell(
              onTap: _showPaymentPicker,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: _selectedPayment == 'Belum Dipilih'
                          ? Colors.grey.shade300
                          : primaryColor,
                      width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle),
                      child: Icon(Icons.account_balance_wallet,
                          color: primaryColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pilih Metode Pembayaran',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(_selectedPayment,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    const Icon(Icons.expand_more, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 3. Price Details
            _buildPriceBreakdown(primaryColor, onSurfaceVariant),
          ],
        ),
      ),
      bottomSheet: _buildStickyFooter(primaryColor),
    );
  }

  Widget _buildOrderCard(Color primary, Color variant) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tenda Eiger 4P',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('2 Hari: 14 - 16 Agustus',
                    style: TextStyle(color: variant, fontSize: 12)),
                const SizedBox(height: 8),
                Text('Rp 150.000',
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenaltyInfo(Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.2))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: primary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Denda keterlambatan berlaku jika waktu melebihi 3 jam dari waktu selesai pendakian.',
              style: TextStyle(
                  color: Color(0xFF4A4A4A), fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Color primary, Color variant) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            child: FlutterMap(
              options: const MapOptions(
                  initialCenter: LatLng(-6.7725, 106.9489), initialZoom: 15),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  // 🚀 FIX: Tambahkan userAgent agar tidak 403 Forbidden
                  userAgentPackageName: 'com.localguide.app',
                ),
                const MarkerLayer(markers: [
                  Marker(
                      point: LatLng(-6.7725, 106.9489),
                      child:
                          Icon(Icons.location_on, color: Colors.red, size: 36)),
                ]),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFF3F3F3),
            child: Text('"Peralatan akan diantar ke titik kumpul basecamp."',
                style: TextStyle(
                    color: variant, fontSize: 12, fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown(Color primary, Color variant) {
    return Column(
      children: [
        _PriceRow(label: 'Harga Sewa (2 Hari)', value: 'Rp 120.000'),
        const SizedBox(height: 8),
        _PriceRow(label: 'Biaya Layanan', value: 'Rp 10.000'),
        _PriceRow(label: 'Jaminan Kebersihan', value: 'Rp 20.000'),
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Tagihan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Rp 150.000',
                style: TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 20, color: primary)),
          ],
        ),
      ],
    );
  }

  Widget _buildStickyFooter(Color primary) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100))),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: _selectedPayment == 'Belum Dipilih'
              ? null
              : () => Navigator.pushNamed(context, '/transaction-success'),
          icon: const Icon(Icons.lock, size: 18),
          label: const Text('Bayar Sekarang',
              style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007A52),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  const _PriceRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
      );
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
