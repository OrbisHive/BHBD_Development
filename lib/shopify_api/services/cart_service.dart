import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import '../queries/cart_queries.dart';
import '../services/shopify_client.dart';

/// Cart Service
/// 
/// Handles cart operations.
/// Cart ID is stored locally for session persistence.
/// Cart data should be fetched fresh from Shopify before checkout.

class CartService {
  final ShopifyClient client;
  static const String _cartIdKey = 'shopify_cart_id';

  CartService(this.client);

  /// Create a new cart
  /// 
  /// [lines] - Optional initial cart items
  /// 
  /// Returns cart with ID (stored locally)
  Future<CartModel> createCart({
    List<CartLineInput>? lines,
  }) async {
    final linesData = lines?.map((line) => {
          'merchandiseId': line.merchandiseId,
          'quantity': line.quantity,
        }).toList();

    final queryString = CartQueries.createCart(lines: linesData);

    final response = await client.query(queryString);

    final cartData = response['data']?['cartCreate']?['cart'];
    if (cartData == null) {
      final errors = response['data']?['cartCreate']?['userErrors'] ?? [];
      if (errors.isNotEmpty) {
        throw ShopifyException(
          errors.map((e) => e['message']).join(', '),
          code: 'CART_ERROR',
        );
      }
      throw ShopifyException('Failed to create cart', code: 'CART_ERROR');
    }

    final cart = CartModel.fromJson(cartData);

    // Store cart ID locally
    await _saveCartId(cart.id);

    return cart;
  }

  /// Get cart by ID
  /// 
  /// [cartId] - Cart ID (optional, uses stored ID if not provided)
  /// 
  /// Returns current cart state
  Future<CartModel> getCart([String? cartId]) async {
    final id = cartId ?? await _getCartId();
    if (id == null) {
      throw ShopifyException('No cart found', code: 'CART_NOT_FOUND');
    }

    final queryString = CartQueries.getCart(id);

    final response = await client.query(queryString);

    final cartData = response['data']?['cart'];
    if (cartData == null) {
      // Cart might have expired, clear stored ID
      await _clearCartId();
      throw ShopifyException('Cart not found or expired', code: 'CART_NOT_FOUND');
    }

    return CartModel.fromJson(cartData);
  }

  /// Get current cart (from storage)
  /// 
  /// Returns current cart or creates new one if none exists
  Future<CartModel> getCurrentCart() async {
    try {
      return await getCart();
    } catch (e) {
      if (e is ShopifyException && e.code == 'CART_NOT_FOUND') {
        return await createCart();
      }
      rethrow;
    }
  }

  /// Add items to cart
  /// 
  /// [cartId] - Cart ID (optional, uses stored ID)
  /// [lines] - Items to add
  /// 
  /// Returns updated cart
  Future<CartModel> addToCart({
    String? cartId,
    required List<CartLineInput> lines,
  }) async {
    final id = cartId ?? await _getCartId();
    if (id == null) {
      // Create new cart if none exists
      return await createCart(lines: lines);
    }

    final linesData = lines.map((line) => {
          'merchandiseId': line.merchandiseId,
          'quantity': line.quantity,
        }).toList();

    final queryString = CartQueries.addToCart(
      cartId: id,
      lines: linesData,
    );

    final response = await client.query(queryString);

    final cartData = response['data']?['cartLinesAdd']?['cart'];
    if (cartData == null) {
      final errors = response['data']?['cartLinesAdd']?['userErrors'] ?? [];
      if (errors.isNotEmpty) {
        throw ShopifyException(
          errors.map((e) => e['message']).join(', '),
          code: 'CART_ERROR',
        );
      }
      throw ShopifyException('Failed to add items to cart', code: 'CART_ERROR');
    }

    return CartModel.fromJson(cartData);
  }

