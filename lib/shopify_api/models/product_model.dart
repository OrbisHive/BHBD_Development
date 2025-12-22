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
  final PriceRange? priceRange;
  final bool availableForSale;
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
    this.priceRange,
    this.availableForSale = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Parse from GraphQL response
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final node = json['node'] ?? json;
    
    final featuredImage = node['featuredImage'];
    final priceRangeData = node['priceRange'];
    final variants = node['variants'];
    
    // Check availability from first variant
    bool available = false;
    if (variants != null && 
        variants['edges'] != null && 
        variants['edges'].isNotEmpty) {
      final firstVariant = variants['edges'][0]['node'];
      available = firstVariant['availableForSale'] ?? false;
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
      priceRange: priceRangeData != null 
          ? PriceRange.fromJson(priceRangeData) 
          : null,
      availableForSale: available,
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
      minVariantPrice: Money.fromJson(json['minVariantPrice']),
      maxVariantPrice: Money.fromJson(json['maxVariantPrice']),
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
      amount: json['amount'] ?? '0.0',
      currencyCode: json['currencyCode'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currencyCode': currencyCode,
    };
  }

  /// Get formatted price string
  String get formatted {
    final amountNum = double.tryParse(amount) ?? 0.0;
    return '${_getCurrencySymbol()}$amountNum';
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
      default:
        return '$currencyCode ';
    }
  }
}

