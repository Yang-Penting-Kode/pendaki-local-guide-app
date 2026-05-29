// START REPLACE
// =============================================================================
// 📋 ORDER PROVIDER — Manajemen Pesanan (RIVERPOD 2.x+)
// Lokasi: lib/features/booking/providers/order_provider.dart
//
// Pola: AsyncNotifier<List<OrderModel>> + Repository Provider injection.
// Context7: "Use AsyncValue.guard() for error handling in AsyncNotifier"
//           "ref.mounted check after async operations before updating state"
//
// Alur:
//   CartScreen → (checkout) → OrderNotifier.createOrder()
//                           → OrderRepository.createOrder() → orderId
//                           → Navigator.push('/qr-ticket', orderId)
// =============================================================================

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/booking/data/repositories/order_repository.dart';
import 'package:pendaki_local_guide_app/features/booking/providers/cart_provider.dart';
import 'package:pendaki_local_guide_app/shared/models/auth/user_model.dart';
import 'package:pendaki_local_guide_app/shared/models/enums/app_enums.dart';
import 'package:pendaki_local_guide_app/shared/models/transactions/order_model.dart';

// ---------------------------------------------------------------------------
// 🏭 ORDER REPOSITORY PROVIDER
// Singleton instance — diakses oleh OrderNotifier via ref.read().
// ---------------------------------------------------------------------------
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

// ---------------------------------------------------------------------------
// 📋 ORDER NOTIFIER (AsyncNotifier)
// build() → return list pesanan kosong saat init (In-Memory Survival Mode).
// createOrder() → memanggil repository, return orderId untuk navigasi QR.
// ---------------------------------------------------------------------------
class OrderNotifier extends AsyncNotifier<List<OrderModel>> {
  OrderRepository get _repo => ref.read(orderRepositoryProvider);

  @override
  Future<List<OrderModel>> build() async {
    // In-Memory: mulai dari list kosong, akan diisi saat checkout
    return [];
  }

  // ---------------------------------------------------------------------------
  // ✅ CREATE ORDER
  // Dipanggil dari CheckoutScreen setelah user konfirmasi pembayaran.
  // Return: orderId String yang akan diteruskan ke QrGeneratorScreen.
  //
  // Parameter:
  //   currentUser   → UserModel dari authProvider (untuk nama & customerId)
  //   rentalStart   → Tanggal mulai sewa (dari DatePicker di CheckoutScreen)
  //   rentalEnd     → Tanggal selesai sewa
  //
  // Kalkulasi Biaya (semua Decimal — AI_RULES #3):
  //   rentalCost    = sum(item.subtotal)
  //   depositCost   = 20% dari rentalCost
  //   platformFee   = 5% dari rentalCost
  //   totalGross    = rentalCost + depositCost + platformFee
  //   netEarnings   = rentalCost - platformFee (untuk mitra, bukan ditampilkan)
  // ---------------------------------------------------------------------------
  Future<String?> createOrder({
    required UserModel currentUser,
    required DateTime rentalStart,
    required DateTime rentalEnd,
    required Decimal deliveryCost, // 🚀 Injeksi Biaya Ongkir
  }) async {
    // Ambil item keranjang dari cartProvider
    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) return null;

    // Hitung Durasi (Tanggal Kembali - Tanggal Sewa + 1)
    final durationDays = rentalEnd.difference(rentalStart).inDays + 1;

    // Kalkulasi semua biaya menggunakan Decimal (tanpa double!)
    // Base daily cost * durationDays
    final dailyCost = cartItems.fold(
      Decimal.zero,
      (sum, item) => sum + item.subtotal,
    );
    final rentalCost = dailyCost * Decimal.fromInt(durationDays);

    // Skema Flat Fee: Biaya Admin Rp 5.000 per transaksi
    final platformFee = Decimal.parse('5000');
    
    // Deposit dihapus sesuai aturan bisnis baru
    final depositCost = Decimal.zero;

