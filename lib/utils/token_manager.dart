import 'package:shared_preferences/shared_preferences.dart';

/// Token Manager
/// 
/// Centralized token storage and retrieval for authentication.
/// Handles both custom backend auth tokens and Shopify customer tokens.
class TokenManager {
  static const String _authTokenKey = 'auth_token';
  static const String _shopifyCustomerTokenKey = 'shopify_customer_token';
  static const String _userEmailKey = 'user_email';

  /// Save authentication token (from your custom backend)
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  /// Get authentication token (from your custom backend)
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  /// Save Shopify customer access token
  static Future<void> saveShopifyCustomerToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopifyCustomerTokenKey, token);
  }

  /// Get Shopify customer access token
  static Future<String?> getShopifyCustomerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shopifyCustomerTokenKey);
  }

  /// Save user email
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  /// Get user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  /// Check if user is authenticated (has auth token)
  static Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all tokens and user data (logout)
  static Future<void> clearAllTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_shopifyCustomerTokenKey);
    await prefs.remove(_userEmailKey);
  }

  /// Clear only auth token (keep Shopify token if needed)
  static Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  /// Clear only Shopify customer token
  static Future<void> clearShopifyCustomerToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_shopifyCustomerTokenKey);
  }
}

