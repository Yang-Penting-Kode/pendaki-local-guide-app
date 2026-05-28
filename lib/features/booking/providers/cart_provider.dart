// START REPLACE
// =============================================================================
// 🛒 CART PROVIDER — Manajemen Keranjang Belanja (RIVERPOD 2.x+)
// Lokasi: lib/features/booking/providers/cart_provider.dart
//
// Pola: Notifier<List<OrderItemModel>> — state sinkron, mutasi immutable.
// Context7: "Define a Notifier subclass with build() returning initial state
//   and methods to mutate state via spread operator [...state, newItem]"
//
// Kunci Desain:
//   • Keranjang memakai OrderItemModel (bukan CartItemModel baru) → SINGLE SOURCE
//     OF TRUTH. Saat checkout, list ini langsung masuk ke OrderModel.items.
//   • Semua kalkulasi harga pakai Decimal — DILARANG casting ke double.
//   • cartTotalProvider & cartCountProvider adalah computed (derived) providers.
// =============================================================================

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/shared/models/catalog/product_model.dart';
import 'package:pendaki_local_guide_app/shared/models/transactions/order_model.dart';

// ---------------------------------------------------------------------------
// 🛒 CART NOTIFIER (Notifier — state sinkron)
// ---------------------------------------------------------------------------
class CartNotifier extends Notifier<List<OrderItemModel>> {
  @override
  List<OrderItemModel> build() {
    // State awal: keranjang kosong (In-Memory, reset saat app restart)
    return const [];
  }

  // ---------------------------------------------------------------------------
  // ➕ ADD ITEM
  // Jika produk sudah ada di keranjang → increment quantity.
  // Jika belum → tambahkan sebagai item baru (quantity = 1).
  // Menggunakan spread operator immutable sesuai Riverpod best practice.
  // ---------------------------------------------------------------------------
  void addItem(ProductModel product) {
    final existingIndex =
        state.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      // Produk sudah ada → increment quantity & recalculate subtotal
      final existing = state[existingIndex];
      final newQuantity = existing.quantity + 1;
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            existing.copyWith(
              quantity: newQuantity,
              subtotal: existing.unitPrice *
                  Decimal.fromInt(newQuantity), // Decimal × Decimal
            )
          else
            state[i],
      ];
    } else {
      // Produk baru → tambahkan ke keranjang dengan markup Rp 1.000
      final markup = Decimal.parse('1000');
      final sellingPrice = product.basePrice + markup;

      state = [
        ...state,
        OrderItemModel(
          productId: product.id,
          productName: product.name,
          quantity: 1,
          unitPrice: sellingPrice,
          subtotal: sellingPrice, // qty=1, subtotal=sellingPrice
        ),
      ];
    }
  }

  // ---------------------------------------------------------------------------
  // ➖ REMOVE ITEM (hapus penuh dari keranjang)
  // ---------------------------------------------------------------------------
  void removeItem(String productId) {
    state = state.where((item) => item.productId != productId).toList();
  }

  // ---------------------------------------------------------------------------
  // 🔼 INCREMENT QUANTITY (+1)
  // ---------------------------------------------------------------------------
  void incrementQty(String productId) {
    state = [
      for (final item in state)
        if (item.productId == productId)
          item.copyWith(
            quantity: item.quantity + 1,
            subtotal: item.unitPrice * Decimal.fromInt(item.quantity + 1),
          )
        else
          item,
    ];
  }

  // ---------------------------------------------------------------------------
  // 🔽 DECREMENT QUANTITY (-1)
  // Jika quantity menjadi 0 → item dihapus dari keranjang otomatis.
  // ---------------------------------------------------------------------------
  void decrementQty(String productId) {
    final item = state.firstWhere(
      (i) => i.productId == productId,
      orElse: () => throw StateError('Item tidak ditemukan di keranjang'),
    );

    if (item.quantity <= 1) {
      // Auto-remove saat quantity = 0
      removeItem(productId);
    } else {
      state = [
        for (final i in state)
          if (i.productId == productId)
            i.copyWith(
              quantity: i.quantity - 1,
              subtotal: i.unitPrice * Decimal.fromInt(i.quantity - 1),
            )
          else
            i,
      ];
    }
  }

  // ---------------------------------------------------------------------------
  // 🗑️ CLEAR CART (setelah checkout berhasil)
  // ---------------------------------------------------------------------------
  void clearCart() {
    state = const [];
  }

  // ---------------------------------------------------------------------------
  // 🔍 ITEM COUNT untuk produk tertentu (utility untuk badge di ProductCard)
  // ---------------------------------------------------------------------------
  int getItemQuantity(String productId) {
    try {
      return state.firstWhere((i) => i.productId == productId).quantity;
    } catch (_) {
      return 0;
    }
  }

  /// Cek apakah produk tertentu sudah ada di keranjang
  bool isInCart(String productId) {
    return state.any((i) => i.productId == productId);
  }
}

// ---------------------------------------------------------------------------
// 📡 CART PROVIDER
// ---------------------------------------------------------------------------

/// Provider utama keranjang belanja.
/// ref.watch(cartProvider) → List<OrderItemModel>
/// ref.read(cartProvider.notifier).addItem(product)
final cartProvider = NotifierProvider<CartNotifier, List<OrderItemModel>>(
  CartNotifier.new,
);

// ---------------------------------------------------------------------------
// 💰 CART TOTAL PROVIDER (Computed — Decimal)
// Menjumlahkan semua subtotal item menggunakan fold().
// Context7: "Decimal.zero sebagai inisialisasi, bukan 0.0"
// WAJIB: Decimal arithmetic, bukan double. Tidak ada casting.
// ---------------------------------------------------------------------------
final cartTotalProvider = Provider<Decimal>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(
    Decimal.zero,
    (total, item) => total + item.subtotal,
  );
});

// ---------------------------------------------------------------------------
// 🔢 CART COUNT PROVIDER (Computed — jumlah total item unik)
// Untuk badge angka di icon keranjang di AppBar.
// ---------------------------------------------------------------------------
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).length;
});

// ---------------------------------------------------------------------------
// 🔢 CART TOTAL QTY PROVIDER (Computed — total semua quantity)
// Untuk menampilkan total unit yang disewa (misal: "5 item")
// ---------------------------------------------------------------------------
final cartTotalQtyProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (total, item) => total + item.quantity);
});
// END REPLACE
