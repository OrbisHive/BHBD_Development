/// GraphQL Queries for Collections
/// 
/// Collections group products together in Shopify.
/// These queries fetch collection metadata and products within collections.

class CollectionQueries {
  /// Get all collections with pagination
  /// 
  /// Returns collection metadata only (not products).
  /// Use getProductsByCollection() to fetch products within a collection.
  /// 
  /// Query complexity: ~20-30 per collection
  static String getCollections({
    int first = 20,
    String? after,
    String? query,
    String? sortKey,
    bool reverse = false,
  }) {
    final cursor = after != null ? ', after: "$after"' : '';
    final queryFilter = query != null ? ', query: "$query"' : '';
    final sortKeyParam = sortKey != null ? ', sortKey: $sortKey' : '';
    final reverseParam = reverse ? ', reverse: true' : '';

    return '''
      query GetCollections {
        collections(
          first: $first$cursor$queryFilter$sortKeyParam$reverseParam
        ) {
          edges {
            node {
              id
              title
              handle
              description
              descriptionHtml
              image {
                id
                url
                altText
                width
                height
              }
              updatedAt
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

  /// Get single collection by handle
  /// 
  /// Returns collection metadata.
  /// Query complexity: ~20-30
  static String getCollectionByHandle(String handle) {
    return '''
      query GetCollectionByHandle {
        collection(handle: "$handle") {
          id
          title
          handle
          description
          descriptionHtml
          image {
            id
            url
            altText
            width
            height
          }
          updatedAt
          seo {
            title
            description
          }
        }
      }
    ''';
  }

  /// Get collection by ID
  /// 
  /// Use when you have the collection ID (GID format).
  /// Query complexity: ~20-30
  static String getCollectionById(String collectionId) {
    return '''
      query GetCollectionById {
        collection(id: "$collectionId") {
          id
          title
          handle
          description
          descriptionHtml
          image {
            id
            url
            altText
          }
          updatedAt
        }
      }
    ''';
  }

  /// Get collection with products
  /// 
  /// Returns collection metadata along with products.
  /// Use pagination to fetch products in batches.
  /// 
  /// Query complexity: ~20-30 (collection) + ~50-100 per product
  static String getCollectionWithProducts({
    required String handle,
    int productsFirst = 20,
    String? productsAfter,
    String? sortKey,
    bool reverse = false,
  }) {
    final cursor = productsAfter != null ? ', after: "$productsAfter"' : '';
    final sortKeyParam = sortKey != null ? ', sortKey: $sortKey' : '';
    final reverseParam = reverse ? ', reverse: true' : '';

    return '''
      query GetCollectionWithProducts {
        collection(handle: "$handle") {
          id
          title
          handle
          description
          descriptionHtml
          image {
            id
            url
            altText
          }
          products(
            first: $productsFirst$cursor$sortKeyParam$reverseParam
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

/// Sort keys for collection queries
class CollectionSortKeys {
  static const String title = 'TITLE';
  static const String updatedAt = 'UPDATED_AT';
  static const String id = 'ID';
  static const String relevance = 'RELEVANCE';
}

