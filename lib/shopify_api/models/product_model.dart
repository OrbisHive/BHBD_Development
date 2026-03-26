/// Product Model
/// 
/// Represents a Shopify product.
/// This model should be used for display only, never as source of truth.

class ProductModel {
  final String id;
  final String title;
  final String handle;
  final String? description;
  final String? descriptionHtml;
  final String? vendor;
  final String? productType;
  final List<String> tags;
  final String? featuredImageUrl;
  final String? featuredImageAlt;
  final List<String> imageUrls; // All product images
  final PriceRange? priceRange;
  final bool availableForSale;
  final Money? compareAtPrice; // Original price (for showing discounts)
  final double? averageRating; // Average rating from reviews
  final int? reviewCount; // Number of reviews
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.title,
    required this.handle,
    this.description,
    this.descriptionHtml,
    this.vendor,
    this.productType,
    this.tags = const [],
    this.featuredImageUrl,
    this.featuredImageAlt,
    this.imageUrls = const [],
    this.priceRange,
    this.availableForSale = false,
    this.compareAtPrice,
    this.averageRating,
    this.reviewCount,
    this.createdAt,
    this.updatedAt,
  });

  /// Parse from GraphQL response
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final node = json['node'] ?? json;
    
    final featuredImage = node['featuredImage'];
    final imagesData = node['images'];
    final priceRangeData = node['priceRange'];
    final variants = node['variants'];
    
    // Parse all product images
    final List<String> imageUrls = [];
    if (imagesData != null && imagesData is Map<String, dynamic>) {
      final edges = imagesData['edges'];
      if (edges != null && edges is List) {
        for (var edge in edges) {
          if (edge is Map<String, dynamic> && edge['node'] != null) {
            final imageNode = edge['node'];
            if (imageNode is Map<String, dynamic> && imageNode['url'] != null) {
              imageUrls.add(imageNode['url'].toString());
            }
          }
        }
      }
    }
    
    // If no images from images array, use featuredImage as fallback
    if (imageUrls.isEmpty && featuredImage?['url'] != null) {
      imageUrls.add(featuredImage['url'].toString());
    }
    
    // Check availability and get compareAtPrice from first variant
    bool available = false;
    Money? compareAtPrice;
    if (variants != null && 
        variants is Map<String, dynamic> &&
        variants['edges'] != null && 
        variants['edges'] is List &&
        (variants['edges'] as List).isNotEmpty) {
      final firstEdge = (variants['edges'] as List)[0];
      if (firstEdge is Map<String, dynamic> && firstEdge['node'] != null) {
        final firstVariant = firstEdge['node'];
        if (firstVariant is Map<String, dynamic>) {
      available = firstVariant['availableForSale'] ?? false;
          // Get compareAtPrice if available
          if (firstVariant['compareAtPrice'] != null && 
              firstVariant['compareAtPrice'] is Map<String, dynamic>) {
            compareAtPrice = Money.fromJson(firstVariant['compareAtPrice'] as Map<String, dynamic>);
          }
        }
      }
    }

    // Parse review data from metafields
    double? averageRating;
    int? reviewCount;
    final metafields = node['metafields'];
    if (metafields != null && metafields is List) {
      // Metafields returns an array directly (not edges)
      for (var metafield in metafields) {
        if (metafield is Map<String, dynamic>) {
          final namespace = metafield['namespace']?.toString() ?? '';
          final key = metafield['key']?.toString() ?? '';
          final value = metafield['value']?.toString();
          
          // Check for various review metafield formats
          if ((namespace == 'reviews' || namespace == 'custom' || namespace == 'judge' || namespace == 'stamped') && 
              (key == 'rating' || key == 'average_rating' || key == 'avg_rating')) {
            averageRating = double.tryParse(value ?? '');
          }
          if ((namespace == 'reviews' || namespace == 'custom' || namespace == 'judge' || namespace == 'stamped') && 
              (key == 'rating_count' || key == 'review_count' || key == 'count')) {
            reviewCount = int.tryParse(value ?? '');
          }
        }
      }
    }

    return ProductModel(
      id: node['id'] ?? '',
      title: node['title'] ?? '',
      handle: node['handle'] ?? '',
      description: node['description'],
      descriptionHtml: node['descriptionHtml'],
      vendor: node['vendor'],
      productType: node['productType'],
      tags: node['tags'] != null 
          ? List<String>.from(node['tags']) 
          : [],
      featuredImageUrl: featuredImage?['url'],
      featuredImageAlt: featuredImage?['altText'],
      imageUrls: imageUrls,
      priceRange: priceRangeData != null && priceRangeData is Map<String, dynamic>
          ? PriceRange.fromJson(priceRangeData) 
          : null,
      availableForSale: available,
      compareAtPrice: compareAtPrice,
      averageRating: averageRating,
      reviewCount: reviewCount,
      createdAt: node['createdAt'] != null 
          ? DateTime.parse(node['createdAt']) 
          : null,
      updatedAt: node['updatedAt'] != null 
          ? DateTime.parse(node['updatedAt']) 
          : null,
    );
  }

  /// Convert to JSON (for caching display data only)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'handle': handle,
      'description': description,
      'vendor': vendor,
      'productType': productType,
      'tags': tags,
      'featuredImageUrl': featuredImageUrl,
      'featuredImageAlt': featuredImageAlt,
      'priceRange': priceRange?.toJson(),
      'availableForSale': availableForSale,
    };
  }
}

/// Price Range Model
class PriceRange {
  final Money minVariantPrice;
  final Money maxVariantPrice;

  PriceRange({
    required this.minVariantPrice,
    required this.maxVariantPrice,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      minVariantPrice: json['minVariantPrice'] != null && json['minVariantPrice'] is Map<String, dynamic>
          ? Money.fromJson(json['minVariantPrice'] as Map<String, dynamic>)
          : Money(amount: '0.0', currencyCode: 'USD'),
      maxVariantPrice: json['maxVariantPrice'] != null && json['maxVariantPrice'] is Map<String, dynamic>
          ? Money.fromJson(json['maxVariantPrice'] as Map<String, dynamic>)
          : Money(amount: '0.0', currencyCode: 'USD'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minVariantPrice': minVariantPrice.toJson(),
      'maxVariantPrice': maxVariantPrice.toJson(),
    };
  }
}

/// Money Model
class Money {
  final String amount;
  final String currencyCode;

  Money({
    required this.amount,
    required this.currencyCode,
  });

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      amount: json['amount']?.toString() ?? '0.0',
      currencyCode: json['currencyCode']?.toString() ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currencyCode': currencyCode,
    };
  }

  /// Get formatted price string
  /// Uses device location to format currency
  String get formatted {
    try {
      // Import currency helper dynamically to avoid circular dependency
      // For now, use basic formatting
      final amountNum = double.tryParse(amount) ?? 0.0;
      return _formatWithCurrency(amountNum, currencyCode);
    } catch (e) {
      // Fallback to basic formatting
    final amountNum = double.tryParse(amount) ?? 0.0;
    return '${_getCurrencySymbol()}$amountNum';
    }
  }

  /// Format price with currency based on device location
  String _formatWithCurrency(double amount, String shopifyCurrency) {
    // This will be handled by CurrencyHelper in the UI layer
    // For now, return basic format
    return '${_getCurrencySymbol()}$amount';
  }

  String _getCurrencySymbol() {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'CAD':
        return 'C\$';
      case 'SEK':
        return 'kr ';
      case 'PKR':
        return 'Rs.';
      default:
        return '$currencyCode ';
    }
  }
}

