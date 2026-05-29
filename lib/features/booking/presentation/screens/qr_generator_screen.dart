import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/order_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/enums/app_enums.dart';

class QrGeneratorScreen extends ConsumerWidget {
  const QrGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tangkap argumen orderId dari route
    final String? orderId =
        ModalRoute.of(context)?.settings.arguments as String?;

    // Safety Guard: jika orderId null atau kosong
    if (orderId == null || orderId.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'QR Code Pesanan',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'Data ID Tidak Valid',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    // Payload Logic: mengunci ID menjadi JSON
    final String qrPayload = jsonEncode({
      'order_id': orderId,
      'source': 'mountain_kit_consumer',
    });

    final ordersAsync = ref.watch(orderProvider);

    return ordersAsync.when(
      data: (orders) {
        final order = orders.firstWhere((o) => o.id == orderId, orElse: () => throw Exception('Order not found'));
        final bool isValid = order.status == OrderStatus.activeRental;

        // UI Rendering
        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'QR Code Pesanan',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🚀 PERBAIKAN: Logika State Visual QR Code
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ColorFiltered(
                              colorFilter: isValid
                                  ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                                  : const ColorFilter.mode(Colors.white60, BlendMode.lighten),
                              child: Opacity(
                                opacity: isValid ? 1.0 : 0.3,
                                child: QrImageView(
                                  data: qrPayload,
                                  version: QrVersions.auto,
                                  size: 260.0,
                                ),
                              ),
                            ),
                            if (!isValid)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Validasi tertahan.\nLakukan Konfirmasi Pengambilan terlebih dahulu.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Tunjukkan QR Code ini kepada petugas Mitra Basecamp untuk melakukan verifikasi serah-terima alat.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
