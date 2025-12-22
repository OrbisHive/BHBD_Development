# Shopify API Implementation Guide

## Step-by-Step Integration

### 1. Add Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
  shared_preferences: ^2.2.2
```

Then run:
```bash
flutter pub get
```

### 2. Configure Shopify Store

Edit `lib/shopify_api/config/shopify_config.dart`:

```dart
static const String storeDomain = 'your-shop.myshopify.com';
static const String storefrontAccessToken = 'your-storefront-access-token';
```

**How to get Storefront Access Token:**
1. Go to Shopify Admin > Settings > Apps and sales channels
2. Click "Develop apps" > Create an app
3. Configure Admin API scopes (if needed)
4. Go to "API credentials" tab
5. Under "Storefront API access token", click "Install app"
6. Copy the Storefront API access token

### 3. Initialize Services

In your app initialization (e.g., `main.dart` or a service locator):

```dart
import 'package:bhbd_project/shopify_api/services/shopify_client.dart';
import 'package:bhbd_project/shopify_api/services/product_service.dart';
import 'package:bhbd_project/shopify_api/services/collection_service.dart';
import 'package:bhbd_project/shopify_api/services/cart_service.dart';
import 'package:bhbd_project/shopify_api/services/customer_service.dart';

// Initialize client
final shopifyClient = ShopifyClient();
await shopifyClient.initialize();

// Create services
final productService = ProductService(shopifyClient);
final collectionService = CollectionService(shopifyClient);
final cartService = CartService(shopifyClient);
final customerService = CustomerService(shopifyClient);
```

### 4. Fetch Products

#### Get Products List

```dart
try {
  final result = await productService.getProducts(
    first: 20,
    sortKey: ProductSortKeys.bestSelling,
  );
  
  for (var product in result.products) {
    print('Product: ${product.title}');
    print('Price: ${product.priceRange?.minVariantPrice.formatted}');
  }
  
  // Load more if available
  if (result.hasNextPage) {
    final nextResult = await productService.getProducts(
      first: 20,
      after: result.endCursor,
    );
  }
} on ShopifyException catch (e) {
  print('Error: ${e.message}');
}
```

#### Get Product Details

```dart
try {
  final product = await productService.getProductByHandle('product-handle');
  
  print('Product: ${product.title}');
  print('Description: ${product.description}');
  print('Variants: ${product.variants.length}');
  
  for (var variant in product.variants) {
    print('Variant: ${variant.title} - ${variant.price.formatted}');
  }
} on ShopifyException catch (e) {
  print('Error: ${e.message}');
}
```

#### Search Products

```dart
try {
  final result = await productService.searchProducts(
    query: 'shirt',
    first: 20,
  );
  
  // Display results
} on ShopifyException catch (e) {
  print('Error: ${e.message}');
}
```

### 5. Fetch Collections

```dart
try {
  // Get all collections
  final collectionsResult = await collectionService.getCollections(first: 20);
  
  for (var collection in collectionsResult.collections) {
    print('Collection: ${collection.title}');
  }
  
  // Get collection with products
  final collectionWithProducts = await collectionService.getCollectionWithProducts(
    handle: 'featured',
    productsFirst: 20,
  );
  
  print('Collection: ${collectionWithProducts.collection.title}');
  print('Products: ${collectionWithProducts.products.length}');
} on ShopifyException catch (e) {
  print('Error: ${e.message}');
}
```

### 6. Cart Operations

#### Create Cart and Add Items

```dart
try {
  // Create cart
  final cart = await cartService.createCart();
  print('Cart ID: ${cart.id}');
  
  // Add item to cart
  final updatedCart = await cartService.addToCart(
    lines: [
      CartLineInput(
        merchandiseId: 'variant-id-here', // Get from product variant
        quantity: 1,
      ),
    ],
  );
  
  print('Cart total: ${updatedCart.totalAmount.formatted}');
  print('Items: ${updatedCart.totalQuantity}');
} on ShopifyException catch (e) {
  print('Error: ${e.message}');
}
```

#### Get Current Cart

```dart
try {
  final cart = await cartService.getCurrentCart();
  
  for (var line in cart.lines) {
    print('Item: ${line.productTitle} x ${line.quantity}');
  }
} on ShopifyException catch (e) {
  print('Error: ${e.message}');
}
```

#### Update Cart

```dart
try {
  // Update quantity
  final updatedCart = await cartService.updateCartLines(
    lines: [
      CartLineUpdateInput(
        id: 'cart-line-id',
        quantity: 2, // Update quantity
      ),
    ],
  );
  
  // Remove item (set quantity to 0)
  final cartAfterRemove = await cartService.updateCartLines(
    lines: [
      CartLineUpdateInput(
        id: 'cart-line-id',
        quantity: 0,
      ),
    ],
  );
} on ShopifyException catch (e) {
  print('Error: ${e.message}');
}
```

#### Checkout

```dart
try {
  // Get cart with checkout URL
  final cart = await cartService.getCurrentCart();
  
  // Redirect to checkout
  // For web: launchUrl(Uri.parse(cart.checkoutUrl));
  // For mobile: Use WebView or redirect to browser
} on ShopifyException catch (e) {
  print('Error: ${e.message}');
}
```

### 7. Customer Operations

#### Link App User to Shopify Customer

```dart
// After user signs up in your app (using your authentication system)
// Example: Get user email and name from your auth system
final userEmail = 'user@example.com'; // From your auth system
final userName = 'John Doe'; // From your auth system

