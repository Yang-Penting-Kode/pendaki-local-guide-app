// =============================================================================
// 🧾 CHECKOUT SCREEN — Detail Sewa Alat (RIVERPOD INJECTED)
// Lokasi: lib/features/booking/presentation/screens/checkout_screen.dart
//
// Migrasi: screens/booking/checkout_screen.dart → features/booking/...
// Perubahan: StatefulWidget → ConsumerStatefulWidget
// Injeksi: cartProvider (summary item), cartTotalProvider (Decimal)
// UI: Desain asli DIPERTAHANKAN — FlutterMap, DatePicker, Notes TextField.
// ⚠️ WAJIB: userAgentPackageName di TileLayer agar tidak 403 Forbidden.
// =============================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  // Ephemeral state — tetap local, bukan bagian dari business logic
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 1)); // 🚀
  int get durationDays => _selectedEndDate.difference(_selectedDate).inDays + 1; // 🚀

  File? _simaksiFile; // 🚀 Simaksi Upload State
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // 🚀 Logic untuk DateRangePicker (Sewa & Kembali)
  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      initialDateRange: DateTimeRange(start: _selectedDate, end: _selectedEndDate),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF005F3F)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked.start;
        _selectedEndDate = picked.end;
      });
    }
  }

  // 🚀 Logic untuk unggah Simaksi
  Future<void> _pickSimaksi() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _simaksiFile = File(pickedFile.path));
    }
  }

  // 🚀 Logic modal info ongkir
  void _showOngkirInfoModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informasi Ongkos Kirim', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Ongkir dihitung berdasarkan jarak dari mitra ke basecamp dan jenis armada (kuantitas unit alat).'),
            const SizedBox(height: 12),
            const Text('• 1 - 4 Unit: Motor (Rp 20.000)'),
            const Text('• Lebih dari 4 Unit: Mobil (Rp 50.000)'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005F3F), foregroundColor: Colors.white),
                child: const Text('Mengerti'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005F3F);
    const Color primaryContainer = Color(0xFF007A52);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    // 🔌 Injeksi: Total sewa dari cartProvider (sudah include markup Rp 1.000/item)
    final cartTotal = ref.watch(cartTotalProvider);
    final cartItems = ref.watch(cartProvider);
    final totalQty = ref.watch(cartTotalQtyProvider); // 🚀 Injeksi Quantity Provider

    // Hitung grand total
    final adminFee = Decimal.parse('5000');
    final deliveryCost = totalQty > 4 ? Decimal.parse('50000') : Decimal.parse('20000'); // 🚀 Logic Ongkir
    final rentalCost = cartTotal * Decimal.fromInt(durationDays); // 🚀 Injeksi kalkulasi durasi
    final grandTotal = rentalCost + adminFee + deliveryCost; // 🚀 Update Grand Total dengan rentalCost

    // 🚀 Dinamisasi Basecamp (Mock sebelum Integrasi penuh)
    final String selectedBasecamp = 'Gunung Gede - Jalur Cibodas';

    // Ambil item pertama untuk ditampilkan di Product Summary Card
    final firstItem = cartItems.isNotEmpty ? cartItems.first : null;

    return Scaffold(
      backgroundColor: Colors.white,
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
            // 2. Product Summary Card — 🔌 Injeksi: item pertama dari cartProvider
            // 2. Daftar Alat Disewa — 🔌 Injeksi: List item dari cartProvider
            _buildSection(
              title: 'Daftar Alat Disewa',
              child: cartItems.isEmpty
                  ? const Center(
                      child: Text('Keranjang kosong.',
                          style: TextStyle(color: Colors.grey)))
                  : Column(
                      children: cartItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://picsum.photos/seed/wrrt6e/600/400',
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(Icons.broken_image,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.quantity} Unit x Rp ${item.unitPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        color: onSurfaceVariant,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${item.subtotal.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
            ),

            // 3. Rental Form Section — Dipertahankan (DatePicker, Duration, Qty)
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
                            onTap: _pickDateRange,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFE2E2E2).withOpacity(0.5),
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
                          'Tgl Kembali',
                          child: InkWell(
                            onTap: _pickDateRange,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFE2E2E2).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                  '${_selectedEndDate.day}/${_selectedEndDate.month}/${_selectedEndDate.year}'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFieldLabel(
                          'Durasi Sewa',
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E2E2).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$durationDays Hari',
                                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                                const Icon(Icons.lock, color: Colors.grey, size: 16)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFieldLabel(
                          'Jumlah Unit',
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E2E2).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$totalQty Unit', // 🚀 Kuantitas disinkron & dikunci
                                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                                const Icon(Icons.lock, color: Colors.grey, size: 16)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 4. Document Upload Section — Dipertahankan
            _buildSection(
              title: 'Dokumen Pendukung',
              child: GestureDetector(
                onTap: _pickSimaksi, // 🚀 Aksi Upload
                child: Container(
                  width: double.infinity,
                  padding: _simaksiFile != null ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: _simaksiFile != null ? Colors.transparent : Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _simaksiFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_simaksiFile!, height: 180, width: double.infinity, fit: BoxFit.cover),
                        )
                      : const Column(
                          children: [
                            Icon(Icons.cloud_upload,
                                color: primaryContainer, size: 48),
                            SizedBox(height: 12),
                            Text('Unggah Tiket Pendakian (Simaksi)',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            Text('Format JPG, PNG, atau PDF (Maks 5MB)',
                                style: TextStyle(
                                    color: onSurfaceVariant, fontSize: 12)),
                          ],
                        ),
                ),
              ),
            ),

            // 5. Map — ⚠️ WAJIB userAgentPackageName agar tidak 403 Forbidden
            // 5. Map & Transport
            _buildSection(
              title: null, // Custom title logic below
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Lokasi Pengiriman & Basecamp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.info_outline, color: primaryColor),
                        onPressed: _showOngkirInfoModal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.localguide.app',
                          ),
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
                              child: Icon(Icons.location_on, color: Colors.red, size: 36),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Peralatan akan dikirimkan ke $selectedBasecamp.',
                    style: const TextStyle(fontSize: 12, color: onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  // 🚀 Injeksi Card Transportasi
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryContainer.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryContainer.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(totalQty > 4 ? Icons.directions_car : Icons.motorcycle, color: primaryContainer),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(totalQty > 4 ? 'Armada Mobil' : 'Armada Motor', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Estimasi biaya pengantaran ke $selectedBasecamp', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Text('Rp ${deliveryCost.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: primaryContainer)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 6. Notes — Dipertahankan (TextField)
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

            // 7. Cost Summary — 🔌 Injeksi: Total dari cartTotalProvider
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFC5ECD4).withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // 🔌 Injeksi: Harga Sewa berdasar durasi
                  _PriceDetailRow(
                      label: 'Harga Sewa ($durationDays Hari)',
                      value: 'Rp ${rentalCost.toStringAsFixed(0)}'),
                  const SizedBox(height: 12),
                  // Biaya Admin flat Rp 5.000
                  const _PriceDetailRow(
                      label: 'Biaya Admin', value: 'Rp 5.000'),
                  const SizedBox(height: 12),
                  // 🚀 Injeksi Delivery Cost
                  _PriceDetailRow(
                      label: 'Biaya Pengantaran', value: 'Rp ${deliveryCost.toStringAsFixed(0)}'),
                  const Divider(height: 32, color: primaryColor),
                  // 🔌 Injeksi: Grand Total = cartTotal + adminFee + deliveryCost
                  _PriceDetailRow(
                      label: 'Total Biaya',
                      value: 'Rp ${grandTotal.toStringAsFixed(0)}',
                      isBold: true),
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
          onPressed: () {
            // 🚀 Validasi Simaksi sebelum lanjut
            if (_simaksiFile == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tolong unggah tiket pendakian (Simaksi) terlebih dahulu.'), backgroundColor: Colors.red));
              return;
            }
            // 🚀 Oper Argument
            Navigator.pushNamed(context, '/order-summary', arguments: {
              'simaksiPath': _simaksiFile!.path,
              'deliveryCost': deliveryCost,
              'durationDays': durationDays,
              'rentalStart': _selectedDate,
              'rentalEnd': _selectedEndDate,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
            elevation: 0,
          ),
          child: const Text('Lanjut ke Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  // --- UI HELPERS (Desain asli dipertahankan) ---

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
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
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
}

// Private widget — dipertahankan dari desain asli
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
