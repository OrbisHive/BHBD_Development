/// Shopify API Configuration
/// 
/// Configure your Shopify store details here.
/// 
/// To get your Storefront Access Token:
/// 1. Go to Shopify Admin > Settings > Apps and sales channels
/// 2. Click "Develop apps" > Create an app
/// 3. Configure Admin API scopes (if needed)
/// 4. Go to "API credentials" tab
/// 5. Under "Storefront API access token", click "Install app"
/// 6. Copy the Storefront API access token
class ShopifyConfig {
  // Your Shopify store domain (e.g., 'your-shop.myshopify.com')
  // Or use custom domain (e.g., 'shop.yourdomain.com')
  static const String storeDomain = 'bhbd.myshopify.com';
  
  // Storefront API version
  // Use latest stable version: 2025-10
  static const String apiVersion = '2025-10';
  
  // Storefront API Access Token
  // Leave empty for tokenless access (limited features)
  // Set for full access to customer data, tags, etc.
  static const String storefrontAccessToken = '';
  
  // Base URL for Storefront API
  static String get storefrontApiUrl {
    return 'https://$storeDomain/api/$apiVersion/graphql.json';
  }
  
  // Admin API URL (only if needed for backend operations)
  static String get adminApiUrl {
    return 'https://$storeDomain/admin/api/$apiVersion';
  }
  
  // Enable/disable tokenless access
  // If true, will use tokenless access when token is empty
  static const bool allowTokenlessAccess = true;
  
  // Query complexity limit for tokenless access
  static const int tokenlessComplexityLimit = 1000;
  
  // Request timeout in seconds
  static const int requestTimeoutSeconds = 30;
  
  // Enable request logging (for debugging)
  static const bool enableLogging = true;
  
  // Cache settings
  static const Duration collectionCacheTTL = Duration(minutes: 10);
  static const Duration imageCacheTTL = Duration(days: 7);
}

