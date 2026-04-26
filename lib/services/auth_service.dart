import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String _baseUrl = 'https://api.localguide.my.id/api';

  Future<bool> register({required Map<String, String> data}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        body: data,
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}