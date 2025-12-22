/// GraphQL Helper Utilities
/// 
/// Provides helper functions for GraphQL operations.

class GraphQLHelper {
  /// Format GraphQL query string
  /// Removes extra whitespace and newlines
  static String formatQuery(String query) {
    return query
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\s*{\s*'), '{')
        .replaceAll(RegExp(r'\s*}\s*'), '}')
        .replaceAll(RegExp(r'\s*,\s*'), ',')
        .trim();
  }

  /// Extract GraphQL ID from GID
  /// Shopify uses GID format: gid://shopify/Product/123456789
  static String extractId(String gid) {
    final parts = gid.split('/');
    return parts.isNotEmpty ? parts.last : gid;
  }

  /// Convert GID to base64 encoded ID
  /// Some operations require base64 encoded IDs
  static String gidToBase64(String gid) {
    // In practice, you might need to base64 encode the GID
    // This is a placeholder - actual implementation depends on Shopify's requirements
    return gid;
  }

  /// Build pagination cursor
  static String? buildCursor(String? after) {
    return after;
  }

  /// Parse error messages from GraphQL response
  static List<String> parseErrors(Map<String, dynamic> response) {
    final errors = <String>[];
    
    if (response.containsKey('errors')) {
      for (var error in response['errors']) {
        if (error is Map<String, dynamic>) {
          errors.add(error['message'] ?? 'Unknown error');
        }
      }
    }
    
    // Check for userErrors in mutations
    if (response.containsKey('data')) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        data.forEach((key, value) {
          if (value is Map<String, dynamic> && value.containsKey('userErrors')) {
            for (var error in value['userErrors']) {
              if (error is Map<String, dynamic>) {
                errors.add(error['message'] ?? 'Unknown error');
              }
            }
          }
          if (value is Map<String, dynamic> && value.containsKey('customerUserErrors')) {
            for (var error in value['customerUserErrors']) {
              if (error is Map<String, dynamic>) {
                errors.add(error['message'] ?? 'Unknown error');
              }
            }
          }
        });
      }
    }
    
    return errors;
  }

  /// Check if response has errors
  static bool hasErrors(Map<String, dynamic> response) {
    if (response.containsKey('errors')) {
      return true;
    }
    
    if (response.containsKey('data')) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        return data.values.any((value) {
          if (value is Map<String, dynamic>) {
            return value.containsKey('userErrors') || 
                   value.containsKey('customerUserErrors') ||
                   value.containsKey('checkoutUserErrors');
          }
          return false;
        });
      }
    }
    
    return false;
  }
}

