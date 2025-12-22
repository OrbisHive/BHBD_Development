import '../models/product_model.dart';
import '../queries/products_queries.dart';
import '../services/shopify_client.dart';

/// Product Service
/// 
/// Handles all product-related operations.
/// Always fetches fresh data from Shopify - never caches product data.

class ProductService {
  final ShopifyClient client;

  ProductService(this.client);

  /// Get products list
  /// 
  /// [first] - Number of products to fetch (default: 20, max: 250)
  /// [after] - Cursor for pagination
  /// [query] - Search query string
  /// [productTypes] - Filter by product types
  /// [tags] - Filter by tags
  /// [sortKey] - Sort key (use ProductSortKeys)
  /// [reverse] - Reverse sort order
  /// 
  /// Returns list of products and pagination info
  Future<ProductListResult> getProducts({
    int first = 20,
    String? after,
    String? query,
    List<String>? productTypes,
    List<String>? tags,
    String? sortKey,
    bool reverse = false,
  }) async {
    final queryString = ProductQueries.getProducts(
      first: first,
      after: after,
      query: query,
      productTypes: productTypes,
      tags: tags,
      sortKey: sortKey,
      reverse: reverse,
    );

    final response = await client.query(queryString);

    final data = response['data']?['products'];
    if (data == null) {
      throw ShopifyException('Invalid response format', code: 'INVALID_RESPONSE');
    }

    final edges = data['edges'] as List? ?? [];
    final products = edges
        .map((edge) => ProductModel.fromJson(edge))
        .toList()
        .cast<ProductModel>();

    final pageInfo = data['pageInfo'] ?? {};

    return ProductListResult(
      products: products,
      hasNextPage: pageInfo['hasNextPage'] ?? false,
      hasPreviousPage: pageInfo['hasPreviousPage'] ?? false,
      startCursor: pageInfo['startCursor'],
      endCursor: pageInfo['endCursor'],
    );
  }

  /// Get product by handle
  /// 
  /// [handle] - Product handle (URL-friendly identifier)
  /// 
  /// Returns product details with all variants
  Future<ProductDetailModel> getProductByHandle(String handle) async {
    final queryString = ProductQueries.getProductByHandle(handle);

    final response = await client.query(queryString);

    final productData = response['data']?['product'];
    if (productData == null) {
      throw ShopifyException('Product not found', code: 'NOT_FOUND');
    }

    return ProductDetailModel.fromJson(productData);
  }

  /// Get product by ID
  /// 
  /// [productId] - Product ID (GID format)
  /// 
  /// Returns product details
  Future<ProductDetailModel> getProductById(String productId) async {
    final queryString = ProductQueries.getProductById(productId);

    final response = await client.query(queryString);

    final productData = response['data']?['product'];
    if (productData == null) {
      throw ShopifyException('Product not found', code: 'NOT_FOUND');
    }

    return ProductDetailModel.fromJson(productData);
  }

  /// Search products
  /// 
  /// [query] - Search query string
  /// [first] - Number of results (default: 20)
  /// [after] - Cursor for pagination
  /// [sortKey] - Sort key
  /// [reverse] - Reverse sort order
  /// 
  /// Returns search results with pagination
  Future<ProductListResult> searchProducts({
    required String query,
    int first = 20,
    String? after,
    String? sortKey,
    bool reverse = false,
  }) async {
    final queryString = ProductQueries.searchProducts(
      query: query,
      first: first,
      after: after,
      sortKey: sortKey,
      reverse: reverse,
    );

    final response = await client.query(queryString);

    final data = response['data']?['products'];
    if (data == null) {
      throw ShopifyException('Invalid response format', code: 'INVALID_RESPONSE');
    }

    final edges = data['edges'] as List? ?? [];
    final products = edges
        .map((edge) => ProductModel.fromJson(edge))
        .toList()
        .cast<ProductModel>();

    final pageInfo = data['pageInfo'] ?? {};

    return ProductListResult(
      products: products,
      hasNextPage: pageInfo['hasNextPage'] ?? false,
      hasPreviousPage: pageInfo['hasPreviousPage'] ?? false,
      startCursor: pageInfo['startCursor'],
      endCursor: pageInfo['endCursor'],
    );
  }

  /// Get products by collection
  /// 
  /// [collectionHandle] - Collection handle
  /// [first] - Number of products (default: 20)
  /// [after] - Cursor for pagination
  /// [sortKey] - Sort key
  /// [reverse] - Reverse sort order
  /// 
  /// Returns products in collection with pagination
  Future<ProductListResult> getProductsByCollection({
    required String collectionHandle,
    int first = 20,
    String? after,
    String? sortKey,
    bool reverse = false,
  }) async {
    final queryString = ProductQueries.getProductsByCollection(
      collectionHandle: collectionHandle,
      first: first,
      after: after,
      sortKey: sortKey,
      reverse: reverse,
    );

    final response = await client.query(queryString);

    final collectionData = response['data']?['collection'];
    if (collectionData == null) {
      throw ShopifyException('Collection not found', code: 'NOT_FOUND');
    }

    final productsData = collectionData['products'] ?? {};
    final edges = productsData['edges'] as List? ?? [];
    final products = edges
        .map((edge) => ProductModel.fromJson(edge))
        .toList()
        .cast<ProductModel>();

    final pageInfo = productsData['pageInfo'] ?? {};

    return ProductListResult(
      products: products,
      hasNextPage: pageInfo['hasNextPage'] ?? false,
      hasPreviousPage: pageInfo['hasPreviousPage'] ?? false,
      startCursor: pageInfo['startCursor'],
      endCursor: pageInfo['endCursor'],
    );
  }
}

