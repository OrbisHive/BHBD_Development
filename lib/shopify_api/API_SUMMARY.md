# Shopify API Integration Summary

## Quick Reference

### API Endpoints

#### Storefront API (Primary)
- **Base URL**: `https://{shop}.myshopify.com/api/{version}/graphql.json`
- **Version**: `2025-10` (latest stable)
- **Method**: POST (GraphQL)
- **Authentication**: Optional (tokenless or token-based)

#### Admin API (Backend Only)
- **Base URL**: `https://{shop}.myshopify.com/admin/api/{version}/`
- **Use Cases**: Order creation, webhooks, extended metadata
- **Authentication**: OAuth required

### Key GraphQL Queries

#### Products
- `products` - List products with pagination
- `product(handle: "...")` - Get product by handle
- `product(id: "...")` - Get product by ID

#### Collections
- `collections` - List collections
- `collection(handle: "...")` - Get collection by handle

#### Cart
- `cartCreate` - Create new cart
- `cart(id: "...")` - Get cart by ID
- `cartLinesAdd` - Add items to cart
- `cartLinesUpdate` - Update cart items
- `cartLinesRemove` - Remove items from cart

#### Customer
- `customerCreate` - Create customer account
- `customerAccessTokenCreate` - Customer login
- `customer(customerAccessToken: "...")` - Get customer details
- `customerUpdate` - Update customer info

### Service Classes

| Service | Purpose | Key Methods |
|---------|---------|-------------|
| `ProductService` | Product operations | `getProducts()`, `getProductByHandle()`, `searchProducts()` |
| `CollectionService` | Collection operations | `getCollections()`, `getCollectionWithProducts()` |
| `CartService` | Cart management | `createCart()`, `addToCart()`, `getCurrentCart()` |
| `CustomerService` | Customer operations | `createCustomer()`, `login()`, `getCustomerOrders()` |

### Data Models

| Model | Purpose | Cacheable? |
|-------|---------|------------|
| `ProductModel` | Product data | ❌ Never |
| `CollectionModel` | Collection metadata | ✅ Metadata only (short TTL) |
| `CartModel` | Cart state | ✅ Cart ID only (session-based) |
| `CustomerModel` | Customer data | ❌ Never |

### What to Cache vs. What NOT to Cache

#### ✅ Safe to Cache
- Collection handles and titles (5-10 min TTL)
- Product images (with HTTP cache headers)
- Cart ID (session-based only)
- User preferences

#### ❌ Never Cache
- Product prices
- Inventory levels
- Product availability
- Customer-specific pricing
- Product descriptions/details
- Variant data

### Authentication Flow

#### Tokenless Access (Public)
```
No authentication required
↓
Query products, collections, cart
↓
Query complexity limit: 1,000
```

#### Token-Based Access (Private)
```
Storefront Access Token
↓
Full access to customer data, tags, metaobjects
↓
No query complexity limit
```

#### Customer Authentication
```
Customer Login
↓
Customer Access Token
↓
Access customer orders, account info
```

### Common Operations

#### Fetch Products
```dart
final productService = ProductService(shopifyClient);
final result = await productService.getProducts(first: 20);
```

#### Add to Cart
```dart
final cartService = CartService(shopifyClient);
final cart = await cartService.addToCart(
  lines: [CartLineInput(merchandiseId: variantId, quantity: 1)],
);
```

#### Link User to Customer
```dart
final customerService = CustomerService(shopifyClient);
final result = await customerService.createCustomer(
  email: userEmail,
  password: password,
);
```

### Error Codes

| Code | Meaning | Solution |
|------|---------|----------|
| `MAX_COMPLEXITY_EXCEEDED` | Query too complex | Reduce query or use access token |
| `ACCESS_DENIED` | Invalid/missing token | Check access token |
| `THROTTLED` | Rate limited | Retry with backoff |
| `CART_NOT_FOUND` | Cart expired | Create new cart |
| `NOT_AUTHENTICATED` | No customer token | Login customer |

### Best Practices

1. **Always fetch fresh product data** - Never store products locally
2. **Use pagination** - Load products in batches (20-50 at a time)
3. **Handle errors gracefully** - Show user-friendly messages
4. **Store cart ID only** - Never cache cart contents
5. **Use tokenless access when possible** - Reduces complexity
6. **Link users to customers** - Use email-based mapping
7. **Respect rate limits** - Implement retry logic with backoff

### File Structure

```
lib/shopify_api/
├── README.md                    # Overview
├── ARCHITECTURE.md              # Detailed architecture
├── IMPLEMENTATION_GUIDE.md      # Step-by-step guide
├── API_SUMMARY.md              # This file
├── config/
│   └── shopify_config.dart      # Configuration
├── queries/
│   ├── products_queries.dart    # Product queries
│   ├── collections_queries.dart # Collection queries
│   ├── cart_queries.dart        # Cart queries
│   ├── checkout_queries.dart    # Checkout queries
│   └── customer_queries.dart     # Customer queries
├── services/
│   ├── shopify_client.dart      # Main API client
│   ├── product_service.dart     # Product service
│   ├── collection_service.dart  # Collection service
│   ├── cart_service.dart        # Cart service
│   └── customer_service.dart    # Customer service
├── models/
│   ├── product_model.dart       # Product model
│   ├── collection_model.dart    # Collection model
│   ├── cart_model.dart          # Cart model
│   └── customer_model.dart      # Customer model
└── utils/
    └── graphql_helper.dart      # GraphQL utilities
```

### Next Steps

1. Configure `shopify_config.dart` with your store details
2. Add dependencies: `http` and `shared_preferences`
3. Initialize services in your app
4. Start using services to fetch data
5. Review `IMPLEMENTATION_GUIDE.md` for detailed examples

