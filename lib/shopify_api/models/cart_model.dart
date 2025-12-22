import '../models/product_model.dart';

/// Cart Model
/// 
/// Represents a Shopify cart.
/// Carts are session-based and should be persisted using cart ID.

class CartModel {
  final String id;
  final String checkoutUrl;
  final int totalQuantity;
  final Money totalAmount;
  final Money subtotalAmount;
  final Money? totalTaxAmount;
  final Money? totalDutyAmount;
  final List<CartLine> lines;
  final CartBuyerIdentity? buyerIdentity;

  CartModel({
    required this.id,
    required this.checkoutUrl,
    required this.totalQuantity,
    required this.totalAmount,
    required this.subtotalAmount,
    this.totalTaxAmount,
    this.totalDutyAmount,
    this.lines = const [],
    this.buyerIdentity,
  });

  /// Parse from GraphQL response
  factory CartModel.fromJson(Map<String, dynamic> json) {
    final cart = json['cart'] ?? json;
    final cost = cart['cost'] ?? {};
    final linesData = cart['lines'] ?? {};
    final buyerIdentityData = cart['buyerIdentity'];

    final lines = <CartLine>[];
    if (linesData['edges'] != null) {
      for (var edge in linesData['edges']) {
        lines.add(CartLine.fromJson(edge['node']));
      }
    }

    return CartModel(
      id: cart['id'] ?? '',
      checkoutUrl: cart['checkoutUrl'] ?? '',
      totalQuantity: cart['totalQuantity'] ?? 0,
      totalAmount: Money.fromJson(cost['totalAmount'] ?? {}),
      subtotalAmount: Money.fromJson(cost['subtotalAmount'] ?? {}),
      totalTaxAmount: cost['totalTaxAmount'] != null
          ? Money.fromJson(cost['totalTaxAmount'])
          : null,
      totalDutyAmount: cost['totalDutyAmount'] != null
          ? Money.fromJson(cost['totalDutyAmount'])
          : null,
      lines: lines,
      buyerIdentity: buyerIdentityData != null
          ? CartBuyerIdentity.fromJson(buyerIdentityData)
          : null,
    );
  }

  /// Convert to JSON (for local storage of cart ID only)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkoutUrl': checkoutUrl,
      'totalQuantity': totalQuantity,
    };
  }
}

/// Cart Line Model
/// Represents an item in the cart
class CartLine {
  final String id;
  final int quantity;
  final String variantId;
  final String variantTitle;
  final Money price;
  final Money totalAmount;
  final String productId;
  final String productTitle;
  final String productHandle;
  final String? productImageUrl;
  final String? productImageAlt;

  CartLine({
    required this.id,
    required this.quantity,
    required this.variantId,
    required this.variantTitle,
    required this.price,
    required this.totalAmount,
    required this.productId,
    required this.productTitle,
    required this.productHandle,
    this.productImageUrl,
    this.productImageAlt,
  });

  factory CartLine.fromJson(Map<String, dynamic> json) {
    final merchandise = json['merchandise'] ?? {};
    final product = merchandise['product'] ?? {};
    final featuredImage = product['featuredImage'];
    final cost = json['cost'] ?? {};

    return CartLine(
      id: json['id'] ?? '',
      quantity: json['quantity'] ?? 0,
      variantId: merchandise['id'] ?? '',
      variantTitle: merchandise['title'] ?? '',
      price: Money.fromJson(merchandise['price'] ?? {}),
      totalAmount: Money.fromJson(cost['totalAmount'] ?? {}),
      productId: product['id'] ?? '',
      productTitle: product['title'] ?? '',
      productHandle: product['handle'] ?? '',
      productImageUrl: featuredImage?['url'],
      productImageAlt: featuredImage?['altText'],
    );
  }
}

/// Cart Buyer Identity
class CartBuyerIdentity {
  final String? email;
  final String? countryCode;

  CartBuyerIdentity({
    this.email,
    this.countryCode,
  });

  factory CartBuyerIdentity.fromJson(Map<String, dynamic> json) {
    return CartBuyerIdentity(
      email: json['email'],
      countryCode: json['countryCode'],
    );
  }
}

