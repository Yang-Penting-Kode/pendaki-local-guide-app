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

  static const String _authTokenKey = 'auth_token';
  static const String _isFirstTimeKey = 'is_first_time_login';

  static Future<void> setAuthToken(String token) async {
    await _prefs?.setString(_authTokenKey, token);
  }

  static String? getAuthToken() {
    return _prefs?.getString(_authTokenKey);
  }

  static Future<void> setIsFirstTimeLogin(bool isFirstTime) async {
    await _prefs?.setBool(_isFirstTimeKey, isFirstTime);
  }

  static bool? getIsFirstTimeLogin() {
    return _prefs?.getBool(_isFirstTimeKey);
  }

  static const String _registeredEmailKey = 'registered_email';
  static const String _registeredPasswordKey = 'registered_password';

  static Future<void> setRegisteredCredentials(String email, String password) async {
    await _prefs?.setString(_registeredEmailKey, email.trim().toLowerCase());
    await _prefs?.setString(_registeredPasswordKey, password);
  }

  static String? getRegisteredEmail() {
    return _prefs?.getString(_registeredEmailKey);
  }

  static String? getRegisteredPassword() {
    return _prefs?.getString(_registeredPasswordKey);
  }

  static const String _wishlistKey = 'wishlist_ids';

  static List<String> getWishlist() => _prefs?.getStringList(_wishlistKey) ?? [];

  static Future<void> setWishlist(List<String> ids) async => await _prefs?.setStringList(_wishlistKey, ids);

// START REPLACE
  static Future<bool> toggleWishlist(String productId) async {
    final list = getWishlist();
    final isExist = list.contains(productId);
    if (isExist) {
      list.remove(productId);
    } else {
      list.add(productId);
    }
    await setWishlist(list);
    return !isExist; // return true jika ditambah, false jika dihapus
  }
// END REPLACE

  static Future<void> clearAuthData() async {
    await _prefs?.remove(_authTokenKey);
    await _prefs?.remove(_isFirstTimeKey);
  }
}
