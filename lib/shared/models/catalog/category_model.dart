// =============================================================================
// 📦 CATEGORY MODEL — Kategori produk rental (Tenda, Carrier, Sleeping Bag, dll)
// Lokasi: lib/shared/models/category_model.dart
// Kontrak: fromJson + toJson + copyWith | created_at & updated_at wajib
// =============================================================================

class CategoryModel {
  final String id;
  final String name;
  final String? iconUrl;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.iconUrl,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parsing dari JSON response Supabase REST / Laravel API Resource.
  /// Kolom API menggunakan snake_case sesuai konvensi backend.
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      iconUrl: json['icon_url'],
      sortOrder: json['sort_order'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  /// Serialisasi ke Map untuk dikirim via Dio POST/PUT.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_url': iconUrl,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Immutable copy untuk mutasi state Riverpod.
  CategoryModel copyWith({
    String? id,
    String? name,
    String? iconUrl,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'CategoryModel(id: $id, name: $name)';
}
