// START REPLACE
// =============================================================================
// 🛒 PRODUCT REPOSITORY — In-Memory Catalog (SURVIVAL DEMO MODE)
// Lokasi: lib/features/catalog/data/repositories/product_repository.dart
//
// Pola: Singleton — satu instance tunggal selama siklus hidup app.
// AI_RULES: Bypass network. Seed data statis di RAM.
// Context7 UUID: Uuid().v7() — time-based, sortable → cocok untuk produk ID.
// Context7 Decimal: Decimal.parse("string") — BUKAN dari double!
// =============================================================================

import 'package:decimal/decimal.dart';
import 'package:pendaki_local_guide_app/shared/models/catalog/product_model.dart';
import 'package:pendaki_local_guide_app/shared/models/enums/app_enums.dart';

class ProductRepository {
  // --- Singleton Pattern ---
  ProductRepository._internal();
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;

  // ---------------------------------------------------------------------------
  // 📦 IN-MEMORY SEED DATA — 8 Produk Alat Pendakian Realistis
  // Harga menggunakan Decimal.parse("string") sesuai AI_RULES #3
  // ImageUrl menggunakan Unsplash untuk demo visual yang meyakinkan.
  // ---------------------------------------------------------------------------
  final List<ProductModel> _products = [
    ProductModel(
      id: 'prod-001',
      storeId: 'store-demo-mitra-01',
      categoryId: 'cat-tenda',
      name: 'Tenda Dome 2P Eiger Summit',
      description:
          'Tenda ringan 2 orang dengan desain dome aerodynamic. Cocok untuk pendakian Rinjani dan Semeru. Waterproof rating 3000mm.',
      // START REPLACE
      imageUrl:
          'https://picsum.photos/seed/tenda/400/300',
      // END REPLACE
      weight: '1.8 kg',
      capacity: '2 orang',
      basePrice: Decimal.parse('150000'),
      variants: [
        ProductVariantModel(name: 'Standar', stock: 5, additionalPrice: Decimal.zero),
        ProductVariantModel(name: 'Premium (+Matras)', stock: 3, additionalPrice: Decimal.parse('20000')),
      ],
      stock: 5,
      status: ProductStatus.active,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    ProductModel(
      id: 'prod-002',
      storeId: 'store-demo-mitra-01',
      categoryId: 'cat-carrier',
      name: 'Carrier 60L Deuter Guide',
      description:
          'Ransel gunung kapasitas besar 60L dengan frame alumunium dan hipbelt yang ergonomis. Ideal untuk pendakian multi-day.',
      imageUrl:
          'https://picsum.photos/seed/carrier/400/300',
      weight: '2.1 kg',
      capacity: '60 liter',
      basePrice: Decimal.parse('85000'),
      stock: 8,
      status: ProductStatus.active,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    ProductModel(
      id: 'prod-003',
      storeId: 'store-demo-mitra-01',
      categoryId: 'cat-sleeping',
      name: 'Sleeping Bag -5°C Consina',
      description:
          'Sleeping bag suhu ekstrem hingga -5°C. Isian hollow fiber premium anti-lembab. Cocok untuk pendakian puncak tinggi.',
      imageUrl:
          'https://picsum.photos/seed/sleepingbag/400/300',
      weight: '1.2 kg',
      capacity: '1 orang',
      basePrice: Decimal.parse('65000'),
      stock: 10,
      status: ProductStatus.active,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    ProductModel(
      id: 'prod-004',
      storeId: 'store-demo-mitra-01',
      categoryId: 'cat-matras',
      name: 'Matras Sleeping Pad Thermarest',
      description:
          'Matras self-inflating ringan dan nyaman. R-value 2.1 untuk insulasi dari tanah dingin. Ukuran reguler.',
      imageUrl:
          'https://picsum.photos/seed/matras/400/300',
      weight: '0.7 kg',
      capacity: '1 orang',
      basePrice: Decimal.parse('35000'),
      stock: 15,
      status: ProductStatus.active,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    ProductModel(
      id: 'prod-005',
      storeId: 'store-demo-mitra-01',
      categoryId: 'cat-jaket',
      name: 'Jaket Hardshell Rei Gore-Tex',
      description:
          'Jaket waterproof & windproof berbahan Gore-Tex 3-layer. Seam-sealed sempurna. Untuk kondisi hujan & angin kencang.',
      imageUrl:
          'https://picsum.photos/seed/jaket/400/300',
      weight: '0.6 kg',
      capacity: 'XS/S/M/L/XL',
      basePrice: Decimal.parse('55000'),
      stock: 6,
      status: ProductStatus.active,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    ProductModel(
      id: 'prod-006',
      storeId: 'store-demo-mitra-01',
      categoryId: 'cat-headlamp',
      name: 'Headlamp Petzl Actik 450lm',
      description:
          'Senter kepala dengan output 450 lumen. Baterai tahan hingga 160 jam. Tersedia mode merah untuk mode gelap.',
      imageUrl:
          'https://picsum.photos/seed/headlamp/400/300',
      weight: '85 gram',
      capacity: '1 unit',
      basePrice: Decimal.parse('25000'),
      stock: 20,
      status: ProductStatus.active,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    ProductModel(
      id: 'prod-007',
      storeId: 'store-demo-mitra-01',
      categoryId: 'cat-kompor',
      name: 'Kompor Portable Primus Lite+',
      description:
          'Kompor ultralight gas titanium 115g. Piezo ignition. Kompatibel dengan canister gas standar EU/threaded.',
      imageUrl:
          'https://picsum.photos/seed/kompor/400/300',
      weight: '0.4 kg',
      capacity: '1 unit + canister',
      basePrice: Decimal.parse('30000'),
      stock: 12,
      status: ProductStatus.active,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    ProductModel(
      id: 'prod-008',
      storeId: 'store-demo-mitra-01',
      categoryId: 'cat-trekking',
      name: 'Trekking Pole Leki Makalu',
      description:
          'Tongkat pendakian alumunium 7075 3-section. Cork grip ergonomis. Cocok untuk medan berbatu dan salju.',
      imageUrl:
          'https://picsum.photos/seed/trekkingpole/400/300',
      weight: '0.52 kg (sepasang)',
      capacity: '2 buah (1 pasang)',
      basePrice: Decimal.parse('40000'),
      stock: 7,
      status: ProductStatus.active,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
  ];

  // ---------------------------------------------------------------------------
  // 🔍 GET ALL PRODUCTS
  // Simulasi network delay 300ms agar UI loading skeleton bisa terlihat.
  // ---------------------------------------------------------------------------
  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_products);
  }

  // ---------------------------------------------------------------------------
  // 🔍 GET PRODUCTS WITH SEARCH FILTER
  // Dipanggil dari ProductProvider saat searchQuery berubah.
  // Filter berlaku pada name dan description (case-insensitive).
  // ---------------------------------------------------------------------------
  Future<List<ProductModel>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (query.trim().isEmpty) return List.unmodifiable(_products);

    final lowerQuery = query.toLowerCase();
    return _products
        .where(
          (p) =>
              p.name.toLowerCase().contains(lowerQuery) ||
              (p.description?.toLowerCase().contains(lowerQuery) ?? false) ||
              (p.categoryId.toLowerCase().contains(lowerQuery)),
        )
        .toList();
  }

  // ---------------------------------------------------------------------------
  // 🔍 GET PRODUCT BY ID
  // Return null jika tidak ditemukan (UI handle dengan error state).
  // ---------------------------------------------------------------------------
  Future<ProductModel?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 📊 GET PRODUCTS BY CATEGORY
  // Utility untuk filter beranda berdasarkan kategori.
  // ---------------------------------------------------------------------------
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  /// Total produk aktif tersedia (untuk info counter di UI)
  int get productCount => _products.where((p) => p.status == ProductStatus.active).length;
}
// END REPLACE
