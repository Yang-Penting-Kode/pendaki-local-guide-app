import 'package:flutter/material.dart';

class AppColors {
  // 🟢 Hijau Utama (Alpine Green)
  static const Color primary = Color(0xFF006C0C); //
  static const Color primaryContainer = Color(0xFF92FA83); //
  static const Color onPrimary = Color(0xFFFFFFFF); //[cite: 11]
  static const Color onPrimaryFixedVariant = Color(0xFF005307); //[cite: 11]

  // 🟠 Warna Aksen (Safety Orange - untuk Booking)
  static const Color secondary = Color(0xFF904D00); //[cite: 11]

  static const Color secondaryContainer =
      Color(0xFFFD8B00); // 🚀 FIX: Untuk label 'Jalur Utama'[cite: 11]
  static const Color onSurface = Color(0xFF1A1C1C);

  // ⚪ Warna Netral & Permukaan Utama
  static const Color surface = Color(0xFFF9F9F9); //[cite: 11]
  static const Color outline = Color(0xFF6F7A6A); //[cite: 11]
  static const Color onSurfaceVariant = Color(0xFF3F4A3B); //[cite: 11]

  // 🏗️ Material 3 Surface Containers (FIX ERROR MODAL)
  // Menambahkan variabel yang hilang sesuai standar desain HTML yang kita bahas sebelumnya
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F3F3);
  static const Color surfaceContainer = Color(0xFFEEEEEE);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E8);
  static const Color surfaceContainerHighest = Color(0xFFE2E2E2);

  // 🔴 Status & Error
  static const Color error = Color(0xFF93000A); //[cite: 11]
  static const Color errorContainer = Color(0xFFFFDAD6); //[cite: 11]
}
