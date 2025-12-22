/// GraphQL Queries for Products
/// 
/// These queries are optimized for Storefront API usage.
/// They request only necessary fields to minimize query complexity.

class ProductQueries {
  /// Get products list with pagination
  /// 
  /// Fields included:
  /// - Basic product info (id, title, handle, description)
  /// - Featured image
  /// - Price range
  /// - Variants (for availability)
  /// 
  /// Query complexity: ~50-100 per product
  static String getProducts({
    int first = 20,
    String? after,
    String? query,
    List<String>? productTypes,
    List<String>? tags,
    String? sortKey,
    bool reverse = false,
  }) {
    final cursor = after != null ? ', after: "$after"' : '';
    final queryFilter = query != null ? ', query: "$query"' : '';
    final productTypesFilter = productTypes != null && productTypes.isNotEmpty
        ? ', productTypes: ${productTypes.map((t) => '"$t"').toList()}'
        : '';
    final tagsFilter = tags != null && tags.isNotEmpty
        ? ', tags: ${tags.map((t) => '"$t"').toList()}'
        : '';
    final sortKeyParam = sortKey != null ? ', sortKey: $sortKey' : '';
    final reverseParam = reverse ? ', reverse: true' : '';

    return '''
      query GetProducts {
        products(
          first: $first$cursor$queryFilter$productTypesFilter$tagsFilter$sortKeyParam$reverseParam
        ) {
          edges {
            node {
              id
              title
              handle
              description
              descriptionHtml
              vendor
              productType
              tags
              createdAt
              updatedAt
              featuredImage {
                id
                url
                altText
                width
                height
              }
              priceRange {
                minVariantPrice {
                  amount
                  currencyCode
                }
                maxVariantPrice {
                  amount
                  currencyCode
                }
              }
              variants(first: 1) {
                edges {
                  node {
                    id
                    availableForSale
                    quantityAvailable
                  }
                }
              }
            }
            cursor
          }
          pageInfo {
            hasNextPage
            hasPreviousPage
            startCursor
            endCursor
          }
        }
      }
    ''';
  }

  /// Get single product by handle
  /// 
  /// This is the recommended way to fetch product details.
  /// Handle is URL-friendly and unique.
  /// 
  /// Query complexity: ~200-300
  static String getProductByHandle(String handle) {
    return '''
      query GetProductByHandle {
        product(handle: "$handle") {
          id
          title
          handle
          description
          descriptionHtml
          vendor
          productType
          tags
          createdAt
          updatedAt
          featuredImage {
            id
            url
            altText
            width
            height
          }
          images(first: 10) {
            edges {
              node {
                id
                url
                altText
                width
                height
              }
            }
          }
          priceRange {
            minVariantPrice {
              amount
              currencyCode
            }
            maxVariantPrice {
              amount
              currencyCode
            }
          }
          variants(first: 250) {
            edges {
              node {
                id
                title
                price {
                  amount
                  currencyCode
                }
                availableForSale
                quantityAvailable
                selectedOptions {
                  name
                  value
                }
                image {
                  id
                  url
                  altText
                }
                sku
                barcode
                weight
                weightUnit
              }
            }
          }
          options {
            id
            name
            values
          }
          seo {
            title
            description
          }
          metafields(first: 10) {
            edges {
              node {
                id
                namespace
                key
                value
                type
              }
            }
          }
        }
      }
    ''';
  }

  /// Get product by ID
  /// 
  /// Use this when you have the product ID (GID format).
  /// Query complexity: ~200-300
  static String getProductById(String productId) {
    return '''
      query GetProductById {
        product(id: "$productId") {
          id
          title
          handle
          description
          descriptionHtml
          vendor
          productType
          tags
          featuredImage {
            id
            url
            altText
          }
          images(first: 10) {
            edges {
              node {
                id
                url
                altText
              }
            }
          }
          priceRange {
            minVariantPrice {
              amount
              currencyCode
            }
            maxVariantPrice {
              amount
              currencyCode
            }
          }
          variants(first: 250) {
            edges {
              node {
                id
                title
                price {
                  amount
                  currencyCode
                }
                availableForSale
                quantityAvailable
                selectedOptions {
                  name
                  value
                }
                image {
                  id
                  url
                }
              }
            }
          }
          options {
            id
            name
            values
          }
        }
      }
    ''';
  }

  /// Search products
  /// 
  /// Uses Shopify's search functionality.
  /// Query complexity: ~50-100 per product
  static String searchProducts({
    required String query,
    int first = 20,
    String? after,
    String? sortKey,
    bool reverse = false,
  }) {
    final cursor = after != null ? ', after: "$after"' : '';
    final sortKeyParam = sortKey != null ? ', sortKey: $sortKey' : '';
    final reverseParam = reverse ? ', reverse: true' : '';

    return '''
      query SearchProducts {
        products(
          first: $first$cursor
          query: "$query"$sortKeyParam$reverseParam
        ) {
          edges {
            node {
              id
              title
              handle
              description
              featuredImage {
                id
                url
                altText
              }
              priceRange {
                minVariantPrice {
                  amount
                  currencyCode
                }
              }
              variants(first: 1) {
                edges {
                  node {
                    id
                    availableForSale
                  }
                }
              }
            }
            cursor
          }
          pageInfo {
            hasNextPage
            hasPreviousPage
            startCursor
            endCursor
          }
        }
      }
    ''';
  }

  /// Get products by collection
  /// 
  /// Fetches products within a specific collection.
  /// Query complexity: ~50-100 per product
  static String getProductsByCollection({
    required String collectionHandle,
    int first = 20,
    String? after,
    String? sortKey,
    bool reverse = false,
  }) {
    final cursor = after != null ? ', after: "$after"' : '';
    final sortKeyParam = sortKey != null ? ', sortKey: $sortKey' : '';
    final reverseParam = reverse ? ', reverse: true' : '';

    return '''
      query GetProductsByCollection {
        collection(handle: "$collectionHandle") {
          id
          title
          handle
          description
          products(
            first: $first$cursor$sortKeyParam$reverseParam
          ) {
            edges {
              node {
                id
                title
                handle
                description
                featuredImage {
                  id
                  url
                  altText
                }
                priceRange {
                  minVariantPrice {
                    amount
                    currencyCode
                  }
                }
                variants(first: 1) {
                  edges {
                    node {
                      id
                      availableForSale
                    }
                  }
                }
              }
              cursor
            }
            pageInfo {
              hasNextPage
              hasPreviousPage
              startCursor
              endCursor
            }
          }
        }
      }
    ''';
  }
}

/// Sort keys for product queries
class ProductSortKeys {
  static const String title = 'TITLE';
  static const String price = 'PRICE';
  static const String bestSelling = 'BEST_SELLING';
  static const String createdAt = 'CREATED_AT';
  static const String id = 'ID';
  static const String manual = 'MANUAL';
  static const String productType = 'PRODUCT_TYPE';
  static const String relevance = 'RELEVANCE';
  static const String updatedAt = 'UPDATED_AT';
  static const String vendor = 'VENDOR';
}

