import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyService {
  static const String _keyApiKey = 'gemini_api_key';
  static const String _defaultApiKey = 'AIzaSyCqswhyVT7ceN4Hs622FOXZEsali3SL4M4';

  /// Get the current API key (custom or default)
  Future<String> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final customKey = prefs.getString(_keyApiKey);

    // Return custom key if exists, otherwise return default
    return customKey?.isNotEmpty == true ? customKey! : _defaultApiKey;
  }

  /// Get custom API key (returns null if not set)
  Future<String?> getCustomApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyApiKey);
  }

  /// Save custom API key
  Future<bool> saveApiKey(String apiKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyApiKey, apiKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if using custom API key
  Future<bool> hasCustomApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final customKey = prefs.getString(_keyApiKey);
    return customKey?.isNotEmpty == true;
  }

  /// Remove custom API key (revert to default)
  Future<bool> removeCustomApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyApiKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get default API key
  String getDefaultApiKey() {
    return _defaultApiKey;
  }

  /// Validate API key format (basic validation)
  bool isValidApiKey(String apiKey) {
    // Basic validation: should start with 'AIzaSy' and be at least 39 characters
    return apiKey.startsWith('AIzaSy') && apiKey.length >= 39;
  }
}