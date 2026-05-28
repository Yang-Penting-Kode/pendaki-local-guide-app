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

  static const String _onboardingKey = 'has_seen_onboarding';

  static Future<void> markOnboardingSeen() async {
    await _prefs?.setBool(_onboardingKey, true);
  }

  static bool hasSeenOnboarding() {
    return _prefs?.getBool(_onboardingKey) ?? false;
  }
}
