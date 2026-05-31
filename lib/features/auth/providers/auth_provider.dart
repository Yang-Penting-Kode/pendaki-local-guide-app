// =============================================================================
// 🔐 AUTH PROVIDER — Riverpod State Management untuk Autentikasi
// Lokasi: lib/features/auth/providers/auth_provider.dart
//
// Pola: Notifier<UserModel?> — API Riverpod 2.x+ (bukan StateNotifier)
// Context7 Source: /rrousselgit/riverpod (Benchmark: 87.5)
//   "Do not put logic in the constructor; place logic in the build method."
//   "ref.read(yourNotifierProvider.notifier).yourMethod()"
//
// State: null = belum login | UserModel = sudah login
// AI_RULES: Alur UI → Provider → Repository (In-Memory, bypass Dio)
// =============================================================================

// START REPLACE
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pendaki_local_guide_app/core/local_storage/storage_services.dart';
import 'package:pendaki_local_guide_app/features/auth/data/repositories/auth_repository.dart';
import 'package:pendaki_local_guide_app/shared/models/auth/user_model.dart';

// ---------------------------------------------------------------------------
// 📦 AUTH STATE — Membungkus state dengan status loading dan pesan error
// Menggunakan sealed class ringan agar UI bisa react terhadap semua kondisi
// tanpa harus bergantung pada AsyncValue (overhead untuk kasus sederhana ini).
// ---------------------------------------------------------------------------

/// Hasil operasi login/register yang dikembalikan ke UI.
enum AuthResultStatus { success, invalidCredential, emailExists, unknownError }

class AuthResult {
  final AuthResultStatus status;
  final String? message;

  const AuthResult({required this.status, this.message});

  bool get isSuccess => status == AuthResultStatus.success;
}

// ---------------------------------------------------------------------------
// 🔐 AUTH NOTIFIER
// Pola dari Context7: Notifier<T> dengan build() sebagai titik inisialisasi.
// Semua akses dari UI via: ref.read(authProvider.notifier).login(...)
// ---------------------------------------------------------------------------
class AuthNotifier extends Notifier<UserModel?> {
  // Repository diakses via getter lazy — tidak diinisialisasi di constructor
  // sesuai Context7: "ref and other properties are not yet available in constructor"
  AuthRepository get _repo => AuthRepository();

