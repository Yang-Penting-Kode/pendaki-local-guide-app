// lib/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static const String _langKey = 'selected_language';

  // 🛠️ FIX: Nama fungsi adalah getInstance() bukan getInstances()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance(); 
  }

  static Future<void> setLanguage(String name) async {
    await _prefs?.setString(_langKey, name);
  }

  static String getLanguage() {
    return _prefs?.getString(_langKey) ?? 'Bahasa Indonesia';
  }
}