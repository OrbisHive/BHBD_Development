/// API Endpoints Configuration
/// 
/// This file contains endpoints for your custom backend APIs.
/// Note: OTP authentication is handled by your custom backend, not Shopify.
/// Shopify Storefront API is configured separately in shopify_api/config/shopify_config.dart
class ApisEndPoints {
  // Your custom backend base URL
  // Example: "https://api.yourdomain.com" or "http://localhost:3000"
  static String baseUrl = "";

  // Auth-related endpoints (Custom Backend - OTP Flow)
  // These endpoints are for your custom authentication backend
  // Shopify doesn't have built-in OTP, so you'll need to implement this separately
  static String sendOtp = "$baseUrl/auth/send-otp";
  static String verifyOtp = "$baseUrl/auth/verify-otp";
  
  // Note: After OTP verification, you may want to link the user to a Shopify customer
  // Use Shopify CustomerService for that integration
}