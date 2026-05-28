// START REPLACE
// =============================================================================
// 📋 ORDER REPOSITORY — In-Memory Order Storage (SURVIVAL DEMO MODE)
// Lokasi: lib/features/booking/data/repositories/order_repository.dart
//
// Pola: Singleton — satu instance tunggal selama siklus hidup app.
// AI_RULES: Bypass network. Data tersimpan di List<OrderModel> RAM.
// Context7 UUID v7: Uuid().v7() — time-based, sortable → ideal untuk orderId.
//   Alasan v7 > v4: v7 diurutkan berdasarkan waktu pembuatan → lebih mudah
//   dipakai di list UI (order terbaru otomatis ada di posisi terakhir).
// =============================================================================

import 'package:uuid/uuid.dart';
import 'package:pendaki_local_guide_app/shared/models/transactions/order_model.dart';
import 'package:pendaki_local_guide_app/shared/models/enums/app_enums.dart';

class OrderRepository {
  // --- Singleton Pattern ---
  OrderRepository._internal();
  static final OrderRepository _instance = OrderRepository._internal();
  factory OrderRepository() => _instance;

  // UUID generator — instance tunggal, tidak perlu di-recreate setiap call
  static const _uuid = Uuid();

  // --- In-Memory Storage ---
  final List<OrderModel> _orders = [];

  // ---------------------------------------------------------------------------
  // ✅ CREATE ORDER
  // Menerima OrderModel yang sudah dikonstruksi dari OrderProvider.
  // Mengganti id placeholder dengan UUID v7 yang baru di-generate.
  // Return: orderId baru yang dapat dipakai sebagai payload QR.
  //
  // Kenapa orderId di-generate di sini bukan di Provider?
  // → Repository adalah "gerbang penyimpanan", menjamin ID unik berasal
  //   dari satu sumber kebenaran yang konsisten.
  // ---------------------------------------------------------------------------
  Future<String> createOrder(OrderModel order) async {
    // Simulasi latency network untuk UX yang natural
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate UUID v7 (time-based, sortable) — Context7 verified syntax
    final newOrderId = _uuid.v7();

    // Buat OrderModel baru dengan ID yang sudah di-assign
    final orderWithId = order.copyWith(
      id: newOrderId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _orders.add(orderWithId);

    return newOrderId;
  }

  // ---------------------------------------------------------------------------
  // 🔍 GET ORDER BY ID
  // Dipakai oleh QrGeneratorScreen untuk menampilkan detail pesanan.
  // Return null jika orderId tidak ditemukan (safety guard).
  // ---------------------------------------------------------------------------
  Future<OrderModel?> getOrderById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 🔍 GET ORDERS BY USER (Customer)
  // Untuk halaman "Riwayat Pesanan" user.
  // ---------------------------------------------------------------------------
  Future<List<OrderModel>> getOrdersByCustomerId(String customerId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _orders
        .where((o) => o.customerId == customerId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Terbaru dulu
  }

  // ---------------------------------------------------------------------------
  // 🔄 UPDATE ORDER STATUS
  // Utility untuk skenario: Mitra scan QR → status berubah.
  // ---------------------------------------------------------------------------
  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index < 0) return false;

    _orders[index] = _orders[index].copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    return true;
  }

  /// Jumlah total pesanan aktif (untuk counter badge di dashboard)
  int get activeOrderCount => _orders
      .where(
        (o) =>
            o.status == OrderStatus.awaitingConfirmation ||
            o.status == OrderStatus.activeRental,
      )
      .length;

  /// Semua pesanan (untuk admin view / debugging)
  List<OrderModel> get allOrders => List.unmodifiable(_orders);
}
// END REPLACE
