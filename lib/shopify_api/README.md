# Shopify Storefront API Integration Guide

## Overview

This integration provides a complete solution for connecting your Flutter app to Shopify's Storefront API. The architecture is designed to:
- Fetch products and collections dynamically from Shopify
- Avoid duplicating product data in local databases
- Connect app users with Shopify customers
- Use Storefront API as primary, Admin API only when necessary

## Architecture Principles

### 1. **No Product Data Duplication**
- **NEVER store** product details, prices, inventory, or variants locally
- Always fetch product data from Shopify in real-time
- Cache only for performance (with short TTL), never as source of truth

### 2. **Storefront API First**
- Use Storefront API for all customer-facing operations
- Storefront API handles product visibility, pricing, and access rules automatically
- Supports both tokenless and token-based access

### 3. **Admin API for Backend Operations Only**
- Use Admin API only for:
  - Creating orders (if Storefront checkout isn't used)
  - Webhook subscriptions
  - Extended metadata operations
  - Server-side operations

## Folder Structure

```
lib/shopify_api/
├── README.md (this file)
├── ARCHITECTURE.md (detailed architecture guide)
├── config/
│   └── shopify_config.dart (API configuration)
├── queries/
│   ├── products_queries.dart (product listing & details)
│   ├── collections_queries.dart (collections)
│   ├── cart_queries.dart (cart operations)
│   ├── checkout_queries.dart (checkout operations)
│   └── customer_queries.dart (customer operations)
├── services/
│   ├── shopify_client.dart (main API client)
│   ├── product_service.dart (product operations)
│   ├── collection_service.dart (collection operations)
│   ├── cart_service.dart (cart operations)
│   ├── checkout_service.dart (checkout operations)
│   └── customer_service.dart (customer operations)
├── models/
│   ├── product_model.dart
│   ├── collection_model.dart
│   ├── cart_model.dart
│   ├── checkout_model.dart
│   └── customer_model.dart
└── utils/
    └── graphql_helper.dart (GraphQL utilities)
```

## Quick Start

1. **Configure your Shopify store** in `config/shopify_config.dart`
2. **Initialize the client** in your app:
   ```dart
   final shopifyClient = ShopifyClient();
   await shopifyClient.initialize();
   ```
3. **Use services** to fetch data:
   ```dart
   final productService = ProductService(shopifyClient);
   final products = await productService.getProducts(first: 20);
   ```

## Authentication

### Tokenless Access (Public)
- Works for: Products, Collections, Cart (read/write), Search
- Query complexity limit: 1,000
- No authentication required

### Token-Based Access (Private)
- Required for: Customer data, Product tags, Metaobjects, Menu
- Use Storefront Access Token
- Supports both public and private tokens

## Data Caching Strategy

### What to Cache (Short TTL)
- Product images (with cache headers)
- Collection metadata (5-10 minutes)
- Cart state (session-based)

### What NOT to Cache
- Product prices
- Inventory levels
- Product availability
- Customer-specific pricing

## API Endpoints

### Storefront API
- Base URL: `https://{shop}.myshopify.com/api/{version}/graphql.json`
- Version: `2025-10` (or latest)
- Method: POST (GraphQL)

### Admin API (when needed)
- Base URL: `https://{shop}.myshopify.com/admin/api/{version}/`
- Use only for backend operations

## Next Steps

1. Read `ARCHITECTURE.md` for detailed implementation guide
2. Review GraphQL queries in `queries/` folder
3. Check service examples in `services/` folder
4. Integrate services into your Flutter app