    // Total gross = Total Cart + Admin Fee + Delivery Cost (Ongkir)
    final totalGrossPrice = rentalCost + platformFee + deliveryCost; // 🚀 Kalkulasi ulang
    
    // Net earnings (hanya untuk referensi internal, diabaikan di UI consumer)
    // Sebenarnya net earnings harus dikurangi markup per item, tapi demi kesederhanaan model:
    final netEarnings = rentalCost;

    // Konstruksi OrderModel — id akan di-override oleh Repository (UUID v7)
    final newOrder = OrderModel(
      id: 'PENDING', // Placeholder, akan diganti orderId UUID v7 di Repository
      storeId: cartItems.first.productId.startsWith('prod')
          ? 'store-demo-mitra-01'
          : 'store-unknown',
      customerId: currentUser.id,
      status: OrderStatus.awaitingConfirmation,
      customerName: currentUser.fullName,
      customerAvatarUrl: currentUser.ktpPhotoUrl,
      rentalStartDate: rentalStart,
      rentalEndDate: rentalEnd,
      totalGrossPrice: totalGrossPrice,
      rentalCost: rentalCost,
      depositCost: depositCost,
      platformServiceFee: platformFee,
      deliveryCost: deliveryCost, // 🚀 Masukkan Delivery Cost ke Model
      netEarnings: netEarnings,
      items: cartItems, // Langsung dari cart — single source of truth
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Simpan ke repository, dapatkan orderId UUID v7
    String? orderId;

    state = await AsyncValue.guard(() async {
      orderId = await _repo.createOrder(newOrder);

      // Tambahkan order baru ke state list (immutable spread)
      final currentOrders = await future;

      return [...currentOrders, newOrder.copyWith(id: orderId)];
    });

    // Bersihkan keranjang setelah order berhasil dibuat
    if (orderId != null) {
      ref.read(cartProvider.notifier).clearCart();
    }

    return orderId;
  }

  // ---------------------------------------------------------------------------
  // 🔄 GET ORDERS (Refresh dari repository)
  // ---------------------------------------------------------------------------
  Future<void> refreshOrders(String customerId) async {
    state = await AsyncValue.guard(
      () => _repo.getOrdersByCustomerId(customerId),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔍 GET SINGLE ORDER (Utility untuk QrGeneratorScreen)
  // ---------------------------------------------------------------------------
  Future<OrderModel?> getOrderById(String orderId) {
    return _repo.getOrderById(orderId);
  }
}

// ---------------------------------------------------------------------------
// 📡 ORDER PROVIDER
// ---------------------------------------------------------------------------

/// Provider utama manajemen pesanan.
/// ref.watch(orderProvider) → AsyncValue<List<OrderModel>>
/// ref.read(orderProvider.notifier).createOrder(...)
final orderProvider =
    AsyncNotifierProvider<OrderNotifier, List<OrderModel>>(
  OrderNotifier.new,
);

// ---------------------------------------------------------------------------
// 📊 ACTIVE ORDER COUNT PROVIDER (Computed)
// Untuk badge notifikasi di dashboard/navbar.
// ---------------------------------------------------------------------------
final activeOrderCountProvider = Provider<int>((ref) {
  final ordersAsync = ref.watch(orderProvider);
  return ordersAsync.when(
    data: (orders) => orders
        .where(
          (o) =>
              o.status == OrderStatus.awaitingConfirmation ||
              o.status == OrderStatus.activeRental,
        )
        .length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// ---------------------------------------------------------------------------
// 💰 TOTAL SPENT PROVIDER (Computed — Decimal)
// Total pengeluaran user dari semua pesanan selesai (untuk analytics screen).
// ---------------------------------------------------------------------------
final totalSpentProvider = Provider<Decimal>((ref) {
  final ordersAsync = ref.watch(orderProvider);
  return ordersAsync.when(
    data: (orders) => orders
        .where((o) => o.status == OrderStatus.completed)
        .fold(Decimal.zero, (sum, o) => sum + o.totalGrossPrice),
    loading: () => Decimal.zero,
    error: (_, __) => Decimal.zero,
  );
});
// END REPLACE
