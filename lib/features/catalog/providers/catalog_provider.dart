// START REPLACE
// =============================================================================
// 🛒 CATALOG PROVIDER — Product State Management (RIVERPOD 2.x+)
// Lokasi: lib/features/catalog/providers/catalog_provider.dart
//
// Pola: AsyncNotifier + Provider dependency injection (Context7 confirmed).
//   "Do not put logic in the constructor; place logic in the build method."
//   — Riverpod docs via Context7 /rrousselgit/riverpod
//
// Arsitektur:
//   productRepositoryProvider → ProductNotifier.build() → ProductProvider
//   searchQueryProvider ──────────────────────────────→ filteredProductsProvider
// =============================================================================

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/features/catalog/data/repositories/product_repository.dart';
import 'package:pendaki_local_guide_app/shared/models/catalog/product_model.dart';

// ---------------------------------------------------------------------------
// 🏭 REPOSITORY PROVIDER
// Menyediakan instance singleton ProductRepository ke seluruh Provider tree.
// Notifier mengakses via ref.read(productRepositoryProvider) — satu kali.
// ---------------------------------------------------------------------------
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// ---------------------------------------------------------------------------
// 🔍 SEARCH QUERY PROVIDER
// StateProvider<String> untuk menyimpan input search bar (Ephemeral state).
// Context7: "A common pattern: split into StateProvider for params + FutureProvider
// for request." — Search as we type pattern.
// ---------------------------------------------------------------------------
final searchQueryProvider = StateProvider<String>((ref) => '');

// ---------------------------------------------------------------------------
// 📦 PRODUCT NOTIFIER (AsyncNotifier)
// build() → memanggil ProductRepository.getProducts() satu kali saat init.
// search() → memfilter state lokal (In-Memory, no re-fetch).
// refresh() → ref.invalidateSelf() untuk reload penuh.
// ---------------------------------------------------------------------------
class ProductNotifier extends AsyncNotifier<List<ProductModel>> {
  ProductRepository get _repo => ref.read(productRepositoryProvider);

  @override
  Future<List<ProductModel>> build() async {
    // Load semua produk saat provider pertama kali di-watch
    return _repo.getProducts();
  }

  /// Filter produk berdasarkan query (In-Memory filtering, no API call).
  /// Dipanggil dari search bar: ref.read(productProvider.notifier).search(query)
  Future<void> search(String query) async {
    // Set loading state sambil mempertahankan data lama (UX lebih smooth)
    // Context7: AsyncLoading.copyWithPrevious() preserves UI state during loading
    state = const AsyncLoading<List<ProductModel>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() => _repo.searchProducts(query));
  }

  /// Reset ke semua produk tanpa filter
  Future<void> reset() async {
    state = const AsyncLoading<List<ProductModel>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => _repo.getProducts());
  }

  /// Refresh paksa (re-fetch dari repository)
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future; // Tunggu sampai build() selesai
  }
}

/// Provider utama katalog produk.
/// UI: ref.watch(productProvider) → AsyncValue<List<ProductModel>>
final productProvider =
    AsyncNotifierProvider<ProductNotifier, List<ProductModel>>(
  ProductNotifier.new,
);

// ---------------------------------------------------------------------------
// 🔍 FILTERED PRODUCTS PROVIDER (Computed/Derived Provider)
// Menggabungkan productProvider + searchQueryProvider secara reaktif.
// Digunakan bila ingin auto-filter real-time tanpa memanggil search() manual.
// ---------------------------------------------------------------------------
final filteredProductsProvider = Provider<AsyncValue<List<ProductModel>>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final productsAsync = ref.watch(productProvider);

  if (query.trim().isEmpty) return productsAsync;

  return productsAsync.whenData(
    (products) => products
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              (p.description?.toLowerCase().contains(query.toLowerCase()) ??
                  false),
        )
        .toList(),
  );
});

// ---------------------------------------------------------------------------
// 📊 CATEGORY LIST PROVIDER (Derived dari product list)
// Mengekstrak kategori unik untuk chip filter di HomeScreen.
// ---------------------------------------------------------------------------
final categoryListProvider = Provider<List<String>>((ref) {
  final productsAsync = ref.watch(productProvider);
  return productsAsync.when(
    data: (products) {
      final categories = products.map((p) => p.categoryId).toSet().toList();
      return ['Semua', ...categories];
    },
    loading: () => ['Semua'],
    error: (_, __) => ['Semua'],
  );
});

// ---------------------------------------------------------------------------
// 💲 PRICE RANGE PROVIDER (Utility untuk filter harga — Sprint selanjutnya)
// Memberikan basePrice minimum dari seluruh katalog untuk slider filter.
// ---------------------------------------------------------------------------
final minPriceProvider = Provider<Decimal>((ref) {
  final productsAsync = ref.watch(productProvider);
  return productsAsync.when(
    data: (products) {
      if (products.isEmpty) return Decimal.zero;
      return products.map((p) => p.basePrice).reduce(
            (min, price) => price < min ? price : min,
          );
    },
    loading: () => Decimal.zero,
    error: (_, __) => Decimal.zero,
  );
});
// END REPLACE
