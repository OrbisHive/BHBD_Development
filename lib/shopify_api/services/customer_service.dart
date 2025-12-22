import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer_model.dart';
import '../queries/customer_queries.dart';
import '../services/shopify_client.dart';

/// Customer Service
/// 
/// Handles customer operations.
/// Requires Storefront API access token.
/// Used to link app users with Shopify customers.

class CustomerService {
  final ShopifyClient client;
  static const String _customerTokenKey = 'shopify_customer_token';
  static const String _customerIdKey = 'shopify_customer_id';

  CustomerService(this.client);

  /// Create customer account
  /// 
  /// Creates a new customer in Shopify.
  /// Requires Storefront API access token.
  /// 
  /// [email] - Customer email
  /// [password] - Customer password
  /// [firstName] - First name
  /// [lastName] - Last name
  /// [phone] - Phone number
  /// [acceptsMarketing] - Marketing consent
  /// 
  /// Returns customer and access token
  Future<CustomerCreateResult> createCustomer({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? phone,
    bool acceptsMarketing = false,
  }) async {
    if (!client.hasToken) {
      throw ShopifyException(
        'Storefront API access token required',
        code: 'ACCESS_DENIED',
      );
    }

    final queryString = CustomerQueries.createCustomer(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      acceptsMarketing: acceptsMarketing,
    );

    final response = await client.query(queryString);

    final createData = response['data']?['customerCreate'];
    if (createData == null) {
      throw ShopifyException('Failed to create customer', code: 'CUSTOMER_ERROR');
    }

    final errors = createData['customerUserErrors'] ?? [];
    if (errors.isNotEmpty) {
      throw ShopifyException(
        errors.map((e) => e['message']).join(', '),
        code: 'CUSTOMER_ERROR',
      );
    }

    final customerData = createData['customer'];
    if (customerData == null) {
      throw ShopifyException('Customer creation failed', code: 'CUSTOMER_ERROR');
    }

    // Note: Customer creation doesn't return access token
    // Customer needs to login separately
    final customer = CustomerModel.fromJson(customerData);

    return CustomerCreateResult(customer: customer);
  }

  /// Customer login
  /// 
  /// Authenticates customer and returns access token.
  /// 
  /// [email] - Customer email
  /// [password] - Customer password
  /// 
  /// Returns customer access token (stored locally)
  Future<CustomerLoginResult> login({
    required String email,
    required String password,
  }) async {
    if (!client.hasToken) {
      throw ShopifyException(
        'Storefront API access token required',
        code: 'ACCESS_DENIED',
      );
    }

    final queryString = CustomerQueries.customerLogin(
      email: email,
      password: password,
    );

    final response = await client.query(queryString);

    final loginData = response['data']?['customerAccessTokenCreate'];
    if (loginData == null) {
      throw ShopifyException('Login failed', code: 'LOGIN_ERROR');
    }

    final errors = loginData['customerUserErrors'] ?? [];
    if (errors.isNotEmpty) {
      throw ShopifyException(
        errors.map((e) => e['message']).join(', '),
        code: 'LOGIN_ERROR',
      );
    }

    final tokenData = loginData['customerAccessToken'];
    if (tokenData == null) {
      throw ShopifyException('Failed to get access token', code: 'LOGIN_ERROR');
    }

    final accessToken = tokenData['accessToken'] as String;
    final expiresAt = tokenData['expiresAt'] != null
        ? DateTime.parse(tokenData['expiresAt'])
        : null;

    // Store token locally
    await _saveCustomerToken(accessToken);

    // Get customer details
    final customer = await getCustomer(accessToken);

    return CustomerLoginResult(
      customer: customer,
      accessToken: accessToken,
      expiresAt: expiresAt,
    );
  }

  /// Customer logout
  /// 
  /// Invalidates customer access token.
  Future<void> logout() async {
    final token = await _getCustomerToken();
    if (token == null) {
      return; // Already logged out
    }

    try {
      final queryString = CustomerQueries.customerLogout(token);
      await client.query(queryString);
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      await _clearCustomerToken();
      await _clearCustomerId();
    }
  }

  /// Get customer by access token
  /// 
  /// [customerAccessToken] - Customer access token (optional, uses stored token)
  /// 
  /// Returns customer details
  Future<CustomerModel> getCustomer([String? customerAccessToken]) async {
    if (!client.hasToken) {
      throw ShopifyException(
        'Storefront API access token required',
        code: 'ACCESS_DENIED',
      );
    }

    final token = customerAccessToken ?? await _getCustomerToken();
    if (token == null) {
      throw ShopifyException('No customer token found', code: 'NOT_AUTHENTICATED');
    }

    final queryString = CustomerQueries.getCustomer(token);

    final response = await client.query(queryString);

    final customerData = response['data']?['customer'];
    if (customerData == null) {
      // Token might be expired, clear it
      await _clearCustomerToken();
      throw ShopifyException('Customer not found or token expired', code: 'NOT_AUTHENTICATED');
    }

    final customer = CustomerModel.fromJson(customerData);

    // Store customer ID
    await _saveCustomerId(customer.id);

    return customer;
  }

