/// GraphQL Queries and Mutations for Cart Operations
/// 
/// Cart operations use mutations to create, update, and manage carts.
/// Carts are session-based and can be persisted using cart ID.

class CartQueries {
  /// Create a new cart
  /// 
  /// Creates an empty cart or cart with initial items.
  /// Returns cart ID which should be stored for future operations.
  /// 
  /// Query complexity: ~100-200
  static String createCart({
    List<Map<String, dynamic>>? lines,
  }) {
    final linesJson = lines != null && lines.isNotEmpty
        ? lines
            .map((line) =>
                '{merchandiseId: "${line['merchandiseId']}", quantity: ${line['quantity']}}')
            .join(', ')
        : '';

    return '''
      mutation CreateCart {
        cartCreate(
          ${lines != null && lines.isNotEmpty ? 'input: {lines: [$linesJson]}' : ''}
        ) {
          cart {
            id
            checkoutUrl
            totalQuantity
            cost {
              totalAmount {
                amount
                currencyCode
              }
              subtotalAmount {
                amount
                currencyCode
              }
              totalTaxAmount {
                amount
                currencyCode
              }
              totalDutyAmount {
                amount
                currencyCode
              }
            }
            lines(first: 250) {
              edges {
                node {
                  id
                  quantity
                  merchandise {
                    ... on ProductVariant {
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
                        featuredImage {
                          id
                          url
                          altText
                        }
                      }
                    }
                  }
                  cost {
                    totalAmount {
                      amount
                      currencyCode
                    }
                  }
                }
              }
            }
            buyerIdentity {
              email
              countryCode
            }
          }
          userErrors {
            field
            message
          }
        }
      }
    ''';
  }

  /// Get cart by ID
  /// 
  /// Retrieves existing cart using cart ID.
  /// Use this to restore a cart from storage.
  /// 
  /// Query complexity: ~100-200
  static String getCart(String cartId) {
    return '''
      query GetCart {
        cart(id: "$cartId") {
          id
          checkoutUrl
          totalQuantity
          cost {
            totalAmount {
              amount
              currencyCode
            }
            subtotalAmount {
              amount
              currencyCode
            }
            totalTaxAmount {
              amount
              currencyCode
            }
            totalDutyAmount {
              amount
              currencyCode
            }
          }
          lines(first: 250) {
            edges {
              node {
                id
                quantity
                merchandise {
                  ... on ProductVariant {
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
                      featuredImage {
                        id
                        url
                        altText
                      }
                    }
                  }
                }
                cost {
                  totalAmount {
                    amount
                    currencyCode
                  }
                }
              }
            }
          }
          buyerIdentity {
            email
            countryCode
          }
        }
      }
    ''';
  }

  /// Add items to cart
  /// 
  /// Adds one or more items to an existing cart.
  /// 
  /// Query complexity: ~100-200
  static String addToCart({
    required String cartId,
    required List<Map<String, dynamic>> lines,
  }) {
    final linesJson = lines
        .map((line) =>
            '{merchandiseId: "${line['merchandiseId']}", quantity: ${line['quantity']}}')
        .join(', ');

    return '''
      mutation AddToCart {
        cartLinesAdd(
          cartId: "$cartId"
          lines: [$linesJson]
        ) {
          cart {
            id
            checkoutUrl
            totalQuantity
            cost {
              totalAmount {
                amount
                currencyCode
              }
              subtotalAmount {
                amount
                currencyCode
              }
            }
            lines(first: 250) {
              edges {
                node {
                  id
                  quantity
                  merchandise {
                    ... on ProductVariant {
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
                        featuredImage {
                          id
                          url
                          altText
                        }
                      }
                    }
                  }
                  cost {
                    totalAmount {
                      amount
                      currencyCode
                    }
                  }
                }
              }
            }
          }
          userErrors {
            field
            message
          }
        }
      }
    ''';
  }

  /// Update cart lines
  /// 
  /// Updates quantities or removes items from cart.
  /// To remove an item, set quantity to 0.
  /// 
  /// Query complexity: ~100-200
  static String updateCartLines({
    required String cartId,
    required List<Map<String, dynamic>> lines,
  }) {
    final linesJson = lines
        .map((line) =>
            '{id: "${line['id']}", quantity: ${line['quantity']}}')
        .join(', ');

    return '''
      mutation UpdateCartLines {
        cartLinesUpdate(
          cartId: "$cartId"
          lines: [$linesJson]
        ) {
          cart {
            id
            checkoutUrl
            totalQuantity
            cost {
              totalAmount {
                amount
                currencyCode
              }
              subtotalAmount {
                amount
                currencyCode
              }
            }
            lines(first: 250) {
              edges {
                node {
                  id
                  quantity
                  merchandise {
                    ... on ProductVariant {
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
                        featuredImage {
                          id
                          url
                          altText
                        }
                      }
                    }
                  }
                  cost {
                    totalAmount {
                      amount
                      currencyCode
                    }
                  }
                }
              }
            }
          }
          userErrors {
            field
            message
          }
        }
      }
    ''';
  }

  /// Remove cart lines
  /// 
  /// Removes specific items from cart.
  /// 
  /// Query complexity: ~100-200
  static String removeCartLines({
    required String cartId,
    required List<String> lineIds,
  }) {
    final lineIdsJson = lineIds.map((id) => '"$id"').join(', ');

    return '''
      mutation RemoveCartLines {
        cartLinesRemove(
          cartId: "$cartId"
          lineIds: [$lineIdsJson]
        ) {
          cart {
            id
            checkoutUrl
            totalQuantity
            cost {
              totalAmount {
                amount
                currencyCode
              }
              subtotalAmount {
                amount
                currencyCode
              }
            }
            lines(first: 250) {
              edges {
                node {
                  id
                  quantity
                  merchandise {
                    ... on ProductVariant {
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
                        featuredImage {
                          id
                          url
                          altText
                        }
                      }
                    }
                  }
                  cost {
                    totalAmount {
                      amount
                    }
                  }
                }
              }
            }
          }
          userErrors {
            field
            message
          }
        }
      }
    ''';
  }

  /// Update cart buyer identity
  /// 
  /// Associates cart with customer email or country.
  /// 
  /// Query complexity: ~50-100
  static String updateCartBuyerIdentity({
    required String cartId,
    String? email,
    String? countryCode,
  }) {
    final emailParam = email != null ? 'email: "$email"' : '';
    final countryParam = countryCode != null ? 'countryCode: $countryCode' : '';
    final buyerIdentity = emailParam.isNotEmpty || countryParam.isNotEmpty
        ? 'buyerIdentity: {$emailParam${emailParam.isNotEmpty && countryParam.isNotEmpty ? ', ' : ''}$countryParam}'
        : '';

    return '''
      mutation UpdateCartBuyerIdentity {
        cartBuyerIdentityUpdate(
          cartId: "$cartId"
          $buyerIdentity
        ) {
          cart {
            id
            buyerIdentity {
              email
              countryCode
            }
          }
          userErrors {
            field
            message
          }
        }
      }
    ''';
  }
}