  @override
  UserModel? build() {
    // Membaca token dari StorageService untuk bypass AuthGate (Backend Ready)
    final token = StorageService.getAuthToken();
    if (token != null) {
      // In-Memory: return mock UserModel karena token ditemukan
      return UserModel(
        id: 'mock_user_123',
        fullName: 'Pendaki Terdaftar',
        email: 'user@example.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    // State awal: null (belum login)
    return null;
  }

  // ---------------------------------------------------------------------------
  // 🔑 LOGIN
  // Dipanggil dari UI: ref.read(authProvider.notifier).login(email, password)
  // Return: AuthResult — UI menentukan navigasi berdasarkan isSuccess
  // ---------------------------------------------------------------------------
  AuthResult login(String email, String password) {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return const AuthResult(
        status: AuthResultStatus.invalidCredential,
        message: 'Email dan password tidak boleh kosong.',
      );
    }

// START REPLACE
    final savedEmail = StorageService.getRegisteredEmail();
    final savedPassword = StorageService.getRegisteredPassword();
    
    final isRegisteredUser = savedEmail != null && email.trim().toLowerCase() == savedEmail && password == savedPassword;
    final isGlobalDemoUser = email.trim().toLowerCase() == 'pendaki@demo.com' && password == 'demo123';

    if (!isRegisteredUser && !isGlobalDemoUser) {
      return const AuthResult(
        status: AuthResultStatus.invalidCredential,
        message: 'Email atau Password tidak terdaftar.',
      );
    }

    // MVP Lokal: Bypass validasi repository, buat mock user langsung
    final mockUser = UserModel(
      id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: isGlobalDemoUser ? 'Andi Surya Pendaki' : email.split('@').first,
      email: email.trim().toLowerCase(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    state = mockUser;
// END REPLACE
    
    // Simpan token dan set isFirstTimeLogin false
    StorageService.setAuthToken('mock_token_123');
    StorageService.setIsFirstTimeLogin(false);

    return const AuthResult(status: AuthResultStatus.success);
  }

  // ---------------------------------------------------------------------------
  // 📝 REGISTER
  // Dipanggil dari UI: ref.read(authProvider.notifier).register(...)
  // Setelah register berhasil, user langsung di-login (auto-login).
  // ---------------------------------------------------------------------------
  AuthResult register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    String? phoneNumber,
    String? gender,
    String? ktpPhotoUrl,
    String? profilePhotoUrl,
    String? emergencyName,
    String? emergencyPhone,
  }) {
    // Validasi lokal sebelum menyentuh repository
    if (fullName.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      return const AuthResult(
        status: AuthResultStatus.invalidCredential,
        message: 'Semua field wajib diisi.',
      );
    }

    if (password != confirmPassword) {
      return const AuthResult(
        status: AuthResultStatus.invalidCredential,
        message: 'Konfirmasi password tidak cocok.',
      );
    }

    if (password.length < 6) {
      return const AuthResult(
        status: AuthResultStatus.invalidCredential,
        message: 'Password minimal 6 karakter.',
      );
    }

    try {
      // MVP Lokal: Bypass repository, langsung simpan kredensial ke disk
      final mockUser = UserModel(
        id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName.trim(),
        email: email.trim().toLowerCase(),
        phoneNumber: phoneNumber?.trim(),
        gender: gender,
        ktpPhotoUrl: ktpPhotoUrl,
        profilePhotoUrl: profilePhotoUrl,
        emergencyName: emergencyName?.trim(),
        emergencyPhone: emergencyPhone?.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      StorageService.setRegisteredCredentials(email, password);

      // Auto-login setelah register berhasil
      state = mockUser;
      
      // Simpan token dan set isFirstTimeLogin true
      StorageService.setAuthToken('mock_token_123');
      StorageService.setIsFirstTimeLogin(true);

      return const AuthResult(status: AuthResultStatus.success);
    } on AuthException catch (e) {
      return AuthResult(
        status: AuthResultStatus.emailExists,
        message: e.message,
      );
    } catch (_) {
      return const AuthResult(
        status: AuthResultStatus.unknownError,
        message: 'Terjadi kesalahan. Silakan coba lagi.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // 🚪 LOGOUT
  // Reset state ke null — UI akan redirect ke LoginScreen
  // ---------------------------------------------------------------------------
  void logout() {
    // Hapus data token dari storage
    StorageService.clearAuthData();
    state = null;
  }

  // ---------------------------------------------------------------------------
  // ✏️ UPDATE PROFILE (Utility — untuk EditProfileScreen nanti)
  // ---------------------------------------------------------------------------
  void updateProfile(UserModel updatedUser) {
    if (state == null) return;
    state = updatedUser;
  }
}

// ---------------------------------------------------------------------------
// 📡 PROVIDERS
// Definisi semua provider dalam satu file agar mudah di-import.
// Pola: satu file per feature untuk provider.
// ---------------------------------------------------------------------------

/// Provider utama: menyimpan UserModel? (null = belum login)
/// Akses state: ref.watch(authProvider) → UserModel?
/// Akses notifier: ref.read(authProvider.notifier) → AuthNotifier
final authProvider = NotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);

/// Computed provider: true jika user sudah login
/// Gunakan ini di routing guard dan conditional widget.
/// Contoh: ref.watch(isLoggedInProvider) → bool
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) != null;
});

/// Computed provider: nama display user yang sedang login
/// Fallback ke 'Pendaki' jika belum login (untuk safe UI rendering).
final currentUserNameProvider = Provider<String>((ref) {
  return ref.watch(authProvider)?.fullName ?? 'Pendaki';
});

/// Computed provider: email user yang sedang login
final currentUserEmailProvider = Provider<String>((ref) {
  return ref.watch(authProvider)?.email ?? '';
});
// END REPLACE
