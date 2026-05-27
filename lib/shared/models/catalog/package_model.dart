// =============================================================================
// 📦 PACKAGE MODEL — Bundling produk rental alat gunung
// Lokasi: lib/shared/models/package_model.dart
// Kontrak: fromJson + toJson + copyWith
// =============================================================================

import 'package:decimal/decimal.dart';

class PackageItemModel {
  final String productId;
  final int quantity;

  const PackageItemModel({
    required this.productId,
    required this.quantity,
  });

  factory PackageItemModel.fromJson(Map<String, dynamic> json) {
    return PackageItemModel(
      productId: json['product_id']?.toString() ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }
}

class PackageModel {
  final String id;
  final String storeId;
  final String name;
  final String? description;
// REPLACE START
  final String? imageUrl;
  final Decimal price;
  final bool isDraft;
  final int stock;
  final String? weight;
  final List<PackageItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;
// REPLACE END

  const PackageModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.description,
    this.imageUrl,
// REPLACE START
    required this.price,
    this.isDraft = false,
    required this.stock,
    this.weight,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
// REPLACE END
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
// REPLACE START
      price: Decimal.parse(json['price']?.toString() ?? '0'),
      isDraft: json['is_draft'] ?? false,
      stock: json['stock'] ?? 1,
      weight: json['weight']?.toString(),
      items: (json['items'] as List?)?.map((i) => PackageItemModel.fromJson(i)).toList() ?? [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
// REPLACE END
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'description': description,
      'image_url': imageUrl,
// REPLACE START
      'price': price.toString(),
      'is_draft': isDraft,
      'stock': stock,
      'weight': weight,
      'items': items.map((i) => i.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
// REPLACE END
    };
  }

  PackageModel copyWith({
    String? id,
    String? storeId,
    String? name,
    String? description,
    String? imageUrl,
// REPLACE START
    Decimal? price,
    bool? isDraft,
    int? stock,
    String? weight,
    List<PackageItemModel>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
// REPLACE END
  }) {
    return PackageModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
// REPLACE START
      price: price ?? this.price,
      isDraft: isDraft ?? this.isDraft,
      stock: stock ?? this.stock,
      weight: weight ?? this.weight,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
// REPLACE END
    );
  }
}