/// Product List Result
/// Contains products and pagination information
class ProductListResult {
  final List<ProductModel> products;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? startCursor;
  final String? endCursor;

  ProductListResult({
    required this.products,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });
}

/// Product Detail Model
/// Extended product model with full details including variants
class ProductDetailModel extends ProductModel {
  final List<ProductImage> images;
  final List<ProductVariant> variants;
  final List<ProductOption> options;
  final ProductSEO? seo;
  final List<ProductMetafield> metafields;

  ProductDetailModel({
    required super.id,
    required super.title,
    required super.handle,
    super.description,
    super.descriptionHtml,
    super.vendor,
    super.productType,
    super.tags,
    super.featuredImageUrl,
    super.featuredImageAlt,
    super.priceRange,
    super.availableForSale,
    super.createdAt,
    super.updatedAt,
    this.images = const [],
    this.variants = const [],
    this.options = const [],
    this.seo,
    this.metafields = const [],
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final base = ProductModel.fromJson(json);

    final images = <ProductImage>[];
    if (json['images'] != null && json['images']['edges'] != null) {
      for (var edge in json['images']['edges']) {
        images.add(ProductImage.fromJson(edge['node']));
      }
    }

    final variants = <ProductVariant>[];
    if (json['variants'] != null && json['variants']['edges'] != null) {
      for (var edge in json['variants']['edges']) {
        variants.add(ProductVariant.fromJson(edge['node']));
      }
    }

    final options = <ProductOption>[];
    if (json['options'] != null) {
      for (var option in json['options']) {
        options.add(ProductOption.fromJson(option));
      }
    }

    return ProductDetailModel(
      id: base.id,
      title: base.title,
      handle: base.handle,
      description: base.description,
      descriptionHtml: base.descriptionHtml,
      vendor: base.vendor,
      productType: base.productType,
      tags: base.tags,
      featuredImageUrl: base.featuredImageUrl,
      featuredImageAlt: base.featuredImageAlt,
      priceRange: base.priceRange,
      availableForSale: base.availableForSale,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      images: images,
      variants: variants,
      options: options,
      seo: json['seo'] != null ? ProductSEO.fromJson(json['seo']) : null,
      metafields: json['metafields'] != null && json['metafields']['edges'] != null
          ? (json['metafields']['edges'] as List)
              .map((e) => ProductMetafield.fromJson(e['node']))
              .toList()
              .cast<ProductMetafield>()
          : [],
    );
  }
}

/// Product Image Model
class ProductImage {
  final String id;
  final String url;
  final String? altText;
  final int? width;
  final int? height;

  ProductImage({
    required this.id,
    required this.url,
    this.altText,
    this.width,
    this.height,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      altText: json['altText'],
      width: json['width'],
      height: json['height'],
    );
  }
}

/// Product Variant Model
class ProductVariant {
  final String id;
  final String title;
  final Money price;
  final bool availableForSale;
  final int? quantityAvailable;
  final List<SelectedOption> selectedOptions;
  final String? imageUrl;
  final String? sku;
  final String? barcode;
  final double? weight;
  final String? weightUnit;

  ProductVariant({
    required this.id,
    required this.title,
    required this.price,
    required this.availableForSale,
    this.quantityAvailable,
    this.selectedOptions = const [],
    this.imageUrl,
    this.sku,
    this.barcode,
    this.weight,
    this.weightUnit,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final selectedOptions = <SelectedOption>[];
    if (json['selectedOptions'] != null) {
      for (var option in json['selectedOptions']) {
        selectedOptions.add(SelectedOption.fromJson(option));
      }
    }

    return ProductVariant(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: Money.fromJson(json['price'] ?? {}),
      availableForSale: json['availableForSale'] ?? false,
      quantityAvailable: json['quantityAvailable'],
      selectedOptions: selectedOptions,
      imageUrl: json['image']?['url'],
      sku: json['sku'],
      barcode: json['barcode'],
      weight: json['weight'] != null ? double.tryParse(json['weight'].toString()) : null,
      weightUnit: json['weightUnit'],
    );
  }
}

/// Selected Option Model
class SelectedOption {
  final String name;
  final String value;

  SelectedOption({required this.name, required this.value});

  factory SelectedOption.fromJson(Map<String, dynamic> json) {
    return SelectedOption(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

/// Product Option Model
class ProductOption {
  final String id;
  final String name;
  final List<String> values;

  ProductOption({
    required this.id,
    required this.name,
    required this.values,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      values: json['values'] != null 
          ? List<String>.from(json['values']) 
          : [],
    );
  }
}

/// Product SEO Model
class ProductSEO {
  final String? title;
  final String? description;

  ProductSEO({this.title, this.description});

  factory ProductSEO.fromJson(Map<String, dynamic> json) {
    return ProductSEO(
      title: json['title'],
      description: json['description'],
    );
  }
}

/// Product Metafield Model
class ProductMetafield {
  final String id;
  final String namespace;
  final String key;
  final String value;
  final String type;

  ProductMetafield({
    required this.id,
    required this.namespace,
    required this.key,
    required this.value,
    required this.type,
  });

  factory ProductMetafield.fromJson(Map<String, dynamic> json) {
    return ProductMetafield(
      id: json['id'] ?? '',
      namespace: json['namespace'] ?? '',
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

