import '../models/collection_model.dart';
import '../models/product_model.dart';
import '../queries/collections_queries.dart';
import '../services/shopify_client.dart';
import '../services/product_service.dart';

/// Collection Service
/// 
/// Handles collection-related operations.
/// Collections can be cached (metadata only), but products within
/// collections should always be fetched fresh.

class CollectionService {
  final ShopifyClient client;
  final ProductService productService;

  CollectionService(this.client) : productService = ProductService(client);

  /// Get all collections
  /// 
  /// [first] - Number of collections (default: 20)
  /// [after] - Cursor for pagination
  /// [query] - Search query
  /// [sortKey] - Sort key (use CollectionSortKeys)
  /// [reverse] - Reverse sort order
  /// 
  /// Returns collections and pagination info
  /// 
  /// NOTE: This returns collection metadata only.
  /// Use getCollectionWithProducts() to get products.
  Future<CollectionListResult> getCollections({
    int first = 20,
    String? after,
    String? query,
    String? sortKey,
    bool reverse = false,
  }) async {
    final queryString = CollectionQueries.getCollections(
      first: first,
      after: after,
      query: query,
      sortKey: sortKey,
      reverse: reverse,
    );

    final response = await client.query(queryString);

    final data = response['data']?['collections'];
    if (data == null) {
      throw ShopifyException('Invalid response format', code: 'INVALID_RESPONSE');
    }

    final edges = data['edges'] as List? ?? [];
    final collections = edges
        .map((edge) => CollectionModel.fromJson(edge))
        .toList()
        .cast<CollectionModel>();

    final pageInfo = data['pageInfo'] ?? {};

    return CollectionListResult(
      collections: collections,
      hasNextPage: pageInfo['hasNextPage'] ?? false,
      hasPreviousPage: pageInfo['hasPreviousPage'] ?? false,
      startCursor: pageInfo['startCursor'],
      endCursor: pageInfo['endCursor'],
    );
  }

  /// Get collection by handle
  /// 
  /// [handle] - Collection handle
  /// 
  /// Returns collection metadata
  Future<CollectionModel> getCollectionByHandle(String handle) async {
    final queryString = CollectionQueries.getCollectionByHandle(handle);

    final response = await client.query(queryString);

    final collectionData = response['data']?['collection'];
    if (collectionData == null) {
      throw ShopifyException('Collection not found', code: 'NOT_FOUND');
    }

    return CollectionModel.fromJson(collectionData);
  }

  /// Get collection by ID
  /// 
  /// [collectionId] - Collection ID (GID format)
  /// 
  /// Returns collection metadata
  Future<CollectionModel> getCollectionById(String collectionId) async {
    final queryString = CollectionQueries.getCollectionById(collectionId);

    final response = await client.query(queryString);

    final collectionData = response['data']?['collection'];
    if (collectionData == null) {
      throw ShopifyException('Collection not found', code: 'NOT_FOUND');
    }

    return CollectionModel.fromJson(collectionData);
  }

  /// Get collection with products
  /// 
  /// [handle] - Collection handle
  /// [productsFirst] - Number of products to fetch
  /// [productsAfter] - Cursor for product pagination
  /// [sortKey] - Sort key for products
  /// [reverse] - Reverse sort order
  /// 
  /// Returns collection with products
  /// 
  /// NOTE: Products are fetched fresh from Shopify.
  /// Only collection metadata can be cached.
  Future<CollectionWithProductsResult> getCollectionWithProducts({
    required String handle,
    int productsFirst = 20,
    String? productsAfter,
    String? sortKey,
    bool reverse = false,
  }) async {
    final queryString = CollectionQueries.getCollectionWithProducts(
      handle: handle,
      productsFirst: productsFirst,
      productsAfter: productsAfter,
      sortKey: sortKey,
      reverse: reverse,
    );

    final response = await client.query(queryString);

    // Better null checking
    if (response['data'] == null) {
      throw ShopifyException('Invalid API response', code: 'INVALID_RESPONSE');
    }

    final collectionData = response['data']?['collection'];
    if (collectionData == null) {
      throw ShopifyException('Collection not found', code: 'NOT_FOUND');
    }
    
    if (collectionData is! Map<String, dynamic>) {
      throw ShopifyException('Invalid collection data format', code: 'INVALID_FORMAT');
    }

    final collection = CollectionModel.fromJson(collectionData);

    // Safely get products data
    final productsData = collectionData['products'];
    if (productsData == null || productsData is! Map<String, dynamic>) {
      // Collection exists but has no products
      return CollectionWithProductsResult(
        collection: collection,
        products: [],
        hasNextPage: false,
        hasPreviousPage: false,
        startCursor: null,
        endCursor: null,
      );
    }

    final edges = productsData['edges'];
    if (edges == null || edges is! List) {
      return CollectionWithProductsResult(
        collection: collection,
        products: [],
        hasNextPage: false,
        hasPreviousPage: false,
        startCursor: null,
        endCursor: null,
      );
    }

    final products = edges
        .map((edge) {
          if (edge is Map<String, dynamic>) {
            return ProductModel.fromJson(edge);
          }
          return null;
        })
        .whereType<ProductModel>()
        .toList();

    final pageInfo = productsData['pageInfo'] is Map<String, dynamic>
        ? productsData['pageInfo'] as Map<String, dynamic>
        : <String, dynamic>{};

    return CollectionWithProductsResult(
      collection: collection,
      products: products,
      hasNextPage: pageInfo['hasNextPage'] ?? false,
      hasPreviousPage: pageInfo['hasPreviousPage'] ?? false,
      startCursor: pageInfo['startCursor'],
      endCursor: pageInfo['endCursor'],
    );
  }

  /// Get products in collection (alternative method)
  /// 
  /// This is a convenience method that uses ProductService.
  /// Products are always fetched fresh.
  Future<ProductListResult> getProductsInCollection({
    required String collectionHandle,
    int first = 20,
    String? after,
    String? sortKey,
    bool reverse = false,
  }) async {
    return productService.getProductsByCollection(
      collectionHandle: collectionHandle,
      first: first,
      after: after,
      sortKey: sortKey,
      reverse: reverse,
    );
  }
}

/// Collection List Result
class CollectionListResult {
  final List<CollectionModel> collections;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? startCursor;
  final String? endCursor;

  CollectionListResult({
    required this.collections,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });
}

/// Collection With Products Result
class CollectionWithProductsResult {
  final CollectionModel collection;
  final List<ProductModel> products;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? startCursor;
  final String? endCursor;

  CollectionWithProductsResult({
    required this.collection,
    required this.products,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });
}

