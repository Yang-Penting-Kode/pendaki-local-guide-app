// =============================================================================
// 📦 PRODUCT MODEL — Produk rental alat gunung milik mitra
// Lokasi: lib/shared/models/product_model.dart
// Kontrak: fromJson + toJson + copyWith | created_at & updated_at wajib
// Aturan: basePrice WAJIB Decimal (package:decimal) — AI_RULES #3
// =============================================================================

import 'package:decimal/decimal.dart';

import '../enums/app_enums.dart';

// REPLACE START
class ProductModel {
  final String id;
  final String storeId;
  final String categoryId;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? weight;
  final String? capacity;
  final Decimal basePrice;
  final int stock;
  final ProductStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductVariantModel>? variants;

  const ProductModel({
    required this.id,
    required this.storeId,
    required this.categoryId,
    required this.name,
    this.description,
    this.imageUrl,
    this.weight,
    this.capacity,
// REPLACE END
    required this.basePrice,
    required this.stock,
    this.status = ProductStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.variants,
  });
// REPLACE END

  /// Parsing dari JSON response Supabase REST / Laravel API Resource.
  /// basePrice di-parse dari string/number JSON ke Decimal presisi tinggi.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      name: json['name'] ?? '',
// REPLACE START
      description: json['description'],
      imageUrl: json['image_url'],
      weight: json['weight']?.toString(),
      capacity: json['capacity']?.toString(),
      basePrice: Decimal.parse(json['base_price']?.toString() ?? '0'),
// REPLACE END
      stock: json['stock'] ?? 0,
      status: ProductStatus.fromJson(json['status']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      variants: json['variants'] != null ? (json['variants'] as List).map((v) => ProductVariantModel.fromJson(v)).toList() : null,
    );
  }
// REPLACE END

  /// Serialisasi ke Map untuk dikirim via Dio POST/PUT.
  /// Decimal dikonversi ke String agar presisi terjaga di JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'category_id': categoryId,
      'name': name,
// REPLACE START
      'description': description,
      'image_url': imageUrl,
      'weight': weight,
      'capacity': capacity,
      'base_price': basePrice.toString(),
// REPLACE END
      'stock': stock,
      'status': status.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'variants': variants?.map((v) => v.toJson()).toList(),
    };
  }
// REPLACE END

  /// Immutable copy untuk mutasi state Riverpod.
// REPLACE START
  ProductModel copyWith({
    String? id,
    String? storeId,
    String? categoryId,
    String? name,
    String? description,
    String? imageUrl,
    String? weight,
    String? capacity,
    Decimal? basePrice,
    int? stock,
    ProductStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ProductVariantModel>? variants,
  }) {
    return ProductModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      weight: weight ?? this.weight,
      capacity: capacity ?? this.capacity,
      basePrice: basePrice ?? this.basePrice,
// REPLACE END
      stock: stock ?? this.stock,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      variants: variants ?? this.variants,
    );
  }
// REPLACE END

// REPLACE START
  @override
  String toString() => 'ProductModel(id: $id, name: $name, basePrice: $basePrice)';
}

class ProductVariantModel {
// REPLACE START
  final String name;
  final int stock;
  final Decimal additionalPrice;
  final String? imageUrl;

  const ProductVariantModel({
    required this.name,
    required this.stock,
    required this.additionalPrice,
    this.imageUrl,
  });
// REPLACE END

// REPLACE START
  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      name: json['name']?.toString() ?? '',
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      additionalPrice: Decimal.tryParse(json['additional_price']?.toString() ?? '0') ?? Decimal.parse('0'),
      imageUrl: json['image_url']?.toString(),
    );
  }
// REPLACE END

// REPLACE START
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'stock': stock,
      'additional_price': additionalPrice.toString(),
      'image_url': imageUrl,
    };
  }
// REPLACE END

// REPLACE START
  ProductVariantModel copyWith({String? name, int? stock, Decimal? additionalPrice, String? imageUrl}) {
    return ProductVariantModel(
      name: name ?? this.name,
      stock: stock ?? this.stock,
      additionalPrice: additionalPrice ?? this.additionalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
// REPLACE END
}
// REPLACE END
