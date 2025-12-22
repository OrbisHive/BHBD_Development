# Shopify API Integration Architecture

## Table of Contents
1. [API Selection Guide](#api-selection-guide)
2. [Authentication Strategy](#authentication-strategy)
3. [User-Customer Mapping](#user-customer-mapping)
4. [Data Flow Architecture](#data-flow-architecture)
5. [Caching Strategy](#caching-strategy)
6. [Error Handling](#error-handling)

## API Selection Guide

### When to Use Storefront API ✅

**Always use Storefront API for:**
- Product listings and details
- Collection browsing
- Cart operations (create, update, delete)
- Checkout creation
- Customer account operations
- Product search
- Pages, blogs, articles

**Why Storefront API?**
- Handles product visibility automatically
- Respects pricing rules and discounts
- Supports customer-specific pricing
- Designed for customer-facing operations
- No rate limits (only complexity limits for tokenless)

### When to Use Admin API ⚠️

**Only use Admin API for:**
- Creating orders programmatically (if not using Storefront checkout)
- Webhook subscriptions
- Extended metadata operations
- Server-side inventory management
- Bulk operations

**Why Admin API sparingly?**
- Requires OAuth authentication
- Has strict rate limits
- Designed for backend/admin operations
- More complex setup

## Authentication Strategy

### 1. Tokenless Access (Public)

**Use for:**
- Public product browsing
- Collection viewing
- Cart operations (anonymous)
- Search

**Implementation:**
```dart
// No authentication header needed
final response = await http.post(
  Uri.parse('https://your-shop.myshopify.com/api/2025-10/graphql.json'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({'query': query}),
);
```

**Limitations:**
- Query complexity limit: 1,000
- No access to customer data
- No access to product tags
- No access to metaobjects

### 2. Token-Based Access (Private)

**Use for:**
- Customer account operations
- Customer-specific product access
- Product tags
- Metaobjects and metafields

**Implementation:**
```dart
final response = await http.post(
  Uri.parse('https://your-shop.myshopify.com/api/2025-10/graphql.json'),
  headers: {
    'Content-Type': 'application/json',
    'X-Shopify-Storefront-Access-Token': storefrontAccessToken,
  },
  body: jsonEncode({'query': query}),
);
```

**Token Types:**
- **Public Access Token**: For browser/mobile apps
- **Private Access Token**: For server-side operations

## User-Customer Mapping

### Strategy: Link App Users to Shopify Customers

**Approach 1: Email-Based Mapping (Recommended)**
1. User signs up in your app (using your authentication system)
2. Create/retrieve Shopify customer using email
3. Store mapping: `appUserId -> shopifyCustomerId`
4. Use customer access token for authenticated requests

**Implementation Flow:**
```
App User (Your Auth System) 
  ↓ (email match)
Shopify Customer
  ↓ (customerAccessToken)
Authenticated Storefront API calls
```

**Code Example:**
```dart
// 1. User signs up in app (using your authentication system)
final userEmail = 'user@example.com'; // From your auth system
final userName = 'John Doe'; // From your auth system

// 2. Create or retrieve Shopify customer
final customer = await customerService.createCustomer(
  email: userEmail,
  firstName: userName.split(' ').first,
  lastName: userName.split(' ').last,
);

// 3. Store mapping locally
await storage.write(key: 'shopify_customer_id', value: customer.id);
```

**Approach 2: Customer Access Token**
- Use Shopify's customer access token system
- More secure but requires additional flow
- Better for production apps

## Data Flow Architecture

### Product Listing Flow

```
User opens product list
  ↓
App calls ProductService.getProducts()
  ↓
ShopifyClient executes GraphQL query
  ↓
Storefront API returns products
  ↓
Parse response to ProductModel
  ↓
Display in UI
```

**Key Points:**
- No local database for products
- Always fetch from Shopify
- Cache images only (with proper headers)

### Product Detail Flow

```
User taps product
  ↓
App calls ProductService.getProductByHandle(handle)
  ↓
ShopifyClient executes GraphQL query
  ↓
Storefront API returns full product details
  ↓
Parse and display
```

### Cart Flow

```
User adds product to cart
  ↓
App calls CartService.createCart() or addToCart()
  ↓
Storefront API creates/updates cart
  ↓
Returns cart with checkoutUrl
  ↓
Store cartId locally (session-based)
  ↓
User proceeds to checkout
```

### Checkout Flow

```
User clicks checkout
  ↓
App calls CheckoutService.createCheckout(cartId)
  ↓
Storefront API creates checkout
  ↓
Redirect to checkoutUrl (web) or use checkout API
  ↓
Complete payment
  ↓
Order created automatically
```

## Caching Strategy

### What to Cache ✅

**1. Product Images**
- Cache with HTTP cache headers
- Use Flutter's `cached_network_image` package
- TTL: Respect Shopify's cache headers

**2. Collection Metadata**
- Cache collection list (5-10 minutes)
- Cache collection handles only
- Never cache product data within collections

**3. Cart State**
- Store cartId in local storage (session-based)
- Cache cart items for offline viewing
- Always sync with Shopify before checkout

### What NOT to Cache ❌

**1. Product Prices**
- Always fetch fresh prices
- Prices can change based on:
  - Customer-specific pricing
  - Discounts
  - Currency conversion
  - Time-based promotions

**2. Inventory Levels**
- Always fetch real-time inventory
- Critical for preventing overselling

**3. Product Availability**
- Always check availability from Shopify
- Depends on inventory, variants, etc.

**4. Customer-Specific Data**
- Customer pricing
- Customer tags
- Customer metafields

### Caching Implementation

```dart
class CacheManager {
  // Cache collection handles only
  static Future<List<String>> getCachedCollections() async {
    // Return cached collection handles
    // Always validate with fresh API call
  }
  
  // Never cache product data
  // Always fetch from Shopify
}
```

## Error Handling

### Common Errors

**1. Complexity Exceeded (Tokenless)**
- Error: `MAX_COMPLEXITY_EXCEEDED`
- Solution: Reduce query complexity or use access token

**2. Access Denied**
- Error: `ACCESS_DENIED`
- Solution: Check access token validity

**3. Throttled**
- Error: `THROTTLED`
- Solution: Implement exponential backoff

**4. Shop Inactive**
- Error: `SHOP_INACTIVE`
- Solution: Contact shop owner

### Error Handling Strategy

```dart
try {
  final products = await productService.getProducts();
} on ShopifyException catch (e) {
  switch (e.code) {
    case 'MAX_COMPLEXITY_EXCEEDED':
      // Reduce query complexity
      break;
    case 'ACCESS_DENIED':
      // Refresh access token
      break;
    case 'THROTTLED':
      // Retry with backoff
      break;
    default:
      // Show user-friendly error
  }
}
```

## Best Practices

### 1. Always Use Storefront API for Customer Operations
- Don't use Admin API for customer-facing features
- Storefront API handles permissions automatically

### 2. Never Store Product Data
- Products, prices, inventory should always come from Shopify
- Use local storage only for cart state and user preferences

### 3. Implement Proper Error Handling
- Handle network errors gracefully
- Show user-friendly messages
- Log errors for debugging

### 4. Use GraphQL Efficiently
- Request only needed fields
- Use pagination for large lists
- Batch related queries when possible

### 5. Respect Rate Limits
- Implement request queuing
- Use exponential backoff
- Monitor query complexity

## Integration Checklist

- [ ] Configure Shopify store domain and access token
- [ ] Implement ShopifyClient with proper error handling
- [ ] Create service classes for each entity type
- [ ] Implement user-customer mapping
- [ ] Set up proper caching strategy
- [ ] Implement cart persistence
- [ ] Set up checkout flow
- [ ] Add error handling and retry logic
- [ ] Test with different user scenarios
- [ ] Monitor API usage and performance

