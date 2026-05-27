// =============================================================================
// 📦 USER MODEL — Profil pengguna mitra (pemilik toko)
// Lokasi: lib/shared/models/user_model.dart
// Kontrak: fromJson + toJson + copyWith | created_at & updated_at wajib
// Relasi: Nested hasOne StoreModel (Eager Loading dari API)
// =============================================================================

import '../store/store_model.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? gender;
  final String? ktpNumber;
  final String? ktpPhotoUrl;
  final bool isVerified;
  final bool faceVerified;
  final StoreModel? store;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.gender,
    this.ktpNumber,
    this.ktpPhotoUrl,
    this.isVerified = false,
    this.faceVerified = false,
    this.store,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parsing dari JSON response Supabase REST / Laravel API Resource.
  /// Mendukung Eager Loading relasi `store` / `shop` dari Eloquent.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      fullName: json['name'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? json['phone_number'],
      gender: json['gender'],
      ktpNumber: json['ktp_number'],
      ktpPhotoUrl: json['ktp_photo_url'],
      isVerified: json['email_verified_at'] != null,
      faceVerified: json['face_verified_at'] != null,
      // Parsing relasi nested — mendukung key 'store' maupun 'shop'
      store: json['store'] != null
          ? StoreModel.fromJson(json['store'])
          : json['shop'] != null
              ? StoreModel.fromJson(json['shop'])
              : null,
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
      'name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'ktp_number': ktpNumber,
      'ktp_photo_url': ktpPhotoUrl,
      'is_verified': isVerified,
      'face_verified': faceVerified,
      'store': store?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Immutable copy untuk mutasi state Riverpod.
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? ktpNumber,
    String? ktpPhotoUrl,
    bool? isVerified,
    bool? faceVerified,
    StoreModel? store,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      ktpNumber: ktpNumber ?? this.ktpNumber,
      ktpPhotoUrl: ktpPhotoUrl ?? this.ktpPhotoUrl,
      isVerified: isVerified ?? this.isVerified,
      faceVerified: faceVerified ?? this.faceVerified,
      store: store ?? this.store,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, fullName: $fullName, email: $email)';
}