  /// Update cart lines
  /// 
  /// [cartId] - Cart ID (optional, uses stored ID)
  /// [lines] - Lines to update (set quantity to 0 to remove)
  /// 
  /// Returns updated cart
  Future<CartModel> updateCartLines({
    String? cartId,
    required List<CartLineUpdateInput> lines,
  }) async {
    final id = cartId ?? await _getCartId();
    if (id == null) {
      throw ShopifyException('No cart found', code: 'CART_NOT_FOUND');
    }

    final linesData = lines.map((line) => {
          'id': line.id,
          'quantity': line.quantity,
        }).toList();

    final queryString = CartQueries.updateCartLines(
      cartId: id,
      lines: linesData,
    );

    final response = await client.query(queryString);

    final cartData = response['data']?['cartLinesUpdate']?['cart'];
    if (cartData == null) {
      final errors = response['data']?['cartLinesUpdate']?['userErrors'] ?? [];
      if (errors.isNotEmpty) {
        throw ShopifyException(
          errors.map((e) => e['message']).join(', '),
          code: 'CART_ERROR',
        );
      }
      throw ShopifyException('Failed to update cart', code: 'CART_ERROR');
    }

    return CartModel.fromJson(cartData);
  }

  /// Remove items from cart
  /// 
  /// [cartId] - Cart ID (optional, uses stored ID)
  /// [lineIds] - Line IDs to remove
  /// 
  /// Returns updated cart
  Future<CartModel> removeCartLines({
    String? cartId,
    required List<String> lineIds,
  }) async {
    final id = cartId ?? await _getCartId();
    if (id == null) {
      throw ShopifyException('No cart found', code: 'CART_NOT_FOUND');
    }

    final queryString = CartQueries.removeCartLines(
      cartId: id,
      lineIds: lineIds,
    );

    final response = await client.query(queryString);

    final cartData = response['data']?['cartLinesRemove']?['cart'];
    if (cartData == null) {
      final errors = response['data']?['cartLinesRemove']?['userErrors'] ?? [];
      if (errors.isNotEmpty) {
        throw ShopifyException(
          errors.map((e) => e['message']).join(', '),
          code: 'CART_ERROR',
        );
      }
      throw ShopifyException('Failed to remove items from cart', code: 'CART_ERROR');
    }

    return CartModel.fromJson(cartData);
  }

  /// Update cart buyer identity
  /// 
  /// Associates cart with customer email or country.
  /// 
  /// [cartId] - Cart ID (optional, uses stored ID)
  /// [email] - Customer email
  /// [countryCode] - Country code
  Future<CartModel> updateBuyerIdentity({
    String? cartId,
    String? email,
    String? countryCode,
  }) async {
    final id = cartId ?? await _getCartId();
    if (id == null) {
      throw ShopifyException('No cart found', code: 'CART_NOT_FOUND');
    }

    final queryString = CartQueries.updateCartBuyerIdentity(
      cartId: id,
      email: email,
      countryCode: countryCode,
    );

    final response = await client.query(queryString);

    final cartData = response['data']?['cartBuyerIdentityUpdate']?['cart'];
    if (cartData == null) {
      final errors = response['data']?['cartBuyerIdentityUpdate']?['userErrors'] ?? [];
      if (errors.isNotEmpty) {
        throw ShopifyException(
          errors.map((e) => e['message']).join(', '),
          code: 'CART_ERROR',
        );
      }
      throw ShopifyException('Failed to update buyer identity', code: 'CART_ERROR');
    }

    return CartModel.fromJson(cartData);
  }

  /// Clear cart (remove all items)
  /// 
  /// [cartId] - Cart ID (optional, uses stored ID)
  Future<CartModel> clearCart([String? cartId]) async {
    final id = cartId ?? await _getCartId();
    if (id == null) {
      return await createCart();
    }

    final cart = await getCart(id);
    final lineIds = cart.lines.map((line) => line.id).toList();

    if (lineIds.isEmpty) {
      return cart;
    }

    return await removeCartLines(cartId: id, lineIds: lineIds);
  }

  /// Clear stored cart ID
  Future<void> clearStoredCart() async {
    await _clearCartId();
  }

  // Private methods for cart ID storage

  Future<void> _saveCartId(String cartId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartIdKey, cartId);
  }

  Future<String?> _getCartId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cartIdKey);
  }

  Future<void> _clearCartId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartIdKey);
  }
}

/// Cart Line Input
class CartLineInput {
  final String merchandiseId; // Variant ID
  final int quantity;

  CartLineInput({
    required this.merchandiseId,
    required this.quantity,
  });
}

/// Cart Line Update Input
class CartLineUpdateInput {
  final String id; // Cart line ID
  final int quantity; // Set to 0 to remove

  CartLineUpdateInput({
    required this.id,
    required this.quantity,
  });
}

