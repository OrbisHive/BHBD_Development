import 'dart:convert';

import 'package:bhbd_project/Constants/apis_urls.dart';
import 'package:bhbd_project/Constants/app_data.dart';
import 'package:bhbd_project/Constants/user_data.dart';
import 'package:bhbd_project/Widgets/show_message_screen.dart';
import 'package:flutter/material.dart';
import '../utils/token_manager.dart';

class AuthVM extends ChangeNotifier {
  Future<void> login({required Map map}) async {
    AppData.apiRequests.post(
      body: jsonEncode(map),
      url: ApisUrls.login,
      onSuccess: (s) {
        String? customerAccessToken =
            s["data"]["customerAccessTokenCreate"]["customerAccessToken"];
        debugPrint("customerAccessToken $customerAccessToken");

        if (customerAccessToken != null) {
          UserData.userAccessToken = customerAccessToken;

          update();
        } else {
          try {
            List<String> newErrors = [];
            List<dynamic> errors =
                s["data"]["customerAccessTokenCreate"]["customerUserErrors"];
            debugPrint("errors $errors");
            for (var e in errors) {
              newErrors.add(e.toString());
            }

            ShowMessage.inDialogList(newErrors, true);
          } catch (e) {
            debugPrint("catch $e");
          }
        }
      },
      onError: (s) {},
    );
  }

  void update() {
    notifyListeners();
  }

  //////////////////////
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  String? errorMessage;
  String? authToken;
  String? userEmail;

  /// Send OTP to the provided email.
  /// Integrate your API call inside this method.
  Future<void> sendOtp({required String email}) async {
    isSendingOtp = true;
    errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implement API call using your HTTP client.
      // Example (pseudo):
      // final response = await http.post(ApisEndPoints.sendOtp, body: {...});
      // handle response and errors
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isSendingOtp = false;
      notifyListeners();
    }
  }

  /// Verify the OTP for the given email.
  /// Integrate your API call inside this method.
  Future<void> verifyOtp({required String email, required String code}) async {
    isVerifyingOtp = true;
    errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implement API call using your HTTP client.
      // Example (pseudo):
      // final response = await http.post(ApisEndPoints.verifyOtp, body: {...});
      // final token = response['data']['token']; // Extract token from response
      // await saveToken(token, email); // Save token and email

      // After successful verification, save token:
      // await saveToken('your-token-here', email);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isVerifyingOtp = false;
      notifyListeners();
    }
  }

  /// Save authentication token and email
  /// Call this after successful login/verification
  Future<void> saveToken(String token, String email) async {
    authToken = token;
    userEmail = email;
    await TokenManager.saveAuthToken(token);
    await TokenManager.saveUserEmail(email);
    notifyListeners();
  }

  /// Load stored token and email
  /// Call this on app startup to restore session
  Future<void> loadStoredToken() async {
    authToken = await TokenManager.getAuthToken();
    userEmail = await TokenManager.getUserEmail();
    notifyListeners();
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await TokenManager.isAuthenticated();
  }

  /// Logout - clear all tokens
  Future<void> logout() async {
    authToken = null;
    userEmail = null;
    await TokenManager.clearAllTokens();
    notifyListeners();
  }

  /// Clear any stored error.
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  /// Quick login (skip OTP for now)
  /// Saves email and generates a temporary token for development
  Future<void> quickLogin(String email) async {
    // For now, we'll just save the email
    // When you integrate backend, replace this with actual token from API
    userEmail = email;
    await TokenManager.saveUserEmail(email);

    // TODO: Replace with actual token from your backend
    // For development, you can use a placeholder or generate a session token
    // await saveToken('temp-token-${DateTime.now().millisecondsSinceEpoch}', email);

    notifyListeners();
  }
}
