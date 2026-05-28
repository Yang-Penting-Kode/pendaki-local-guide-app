import 'package:dio/dio.dart';
import 'package:pendaki_local_guide_app/shared/models/auth/user_model.dart';

class AuthService {
  // Gunakan singleton Dio untuk efisiensi koneksi di laptop ROG-mu
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.localguide.my.id/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Accept': 'application/json'},
  ));

  // Migrasi fungsi register ke Dio dengan dukungan data dinamis
  Future<bool> register({required Map<String, dynamic> data}) async {
    try {
      // Dio secara otomatis mengonversi Map ke JSON[cite: 14]
      final response = await _dio.post('/register', data: data);

      // Status 201 menandakan data berhasil dibuat di Laravel[cite: 14]
      return response.statusCode == 201;
    } on DioException catch (e) {
      // Cetak error ke terminal Ubuntu untuk debugging sat-set
      print('Auth Error: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  // Fungsi Login (Persiapan integrasi token)
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      return response.data['token']; // Mengembalikan JWT Token
    } catch (e) {
      return null;
    }
  }
}
