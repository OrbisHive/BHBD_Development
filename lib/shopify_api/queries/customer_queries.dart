/// GraphQL Queries for Customer Operations
/// 
/// Customer operations require Storefront API access token.
/// These queries are used to manage customer accounts and associate
/// app users with Shopify customers.

class CustomerQueries {
  /// Create customer account
  /// 
  /// Creates a new customer in Shopify.
  /// Requires Storefront API access token.
  /// 
  /// Query complexity: ~50-100
  static String createCustomer({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? phone,
    bool acceptsMarketing = false,
  }) {
    return '''
      mutation CreateCustomer {
        customerCreate(
          input: {
            email: "$email"
            password: "$password"
            ${firstName != null ? 'firstName: "$firstName"' : ''}
            ${lastName != null ? 'lastName: "$lastName"' : ''}
            ${phone != null ? 'phone: "$phone"' : ''}
            acceptsMarketing: $acceptsMarketing
          }
        ) {
          customer {
            id
            email
            firstName
            lastName
            phone
            createdAt
            updatedAt
            numberOfOrders
            acceptsMarketing
          }
          customerUserErrors {
            field
            message
            code
          }
        }
      }
    ''';
  }

  /// Get customer by access token
  /// 
  /// Retrieves customer information using customer access token.
  /// Customer access token is obtained after customer login.
  /// 
  /// Query complexity: ~100-200
  static String getCustomer(String customerAccessToken) {
    return '''
      query GetCustomer {
        customer(customerAccessToken: "$customerAccessToken") {
          id
          email
          firstName
          lastName
          phone
          createdAt
          updatedAt
          numberOfOrders
          acceptsMarketing
          defaultAddress {
            id
            address1
            address2
            city
            province
            country
            zip
            firstName
            lastName
            phone
          }
          addresses(first: 10) {
            edges {
              node {
                id
                address1
                address2
                city
                province
                country
                zip
                firstName
                lastName
                phone
              }
            }
          }
          orders(first: 10) {
            edges {
              node {
                id
                name
                orderNumber
                processedAt
                totalPrice {
                  amount
                  currencyCode
                }
                fulfillmentStatus
                financialStatus
                lineItems(first: 10) {
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
                          featuredImage {
                            id
                            url
                            altText
                          }
                        }
                      }
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

  /// Customer login
  /// 
  /// Authenticates customer and returns access token.
  /// Store this token securely for future authenticated requests.
  /// 
  /// Query complexity: ~50-100
  static String customerLogin({
    required String email,
    required String password,
  }) {
    return '''
      mutation CustomerLogin {
        customerAccessTokenCreate(
          input: {
            email: "$email"
            password: "$password"
          }
        ) {
          customerAccessToken {
            accessToken
            expiresAt
          }
          customerUserErrors {
            field
            message
            code
          }
        }
      }
    ''';
  }

  /// Customer logout
  /// 
  /// Invalidates customer access token.
  /// 
  /// Query complexity: ~20-30
  static String customerLogout(String customerAccessToken) {
    return '''
      mutation CustomerLogout {
        customerAccessTokenDelete(
          customerAccessToken: "$customerAccessToken"
        ) {
          deletedAccessToken
          deletedCustomerAccessTokenId
          userErrors {
            field
            message
          }
        }
      }
    ''';
  }

  /// Update customer information
  /// 
  /// Updates customer profile information.
  /// Requires customer access token.
  /// 
  /// Query complexity: ~50-100
  static String updateCustomer({
    required String customerAccessToken,
    String? firstName,
    String? lastName,
    String? phone,
    bool? acceptsMarketing,
  }) {
    final updates = <String>[];
    if (firstName != null) updates.add('firstName: "$firstName"');
    if (lastName != null) updates.add('lastName: "$lastName"');
    if (phone != null) updates.add('phone: "$phone"');
    if (acceptsMarketing != null) updates.add('acceptsMarketing: $acceptsMarketing');

    return '''
      mutation UpdateCustomer {
        customerUpdate(
          customerAccessToken: "$customerAccessToken"
          customer: {
            ${updates.join(', ')}
          }
        ) {
          customer {
            id
            email
            firstName
            lastName
            phone
            acceptsMarketing
          }
          customerUserErrors {
            field
            message
            code
          }
        }
      }
    ''';
  }

  /// Get customer orders
  /// 
  /// Retrieves customer's order history.
  /// Requires customer access token.
  /// 
  /// Query complexity: ~100-200 per order
  static String getCustomerOrders({
    required String customerAccessToken,
    int first = 10,
    String? after,
  }) {
    final cursor = after != null ? ', after: "$after"' : '';

    return '''
      query GetCustomerOrders {
        customer(customerAccessToken: "$customerAccessToken") {
          id
          orders(first: $first$cursor) {
            edges {
              node {
                id
                name
                orderNumber
                processedAt
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
                fulfillmentStatus
                financialStatus
                shippingAddress {
                  address1
                  address2
                  city
                  province
                  country
                  zip
                  firstName
                  lastName
                  phone
                }
                lineItems(first: 50) {
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
                          featuredImage {
                            id
                            url
                            altText
                          }
                        }
                      }
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