try {
  // Create customer in Shopify
  final customerResult = await customerService.createCustomer(
    email: userEmail,
    password: 'secure-password', // Generate or ask user
    firstName: userName.split(' ').first,
    lastName: userName.split(' ').last,
  );
  
  print('Customer created: ${customerResult.customer.id}');
  
  // Login to get access token
  final loginResult = await customerService.login(
    email: userEmail,
    password: 'secure-password',
  );
  
  print('Customer logged in: ${loginResult.customer.email}');
} on ShopifyException catch (e) {
  if (e.code == 'CUSTOMER_ERROR') {
    // Customer might already exist, try login
    final loginResult = await customerService.login(
      email: userEmail,
      password: 'secure-password',
    );
  }
}
```

#### Get Customer Orders

```dart
try {
  final ordersResult = await customerService.getCustomerOrders(first: 10);
  
  for (var order in ordersResult.orders) {
    print('Order: ${order.name}');
    print('Total: ${order.totalPrice.formatted}');
    print('Status: ${order.fulfillmentStatus}');
  }
} on ShopifyException catch (e) {
  print('Error: ${e.message}');
}
```

### 8. Error Handling

```dart
try {
  // Your API call
} on ShopifyException catch (e) {
  switch (e.code) {
    case 'MAX_COMPLEXITY_EXCEEDED':
      // Reduce query complexity or use access token
      break;
    case 'ACCESS_DENIED':
      // Check access token
      break;
    case 'THROTTLED':
      // Retry with exponential backoff
      break;
    case 'CART_NOT_FOUND':
      // Create new cart
      break;
    case 'NOT_AUTHENTICATED':
      // Redirect to login
      break;
    default:
      // Show generic error
      showError(e.message);
  }
} catch (e) {
  // Handle unexpected errors
  print('Unexpected error: $e');
}
```

### 9. Best Practices

#### Never Cache Product Data

```dart
// ❌ DON'T DO THIS
final cachedProducts = await getCachedProducts();
if (cachedProducts.isEmpty) {
  final products = await productService.getProducts();
  await cacheProducts(products);
}

// ✅ DO THIS
final products = await productService.getProducts();
// Always fetch fresh from Shopify
```

#### Cache Only What's Safe

```dart
// ✅ OK to cache
- Collection metadata (handles, titles) - short TTL
- Product images - use cached_network_image package
- Cart ID - session-based only

// ❌ NEVER cache
- Product prices
- Inventory levels
- Product availability
- Customer-specific pricing
```

#### Use Pagination

```dart
// ✅ Load products in batches
Future<List<ProductModel>> loadAllProducts() async {
  final allProducts = <ProductModel>[];
  String? cursor;
  
  do {
    final result = await productService.getProducts(
      first: 50,
      after: cursor,
    );
    
    allProducts.addAll(result.products);
    cursor = result.hasNextPage ? result.endCursor : null;
  } while (cursor != null);
  
  return allProducts;
}
```

### 10. Integration with Your Flutter App

#### Example: Product List Screen

```dart
class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final productService = ProductService(ShopifyClient());
  List<ProductModel> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await productService.getProducts(first: 20);
      setState(() {
        products = result.products;
        isLoading = false;
      });
    } on ShopifyException catch (e) {
      setState(() {
        error = e.message;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    }

    if (error != null) {
      return Text('Error: $error');
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: product.featuredImageUrl != null
              ? Image.network(product.featuredImageUrl!)
              : null,
          title: Text(product.title),
          subtitle: Text(product.priceRange?.minVariantPrice.formatted ?? ''),
          onTap: () {
            // Navigate to product detail
          },
        );
      },
    );
  }
}
```

## Summary

1. ✅ Configure Shopify store domain and access token
2. ✅ Initialize ShopifyClient and services
3. ✅ Fetch products using ProductService
4. ✅ Fetch collections using CollectionService
5. ✅ Manage cart using CartService
6. ✅ Link users to customers using CustomerService
7. ✅ Always fetch fresh product data from Shopify
8. ✅ Never cache prices, inventory, or availability
9. ✅ Use pagination for large lists
10. ✅ Handle errors gracefully

## Next Steps

- Review `ARCHITECTURE.md` for detailed architecture decisions
- Check `README.md` for overview
- Review GraphQL queries in `queries/` folder
- Customize services as needed for your app

