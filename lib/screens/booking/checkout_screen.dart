import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // 🚀 Logic & States: Menangani input formulir
  DateTime _selectedDate = DateTime.now();
  String _selectedDuration = '2 Hari';
  int _unitCount = 1;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _durations = [
    '1 Hari',
    '2 Hari',
    '3 Hari',
    '4 Hari',
    '5 Hari'
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color surfaceColor = Color(0xFFF9F9F9);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. TopAppBar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Sewa Alat',
          style: TextStyle(
            color: primaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
        child: Column(
          children: [
            // 2. Product Summary Card
            _buildSection(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://picsum.photos/seed/rf4glw/600/400',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 96,
                        height: 96,
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
                        const Text(
                          'Tenda Eiger 4P',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            children: [
                              TextSpan(text: 'Rp 50.000'),
                              TextSpan(
                                  text: '/hari',
                                  style: TextStyle(
                                      color: onSurfaceVariant,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: onSurfaceVariant),
                            SizedBox(width: 4),
                            Text('1.2 km dari lokasimu',
                                style: TextStyle(
                                    color: onSurfaceVariant, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 3. Rental Form Section
            _buildSection(
              title: 'Detail Penyewaan',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildFieldLabel(
                          'Tanggal Sewa',
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 60)),
                              );
                              if (picked != null)
                                setState(() => _selectedDate = picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2E2E2).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFieldLabel(
                          'Durasi Sewa',
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E2E2).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedDuration,
                                isExpanded: true,
                                items: _durations
                                    .map((d) => DropdownMenuItem(
                                        value: d, child: Text(d)))
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedDuration = val!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildFieldLabel(
                    'Jumlah Unit',
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E2E2).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildCounterBtn(
                              Icons.remove,
                              () => setState(
                                  () => _unitCount > 1 ? _unitCount-- : null)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('$_unitCount Unit',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ),
                          _buildCounterBtn(
                              Icons.add, () => setState(() => _unitCount++),
                              isPrimary: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 4. Document Upload Section
            _buildSection(
              title: 'Dokumen Pendukung',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload,
                        color: primaryContainer, size: 48),
                    const SizedBox(height: 12),
                    const Text('Unggah Tiket Pendakian (Simaksi)',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Format JPG, PNG, atau PDF (Maks 5MB)',
                        style:
                            TextStyle(color: onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
            ),

            // 5. Delivery Location (Map Integration)
            _buildSection(
              title: 'Lokasi Pengiriman & Basecamp',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 192,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFE5E7EB),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FlutterMap(
                        options: const MapOptions(
                          initialCenter: LatLng(-7.7000, 112.6333),
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                          CircleLayer(circles: [
                            CircleMarker(
                              point: const LatLng(-7.7000, 112.6333),
                              radius: 150,
                              useRadiusInMeter: true,
                              color: primaryColor.withOpacity(0.2),
                              borderColor: primaryColor,
                              borderStrokeWidth: 2,
                            ),
                          ]),
                          const MarkerLayer(markers: [
                            Marker(
                              point: LatLng(-7.7000, 112.6333),
                              child: Icon(Icons.location_on,
                                  color: Colors.red, size: 36),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Peralatan akan dikirimkan ke titik kumpul basecamp dalam radius layanan.',
                    style: TextStyle(fontSize: 12, color: onSurfaceVariant),
                  ),
                ],
              ),
            ),

            // 6. Notes Area
            _buildSection(
              title: 'Catatan untuk Mitra',
              child: TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Contoh: Tolong siapkan pasak ekstra...',
                  filled: true,
                  fillColor: const Color(0xFFE2E2E2).withOpacity(0.5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none),
                ),
              ),
            ),

            // 7. Cost Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFC5ECD4).withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const _PriceDetailRow(
                      label: 'Harga Sewa (2 Hari x 1 Unit)',
                      value: 'Rp 100.000'),
                  const SizedBox(height: 12),
                  const _PriceDetailRow(
                      label: 'Biaya Layanan', value: 'Rp 10.000'),
                  const Divider(height: 32, color: primaryColor),
                  const _PriceDetailRow(
                      label: 'Total Biaya', value: 'Rp 110.000', isBold: true),
                ],
              ),
            ),
          ],
        ),
      ),
      // 8. Sticky Footer Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/order-summary'),
          // onPressed: () {
          //   // Logika lanjut ke pembayaran (Misal: Pilih QRIS BRImo)
          //   _showPaymentMethodSelector();
          // },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
            elevation: 0,
          ),
          child: const Text('Lanjut ke Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildSection({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.grey,
                letterSpacing: 1)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildCounterBtn(IconData icon, VoidCallback onTap,
      {bool isPrimary = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFF007A52).withOpacity(0.1)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            color: isPrimary ? const Color(0xFF007A52) : Colors.grey, size: 20),
      ),
    );
  }

  void _showPaymentMethodSelector() {
    // Di sini nanti bisa mengarah ke pemilihan QRIS BRImo sesuai seleramu
  }
}

class _PriceDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _PriceDetailRow(
      {required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: TextStyle(
                fontSize: isBold ? 18 : 14,
                fontWeight: FontWeight.bold,
                color: isBold ? const Color(0xFF005F3F) : Colors.black)),
      ],
    );
  }
}
