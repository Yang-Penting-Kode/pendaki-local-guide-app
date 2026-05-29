// =============================================================================
// 🔐 AUTH REPOSITORY — In-Memory Storage (SURVIVAL DEMO MODE)
// Lokasi: lib/features/auth/data/repositories/auth_repository.dart
// Pola: Singleton — satu instance tunggal untuk seluruh siklus hidup app.
// AI_RULES: Bypass semua network call. Data tersimpan di List<UserModel> RAM.
// Context7 Source: /rrousselgit/riverpod — Notifier pattern confirmed.
// =============================================================================

// START REPLACE
import 'package:pendaki_local_guide_app/shared/models/auth/user_model.dart';

/// Kelas exception khusus untuk domain Auth — agar pesan error bisa
/// ditampilkan langsung di UI tanpa perlu parse DioException.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

/// Repository autentikasi dengan penyimpanan In-Memory.
/// Beroperasi sebagai singleton agar state list _users konsisten
/// di seluruh Provider tree selama sesi app berlangsung.
class AuthRepository {
  // --- Singleton Pattern ---
  AuthRepository._internal();
  static final AuthRepository _instance = AuthRepository._internal();
  factory AuthRepository() => _instance;

  // --- In-Memory Storage ---
  // List ini adalah "database" sementara selama demo berlangsung.
  // Data hilang saat app di-restart (sesuai AI_RULES Survival Mode).
  final List<_UserRecord> _users = [
    // ✅ DEFAULT DEMO USER: Gunakan credential ini saat Fire Drill
    _UserRecord(
      user: UserModel(
        id: 'user-demo-pendaki-01',
        fullName: 'Andi Surya Pendaki',
        email: 'pendaki@demo.com',
        phoneNumber: '081234567890',
        gender: 'Laki-laki',
        isVerified: true,
        faceVerified: false,
        store: null, // Pendaki BUKAN mitra — store selalu null
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 1, 15),
      ),
      hashedPassword: 'demo123', // SURVIVAL MODE: plain text, bukan di prod
    ),
  ];

  // ---------------------------------------------------------------------------
  // 🔑 LOGIN
  // Mencari user berdasarkan email & password.
  // Return: UserModel jika cocok, null jika tidak ditemukan / salah password.
  // ---------------------------------------------------------------------------
  UserModel? login(String email, String password) {
    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPassword = password.trim();

    try {
      final record = _users.firstWhere(
        (r) =>
            r.user.email.toLowerCase() == trimmedEmail &&
            r.hashedPassword == trimmedPassword,
      );
      return record.user;
    } catch (_) {
      // firstWhere throws StateError jika tidak ditemukan
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 📝 REGISTER
  // Menambahkan user baru ke in-memory list.
  // Throws [AuthException] jika email sudah terdaftar.
  // ---------------------------------------------------------------------------
  UserModel register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
    String? gender,
    String? ktpPhotoUrl,
    String? profilePhotoUrl,
    String? emergencyName,
    String? emergencyPhone,
  }) {
    final trimmedEmail = email.trim().toLowerCase();

    // Cek duplikasi email
    final emailExists = _users.any(
      (r) => r.user.email.toLowerCase() == trimmedEmail,
    );

    if (emailExists) {
      throw const AuthException('Email sudah terdaftar. Gunakan email lain.');
    }

    // Buat user baru
    final newUser = UserModel(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName.trim(),
      email: trimmedEmail,
      phoneNumber: phoneNumber?.trim(),
      gender: gender,
      ktpPhotoUrl: ktpPhotoUrl,
      profilePhotoUrl: profilePhotoUrl,
      emergencyName: emergencyName?.trim(),
      emergencyPhone: emergencyPhone?.trim(),
      isVerified: false,
      faceVerified: false,
      store: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _users.add(_UserRecord(user: newUser, hashedPassword: password.trim()));

    return newUser;
  }

  // ---------------------------------------------------------------------------
  // 🔍 GET USER BY ID (Utility — dipakai untuk refresh sesi)
  // ---------------------------------------------------------------------------
  UserModel? getUserById(String id) {
    try {
      return _users.firstWhere((r) => r.user.id == id).user;
    } catch (_) {
      return null;
    }
  }

  /// Total user terdaftar (untuk debugging / demo counter)
  int get userCount => _users.length;
}

// ---------------------------------------------------------------------------
// 📦 PRIVATE DATA CLASS — Menyimpan pasangan UserModel + password
// Dipakai hanya secara internal oleh AuthRepository.
// ---------------------------------------------------------------------------
class _UserRecord {
  final UserModel user;
  final String hashedPassword; // SURVIVAL MODE: plain text

  const _UserRecord({
    required this.user,
    required this.hashedPassword,
  });
}
// END REPLACE
