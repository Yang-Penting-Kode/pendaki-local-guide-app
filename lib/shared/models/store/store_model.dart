// =============================================================================
// 📦 STORE MODEL — Profil toko mitra rental alat gunung
// Lokasi: lib/shared/models/store_model.dart
// Kontrak: fromJson + toJson + copyWith | created_at & updated_at wajib
// Catatan: Rename dari ShopModel lama. Semua referensi baru wajib pakai ini.
// =============================================================================

class StoreModel {
  final String id;
  final String ownerId;
  final String storeName;
  final String? logoUrl;
  final String? addressDisplay;
  final double? latitude;
  final double? longitude;
  final String? phoneNumber;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StoreModel({
    required this.id,
    required this.ownerId,
    required this.storeName,
    this.logoUrl,
    this.addressDisplay,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parsing dari JSON response Supabase REST / Laravel API Resource.
  /// Mendukung relasi nested dari Eloquent `with('shop')`.
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id']?.toString() ?? '',
      ownerId: json['owner_id']?.toString() ?? '',
      storeName: json['store_name'] ?? json['shop_name'] ?? '',
      logoUrl: json['logo_url'],
      addressDisplay: json['address_display'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      phoneNumber: json['phone_number'],
      isActive: json['is_active'] ?? true,
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
      'owner_id': ownerId,
      'store_name': storeName,
      'logo_url': logoUrl,
      'address_display': addressDisplay,
      'latitude': latitude,
      'longitude': longitude,
      'phone_number': phoneNumber,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Immutable copy untuk mutasi state Riverpod.
  StoreModel copyWith({
    String? id,
    String? ownerId,
    String? storeName,
    String? logoUrl,
    String? addressDisplay,
    double? latitude,
    double? longitude,
    String? phoneNumber,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      storeName: storeName ?? this.storeName,
      logoUrl: logoUrl ?? this.logoUrl,
      addressDisplay: addressDisplay ?? this.addressDisplay,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'StoreModel(id: $id, storeName: $storeName)';
}