  /// Get current customer (from stored token)
  /// 
  /// Returns current customer or throws if not authenticated
  Future<CustomerModel> getCurrentCustomer() async {
    return await getCustomer();
  }

  /// Update customer information
  /// 
  /// [customerAccessToken] - Customer access token (optional, uses stored token)
  /// [firstName] - First name
  /// [lastName] - Last name
  /// [phone] - Phone number
  /// [acceptsMarketing] - Marketing consent
  /// 
  /// Returns updated customer
  Future<CustomerModel> updateCustomer({
    String? customerAccessToken,
    String? firstName,
    String? lastName,
    String? phone,
    bool? acceptsMarketing,
  }) async {
    if (!client.hasToken) {
      throw ShopifyException(
        'Storefront API access token required',
        code: 'ACCESS_DENIED',
      );
    }

    final token = customerAccessToken ?? await _getCustomerToken();
    if (token == null) {
      throw ShopifyException('No customer token found', code: 'NOT_AUTHENTICATED');
    }

    final queryString = CustomerQueries.updateCustomer(
      customerAccessToken: token,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      acceptsMarketing: acceptsMarketing,
    );

    final response = await client.query(queryString);

    final updateData = response['data']?['customerUpdate'];
    if (updateData == null) {
      throw ShopifyException('Failed to update customer', code: 'CUSTOMER_ERROR');
    }

    final errors = updateData['customerUserErrors'] ?? [];
    if (errors.isNotEmpty) {
      throw ShopifyException(
        errors.map((e) => e['message']).join(', '),
        code: 'CUSTOMER_ERROR',
      );
    }

    final customerData = updateData['customer'];
    if (customerData == null) {
      throw ShopifyException('Customer update failed', code: 'CUSTOMER_ERROR');
    }

    return CustomerModel.fromJson(customerData);
  }

  /// Get customer orders
  /// 
  /// [customerAccessToken] - Customer access token (optional, uses stored token)
  /// [first] - Number of orders
  /// [after] - Cursor for pagination
  /// 
  /// Returns customer orders
  Future<CustomerOrdersResult> getCustomerOrders({
    String? customerAccessToken,
    int first = 10,
    String? after,
  }) async {
    if (!client.hasToken) {
      throw ShopifyException(
        'Storefront API access token required',
        code: 'ACCESS_DENIED',
      );
    }

    final token = customerAccessToken ?? await _getCustomerToken();
    if (token == null) {
      throw ShopifyException('No customer token found', code: 'NOT_AUTHENTICATED');
    }

    final queryString = CustomerQueries.getCustomerOrders(
      customerAccessToken: token,
      first: first,
      after: after,
    );

    final response = await client.query(queryString);

    final customerData = response['data']?['customer'];
    if (customerData == null) {
      throw ShopifyException('Customer not found', code: 'NOT_FOUND');
    }

    final ordersData = customerData['orders'] ?? {};
    final edges = ordersData['edges'] as List? ?? [];
    final orders = edges
        .map((edge) => CustomerOrder.fromJson(edge['node']))
        .toList()
        .cast<CustomerOrder>();

    final pageInfo = ordersData['pageInfo'] ?? {};

    return CustomerOrdersResult(
      orders: orders,
      hasNextPage: pageInfo['hasNextPage'] ?? false,
      hasPreviousPage: pageInfo['hasPreviousPage'] ?? false,
      startCursor: pageInfo['startCursor'],
      endCursor: pageInfo['endCursor'],
    );
  }

  /// Check if customer is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _getCustomerToken();
    if (token == null) return false;

    try {
      await getCustomer(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Private methods for token storage

  Future<void> _saveCustomerToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customerTokenKey, token);
  }

  Future<String?> _getCustomerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customerTokenKey);
  }

  Future<void> _clearCustomerToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_customerTokenKey);
  }

  Future<void> _saveCustomerId(String customerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customerIdKey, customerId);
  }

  Future<void> _clearCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_customerIdKey);
  }
}

/// Customer Create Result
class CustomerCreateResult {
  final CustomerModel customer;

  CustomerCreateResult({required this.customer});
}

/// Customer Login Result
class CustomerLoginResult {
  final CustomerModel customer;
  final String accessToken;
  final DateTime? expiresAt;

  CustomerLoginResult({
    required this.customer,
    required this.accessToken,
    this.expiresAt,
  });
}

/// Customer Orders Result
class CustomerOrdersResult {
  final List<CustomerOrder> orders;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? startCursor;
  final String? endCursor;

  CustomerOrdersResult({
    required this.orders,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });
}

