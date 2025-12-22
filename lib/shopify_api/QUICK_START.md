# Shopify API Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Add Dependencies

The required dependencies have been added to `pubspec.yaml`:
- `http: ^1.1.0` - For API calls
- `shared_preferences: ^2.2.2` - For local storage

Run:
```bash
flutter pub get
```

### Step 2: Configure Your Store

Edit `lib/shopify_api/config/shopify_config.dart`:

```dart
static const String storeDomain = 'your-shop.myshopify.com';
static const String storefrontAccessToken = 'your-token-here';
```

**Get your Storefront Access Token:**
1. Shopify Admin → Settings → Apps and sales channels
2. Click "Develop apps" → Create an app
3. Go to "API credentials" tab
4. Under "Storefront API access token", click "Install app"
5. Copy the token

### Step 3: Initialize Services

In your app (e.g., `main.dart` or service locator):

```dart
import 'package:bhbd_project/shopify_api/services/shopify_client.dart';
import 'package:bhbd_project/shopify_api/services/product_service.dart';
import 'package:bhbd_project/shopify_api/services/cart_service.dart';

// Initialize
final shopifyClient = ShopifyClient();
await shopifyClient.initialize();

// Create services
final productService = ProductService(shopifyClient);
final cartService = CartService(shopifyClient);
```

### Step 4: Fetch Products

```dart
// Get products list
final result = await productService.getProducts(first: 20);

// Display products
for (var product in result.products) {
  print('${product.title} - ${product.priceRange?.minVariantPrice.formatted}');
}

// Get product details
final product = await productService.getProductByHandle('product-handle');
print('Description: ${product.description}');
```

### Step 5: Add to Cart

```dart
// Add item to cart
final cart = await cartService.addToCart(
  lines: [
    CartLineInput(
      merchandiseId: 'variant-id', // From product variant
      quantity: 1,
    ),
  ],
);

// Get checkout URL
print('Checkout: ${cart.checkoutUrl}');
```

## 📚 Documentation Files

- **README.md** - Overview and folder structure
- **ARCHITECTURE.md** - Detailed architecture decisions
- **IMPLEMENTATION_GUIDE.md** - Complete implementation examples
- **API_SUMMARY.md** - Quick reference for APIs and services
- **QUICK_START.md** - This file

## 🎯 Key Principles

1. **Never cache product data** - Always fetch from Shopify
2. **Use Storefront API** - Designed for customer-facing operations
3. **Fetch fresh prices** - Prices can change based on customer, discounts, etc.
4. **Store cart ID only** - Never cache cart contents
5. **Link users to customers** - Use email-based mapping

## 🔧 Common Tasks

### Fetch Products
```dart
final products = await productService.getProducts(first: 20);
```

### Search Products
```dart
final results = await productService.searchProducts(query: 'shirt');
```

### Get Collections
```dart
final collections = await collectionService.getCollections(first: 20);
```

### Manage Cart
```dart
// Create cart
final cart = await cartService.createCart();

// Add items
await cartService.addToCart(lines: [/* items */]);

// Get current cart
final currentCart = await cartService.getCurrentCart();
```

### Customer Operations
```dart
// Create customer
await customerService.createCustomer(
  email: 'user@example.com',
  password: 'password',
);

// Login
await customerService.login(
  email: 'user@example.com',
  password: 'password',
);

// Get orders
final orders = await customerService.getCustomerOrders();
```

## ⚠️ Important Notes

- **Product data is never cached** - Always fetch fresh
- **Prices are dynamic** - Fetch from Shopify for accurate pricing
- **Cart ID is session-based** - Store locally but fetch cart contents fresh
- **Use pagination** - Load products in batches (20-50 at a time)
- **Handle errors** - Implement proper error handling for network issues

## 🆘 Need Help?

1. Check `IMPLEMENTATION_GUIDE.md` for detailed examples
2. Review `ARCHITECTURE.md` for design decisions
3. See `API_SUMMARY.md` for quick reference
4. Review GraphQL queries in `queries/` folder

## ✅ Checklist

- [ ] Dependencies added (`http`, `shared_preferences`)
- [ ] Store domain configured
- [ ] Storefront access token set
- [ ] Services initialized
- [ ] First API call successful
- [ ] Error handling implemented
- [ ] Products displaying correctly
- [ ] Cart functionality working

## 🎉 You're Ready!

Your Shopify API integration is set up and ready to use. Start by fetching products and building your UI. Remember to always fetch fresh data from Shopify!

