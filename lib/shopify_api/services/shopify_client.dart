import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/shopify_config.dart';
import '../utils/graphql_helper.dart';

/// Shopify API Client
/// 
/// Main client for making GraphQL requests to Shopify Storefront API.
/// Handles authentication, error handling, and request formatting.

class ShopifyClient {
  String? _storefrontAccessToken;
  bool _initialized = false;

  /// Initialize the client
  /// 
  /// Optionally override config values
  Future<void> initialize({
    String? storeDomain,
    String? accessToken,
    String? apiVersion,
  }) async {
    _storefrontAccessToken = accessToken ?? ShopifyConfig.storefrontAccessToken;
    _initialized = true;
  }

  /// Execute GraphQL query
  /// 
  /// [query] - GraphQL query string
  /// [variables] - Optional query variables
  /// [useToken] - Whether to use access token (default: true if token is available)
  /// 
  /// Returns parsed JSON response
  Future<Map<String, dynamic>> query(
    String query, {
    Map<String, dynamic>? variables,
    bool? useToken,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    final shouldUseToken = useToken ?? 
        (_storefrontAccessToken != null && 
         _storefrontAccessToken!.isNotEmpty);

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (shouldUseToken && _storefrontAccessToken != null) {
      headers['X-Shopify-Storefront-Access-Token'] = _storefrontAccessToken!;
    }

    final body = <String, dynamic>{
      'query': GraphQLHelper.formatQuery(query),
    };

    if (variables != null && variables.isNotEmpty) {
      body['variables'] = variables;
    }

    if (ShopifyConfig.enableLogging) {
      print('Shopify API Request: ${ShopifyConfig.storefrontApiUrl}');
      print('Query: ${body['query']}');
    }

    try {
      final response = await http
          .post(
            Uri.parse(ShopifyConfig.storefrontApiUrl),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: ShopifyConfig.requestTimeoutSeconds));

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (ShopifyConfig.enableLogging) {
        print('Shopify API Response: ${response.statusCode}');
        print('Response: ${jsonEncode(responseBody)}');
      }

      // Check for HTTP errors
      if (response.statusCode != 200) {
        throw ShopifyException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          code: 'HTTP_ERROR',
          statusCode: response.statusCode,
        );
      }

      // Check for GraphQL errors
      if (GraphQLHelper.hasErrors(responseBody)) {
        final errors = GraphQLHelper.parseErrors(responseBody);
        final errorCode = _extractErrorCode(responseBody);
        throw ShopifyException(
          errors.join(', '),
          code: errorCode,
        );
      }

      return responseBody;
    } on http.ClientException catch (e) {
      throw ShopifyException(
        'Network error: ${e.message}',
        code: 'NETWORK_ERROR',
      );
    } on FormatException catch (e) {
      throw ShopifyException(
        'Invalid response format: ${e.message}',
        code: 'PARSE_ERROR',
      );
    } catch (e) {
      if (e is ShopifyException) {
        rethrow;
      }
      throw ShopifyException(
        'Unexpected error: ${e.toString()}',
        code: 'UNKNOWN_ERROR',
      );
    }
  }

  /// Extract error code from response
  String _extractErrorCode(Map<String, dynamic> response) {
    if (response.containsKey('errors')) {
      for (var error in response['errors']) {
        if (error is Map<String, dynamic> && 
            error.containsKey('extensions') &&
            error['extensions'] is Map<String, dynamic>) {
          final code = error['extensions']?['code'];
          if (code != null) return code.toString();
        }
      }
    }
    return 'UNKNOWN_ERROR';
  }

  /// Set access token
  void setAccessToken(String token) {
    _storefrontAccessToken = token;
  }

  /// Clear access token
  void clearAccessToken() {
    _storefrontAccessToken = null;
  }

  /// Check if token is set
  bool get hasToken => _storefrontAccessToken != null && 
                       _storefrontAccessToken!.isNotEmpty;
}

/// Shopify API Exception
class ShopifyException implements Exception {
  final String message;
  final String code;
  final int? statusCode;

  ShopifyException(this.message, {required this.code, this.statusCode});

  @override
  String toString() => 'ShopifyException($code): $message';
}

