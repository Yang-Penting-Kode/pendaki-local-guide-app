// =============================================================================
// 📋 ORDER SUMMARY SCREEN — Ringkasan Pesanan (RIVERPOD INJECTED)
// Lokasi: lib/features/booking/presentation/screens/order_summary_screen.dart
//
// Migrasi: screens/booking/order_summary_screen.dart → features/booking/...
// Perubahan: StatefulWidget → ConsumerStatefulWidget
// Injeksi: cartProvider, cartTotalProvider, orderProvider.createOrder(), authProvider
//
// 🔥 CRITICAL POINT: createOrder() dipanggil di sini saat "Bayar Sekarang"
//   → orderId (UUID v7) dikembalikan → diteruskan ke /transaction-success
//
// ⚠️ WAJIB: userAgentPackageName di TileLayer (FlutterMap) agar tidak 403.
// ⚠️ WAJIB: if (!mounted) return; setelah setiap await.
// =============================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:decimal/decimal.dart';
import 'dart:convert';
import 'package:pendaki_local_guide_app/core/local_storage/storage_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/auth/providers/auth_provider.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/cart_provider.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/order_provider.dart';

class OrderSummaryScreen extends ConsumerStatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  ConsumerState<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends ConsumerState<OrderSummaryScreen> {
  // Pilihan metode pembayaran — ephemeral state tetap local
  String _selectedPayment = 'Belum Dipilih';
  bool _isProcessing = false; // Guard: cegah double-tap tombol

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

