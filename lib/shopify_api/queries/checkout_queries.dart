/// GraphQL Queries for Checkout Operations
/// 
/// Note: Storefront API checkout is being replaced by Cart API.
/// For new implementations, use Cart API and redirect to checkoutUrl.
/// 
/// This file is kept for reference but Cart API is recommended.

class CheckoutQueries {
  /// Create checkout from cart
  /// 
  /// DEPRECATED: Use Cart API's checkoutUrl instead.
  /// This mutation creates a checkout object (legacy).
  /// 
  /// Query complexity: ~200-300
  static String createCheckout({
    required String cartId,
  }) {
    return '''
      mutation CreateCheckout {
        checkoutCreate(input: {cartId: "$cartId"}) {
          checkout {
            id
            webUrl
            totalPrice {
              amount
              currencyCode
            }
            subtotalPrice {
              amount
              currencyCode
            }
            totalTax {
              amount
              currencyCode
            }
            lineItems(first: 250) {
              edges {
                node {
                  id
                  title
                  quantity
                  variant {
                    id
                    title
                    price {
                      amount
                      currencyCode
                    }
                    product {
                      id
                      title
                      handle
                    }
                  }
                }
              }
            }
            shippingAddress {
              address1
              address2
              city
              province
              country
              zip
              firstName
              lastName
            }
            shippingLine {
              title
              price {
                amount
                currencyCode
              }
            }
          }
          checkoutUserErrors {
            field
            message
          }
        }
      }
    ''';
  }

  /// Get checkout by ID
  /// 
  /// DEPRECATED: Use Cart API instead.
  /// 
  /// Query complexity: ~200-300
  static String getCheckout(String checkoutId) {
    return '''
      query GetCheckout {
        node(id: "$checkoutId") {
          ... on Checkout {
            id
            webUrl
            totalPrice {
              amount
              currencyCode
            }
            subtotalPrice {
              amount
              currencyCode
            }
            lineItems(first: 250) {
              edges {
                node {
                  id
                  title
                  quantity
                  variant {
                    id
                    title
                    price {
                      amount
                      currencyCode
                    }
                  }
                }
              }
            }
          }
        }
      }
    ''';
  }
}

/// 
/// RECOMMENDED APPROACH:
/// 
/// Instead of using checkout mutations, use Cart API:
/// 
/// 1. Create/update cart using Cart API
/// 2. Get checkoutUrl from cart response
/// 3. Redirect user to checkoutUrl (web) or use checkout API
/// 
/// Example flow:
/// ```dart
/// // 1. Create cart
/// final cart = await cartService.createCart();
/// 
/// // 2. Add items
/// await cartService.addToCart(cartId: cart.id, items: items);
/// 
/// // 3. Get updated cart with checkoutUrl
/// final updatedCart = await cartService.getCart(cart.id);
/// 
/// // 4. Redirect to checkout
/// launchUrl(Uri.parse(updatedCart.checkoutUrl));
/// ```
/// 

