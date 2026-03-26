/// Token Usage Examples
/// 
/// This file shows how to use TokenManager in your API calls.
/// Delete this file once you've integrated the tokens into your API calls.

/*
// Example 1: Using token in HTTP requests
import 'package:http/http.dart' as http;
import 'token_manager.dart';
import '../Constants/apis.dart';

Future<void> makeAuthenticatedRequest() async {
  // Get the stored auth token
  final token = await TokenManager.getAuthToken();
  
  if (token == null) {
    // User not authenticated, redirect to login
    return;
  }
  
  // Use token in API request header
  final response = await http.get(
    Uri.parse(ApisEndPoints.someEndpoint),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );
  
  // Handle response...
}

// Example 2: Check authentication before API call
import 'token_manager.dart';

Future<void> fetchUserData() async {
  final isAuthenticated = await TokenManager.isAuthenticated();
  
  if (!isAuthenticated) {
    // Redirect to login screen
    return;
  }
  
  // Proceed with API call
  final token = await TokenManager.getAuthToken();
  // Make authenticated request...
}

// Example 3: Get user email for API calls
import 'token_manager.dart';

Future<void> updateProfile() async {
  final email = await TokenManager.getUserEmail();
  
  if (email == null) {
    // User not logged in
    return;
  }
  
  // Use email in API request
  // final response = await http.post(...);
}

// Example 4: Logout and clear tokens
import 'token_manager.dart';
import 'package:get/get.dart';
import '../src/auth/views/sign_in_screen.dart';

Future<void> logout() async {
  await TokenManager.clearAllTokens();
  Get.offAll(() => SignInScreen());
}

// Example 5: Using with AuthVM Provider
import 'package:provider/provider.dart';
import '../providers/auth_vm.dart';

// In your widget:
final authVM = Provider.of<AuthVM>(context);
final token = authVM.authToken;
final email = authVM.userEmail;

// Or check authentication:
final isAuth = await authVM.isAuthenticated();
*/