    // 🔌 Injeksi: Data dari providers
    final cartItems = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);

    // 🚀 Tangkap operan dari CheckoutScreen
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? simaksiPath = args?['simaksiPath'];
    final Decimal deliveryCost = args?['deliveryCost'] as Decimal? ?? Decimal.zero;
    final int durationDays = args?['durationDays'] as int? ?? 1; // 🚀
    final DateTime rentalStart = args?['rentalStart'] as DateTime? ?? DateTime.now(); // 🚀
    final DateTime rentalEnd = args?['rentalEnd'] as DateTime? ?? DateTime.now().add(const Duration(days: 1)); // 🚀

    final adminFee = Decimal.parse('5000');
    final rentalCost = cartTotal * Decimal.fromInt(durationDays); // 🚀 Rental calculation
    final taxAmount = rentalCost * Decimal.parse('0.11'); // 🚀 PPN 11%
    final paymentMethodFee = Decimal.parse('2500'); // 🚀 Biaya Pembayaran
    final grandTotal = rentalCost + adminFee + deliveryCost + taxAmount + paymentMethodFee; // 🚀 Injeksi Ongkir, Rental, Tax, Fee

    // Item pertama untuk display card

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
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32), // 🚀 HOTFIX: Padding disesuaikan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Daftar Alat Disewa — Diambil dari CheckoutScreen
            const _SectionTitle(title: 'DAFTAR ALAT DISEWA'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: cartItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://picsum.photos/seed/cesi6g/600/400',
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(width: 56, height: 56, color: Colors.grey.shade200, child: const Icon(Icons.broken_image, color: Colors.grey, size: 24)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text('${item.quantity} Unit x Rp ${item.unitPrice.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF3E4942), fontSize: 12)),
                          ],
                        ),
                      ),
                      Text('Rp ${(item.unitPrice * Decimal.fromInt(item.quantity) * Decimal.fromInt(durationDays)).toStringAsFixed(0)}', style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Preview Tiket (Dipertahankan)
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(simaksiPath != null ? simaksiPath.split('/').last : 'Belum Terlampir',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(simaksiPath != null ? 'Terunggah' : 'File Hilang',
                            style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        if (simaksiPath != null) {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: const EdgeInsets.all(16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(File(simaksiPath), fit: BoxFit.contain),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Lihat',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Penalty Info (Dipertahankan)
            _buildPenaltyInfo(primaryColor),
            const SizedBox(height: 24),

            // 4. Map — ⚠️ WAJIB userAgentPackageName
            const _SectionTitle(title: 'TITIK PENGANTARAN BASECAMP'),
            const SizedBox(height: 12),
            _buildLocationCard(primaryColor, onSurfaceVariant),
            const SizedBox(height: 24),

            // 5. Payment Picker (Dipertahankan)
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
                      child: const Icon(Icons.account_balance_wallet,
                          color: primaryColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pilih Metode Pembayaran',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey)),
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
            const _SectionTitle(title: 'RINCIAN BIAYA'),
            const SizedBox(height: 12),
            // 6. Price Breakdown — 🔌 Injeksi: Dari cartTotalProvider
            _buildPriceBreakdown(rentalCost, adminFee, deliveryCost, taxAmount, paymentMethodFee, grandTotal, primaryColor,
                onSurfaceVariant, durationDays),
          ],
        ),
      ),
      // 🔥 CRITICAL: Sticky footer dengan createOrder()
      bottomNavigationBar: _buildStickyFooter(primaryColor, grandTotal, deliveryCost, taxAmount, paymentMethodFee, rentalStart, rentalEnd),
    );
  }

  // --- WIDGET BUILDERS ---

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
          SizedBox(
            height: 150,
            width: double.infinity,
            child: FlutterMap(
              options: const MapOptions(
                  initialCenter: LatLng(-6.7725, 106.9489), initialZoom: 15),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  // ⚠️ WAJIB — Tanpa ini map akan 403 Forbidden
                  userAgentPackageName: 'com.localguide.app',
                ),
                const MarkerLayer(markers: [
                  Marker(
                      point: LatLng(-6.7725, 106.9489),
                      child: Icon(Icons.location_on,
                          color: Colors.red, size: 36)),
                ]),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFF3F3F3),
            child: Text(
                '"Peralatan akan diantar ke titik kumpul basecamp."',
                style: TextStyle(
                    color: variant,
                    fontSize: 12,
                    fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown(Decimal rentalCost, Decimal adminFee,
      Decimal deliveryCost, Decimal taxAmount, Decimal paymentMethodFee, Decimal grandTotal, Color primary, Color variant, int durationDays) {
    return Column(
      children: [
        // 🔌 Injeksi: Harga sewa dari cartTotalProvider
        _PriceRow(
            label: 'Harga Sewa ($durationDays Hari)',
            value: 'Rp ${rentalCost.toStringAsFixed(0)}'),
        const SizedBox(height: 8),
        // Biaya Admin flat Rp 5.000
        _PriceRow(
            label: 'Biaya Admin',
            value: 'Rp ${adminFee.toStringAsFixed(0)}'),
        const SizedBox(height: 8),
        // 🚀 Biaya Pengantaran
        _PriceRow(
            label: 'Biaya Pengantaran',
            value: 'Rp ${deliveryCost.toStringAsFixed(0)}'),
        const SizedBox(height: 8),
        // 🚀 PPN
        _PriceRow(
            label: 'PPN 11%',
            value: 'Rp ${taxAmount.toStringAsFixed(0)}'),
        const SizedBox(height: 8),
        // 🚀 Biaya Pembayaran
        _PriceRow(
            label: 'Biaya Penanganan',
            value: 'Rp ${paymentMethodFee.toStringAsFixed(0)}'),
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Tagihan',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            // 🔌 Injeksi: Grand total = cartTotal + adminFee
            Text('Rp ${grandTotal.toStringAsFixed(0)}',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: primary)),
          ],
        ),
      ],
    );
  }

  // 🔥 CRITICAL: Footer dengan createOrder() logic
  Widget _buildStickyFooter(Color primary, Decimal grandTotal, Decimal deliveryCost, Decimal taxAmount, Decimal paymentMethodFee, DateTime rentalStart, DateTime rentalEnd) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tampilkan grand total di atas tombol untuk konfirmasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Dibayarkan',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              Text('Rp ${grandTotal.toStringAsFixed(0)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primary)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              // Disabled jika: pembayaran belum dipilih ATAU sedang processing
              onPressed:
                  (_selectedPayment == 'Belum Dipilih' || _isProcessing)
                      ? null
                      : () async {
                          // Ambil user yang sedang login dari authProvider
                          final currentUser = ref.read(authProvider);

                          // Guard: Tidak mungkin masuk sini tanpa login,
                          // tapi tetap defensif
                          if (currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Sesi login habis. Silakan login ulang.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Set loading state — cegah double-tap
                          setState(() => _isProcessing = true);

                          // 🔥 INJEKSI: Panggil createOrder via orderProvider.notifier
                          final orderId = await ref
                              .read(orderProvider.notifier)
                              .createOrder(
                                currentUser: currentUser,
                                rentalStart: rentalStart, // 🚀 Dari date picker checkout
                                rentalEnd: rentalEnd, // 🚀 Dari date picker checkout
                                deliveryCost: deliveryCost, // 🚀 SOLVED THE ERROR
                                taxAmount: taxAmount,
                                paymentMethodFee: paymentMethodFee,
                                paymentMethod: _selectedPayment,
                              );

                          // START REPLACE
                          final cartItems = ref.read(cartProvider); // Fix for cartItems undefined
                          final mockRentalData = jsonEncode({
                            'id': orderId ?? 'ORD-${DateTime.now().millisecondsSinceEpoch}',
                            'date': DateTime.now().toIso8601String(),
                            'status': 'active_rental',
                            'itemName': cartItems.isNotEmpty ? cartItems.first.productName : 'Paket Tenda & Alat',
                            'imageUrl': 'https://picsum.photos/seed/rental${DateTime.now().millisecond}/200/200',
                            'rentalStart': rentalStart.toIso8601String(),
                            'rentalEnd': rentalEnd.toIso8601String(),
                          });
                          await StorageService.saveActiveRental(mockRentalData);
                          // END REPLACE

                          // ⚠️ WAJIB: Cek mounted setelah async gap
                          if (!mounted) return;

                          setState(() => _isProcessing = false);

                          if (orderId != null) {
                            // 🎯 Navigasi ke /transaction-success
                            // pushNamedAndRemoveUntil → bersihkan stack sampai /dashboard
                            // arguments: orderId → ditampilkan di success screen
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/transaction-success',
                              (route) =>
                                  route.settings.name == '/dashboard',
                              arguments: orderId,
                            );
                          } else {
                            // Order gagal dibuat (keranjang kosong?)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Gagal membuat pesanan. Pastikan keranjang tidak kosong.'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
              icon: _isProcessing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.lock, size: 18),
              label: Text(
                  _isProcessing ? 'Memproses...' : 'Bayar Sekarang',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007A52),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Private widgets — dipertahankan dari desain asli

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
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
