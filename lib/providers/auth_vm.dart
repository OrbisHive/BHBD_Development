import 'dart:convert';

import 'package:bhbd_project/Constants/apis_urls.dart';
import 'package:bhbd_project/Constants/app_data.dart';
import 'package:bhbd_project/Constants/user_data.dart';
import 'package:bhbd_project/Widgets/show_message_screen.dart';
import 'package:bhbd_project/models/customer_profile_model.dart';
import 'package:bhbd_project/services/queries.dart';
import 'package:bhbd_project/src/DashBoard/dash_board_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/token_manager.dart';

class AuthVM extends ChangeNotifier {
  bool isSigningUp = false;

  List<String> _extractMessagesFromList(List<dynamic> errors) {
    return errors
        .map((e) => (e is Map<String, dynamic>)
            ? (e["message"] ?? e.toString()).toString()
            : e.toString())
        .toList();
  }

  void _showErrorMessages(List<String> messages) {
    final filtered = messages.where((e) => e.trim().isNotEmpty).toList();
    if (filtered.isEmpty) {
      ShowMessage.inDialog("Something went wrong", true);
      return;
    }
    if (filtered.length == 1) {
      ShowMessage.inDialog(filtered.first, true);
      return;
    }
    ShowMessage.inDialogList(filtered, true);
  }

  Future<String> _getCustomerAccessToken() async {
    String token = UserData.userAccessToken;
    if (token.isEmpty) {
      token = await TokenManager.getShopifyCustomerToken() ?? "";
    }
    if (token.isEmpty) {
      token = await TokenManager.getAuthToken() ?? "";
    }
    return token;
  }

  Future<void> login({required Map map}) async {
    AppData.apiRequests.post(
      body: jsonEncode(map),
      url: ApisUrls.login,
      onSuccess: (s) {
        try {
          final Map<String, dynamic> response = s as Map<String, dynamic>;
          final List<dynamic> topLevelErrors =
              response["errors"] as List<dynamic>? ?? [];
          if (topLevelErrors.isNotEmpty) {
            _showErrorMessages(_extractMessagesFromList(topLevelErrors));
            return;
          }

          final Map<String, dynamic>? tokenCreate =
              response["data"]?["customerAccessTokenCreate"]
                  as Map<String, dynamic>?;

          final List<dynamic> userErrors =
              tokenCreate?["customerUserErrors"] as List<dynamic>? ?? [];
          if (userErrors.isNotEmpty) {
            _showErrorMessages(_extractMessagesFromList(userErrors));
            return;
          }

          final String? customerAccessToken =
              tokenCreate?["customerAccessToken"]?["accessToken"]?.toString();

          if (customerAccessToken == null || customerAccessToken.isEmpty) {
            ShowMessage.inDialog("Unable to login. Please try again.", true);
            return;
          }

          UserData.userAccessToken = customerAccessToken;
          TokenManager.saveShopifyCustomerToken(customerAccessToken);
          Get.snackbar("Account Login", "Account logged in successfully");
          Get.offAll(() => DashBoardView());
          update();
        } catch (e) {
          ShowMessage.inDialog(e.toString(), true);
        }
      },
      onError: (s) {
        ShowMessage.inDialog(s, true);
      },
    );
  }

  void update() {
    notifyListeners();
  }
  Future<bool> signUp({required Map map}) async {
    isSigningUp = true;
    notifyListeners();

    bool isSuccess = false;
    await AppData.apiRequests.postSignup(
      body: jsonEncode(map),
      url: ApisUrls.signUp,
      onSuccess: (s) {
        try {
          final Map<String, dynamic> response = s as Map<String, dynamic>;
          final List<dynamic> topLevelErrors =
              response["errors"] as List<dynamic>? ?? [];
          if (topLevelErrors.isNotEmpty) {
            _showErrorMessages(_extractMessagesFromList(topLevelErrors));
            return;
          }

          final Map<String, dynamic>? customerCreate =
              response["data"]?["customerCreate"] as Map<String, dynamic>?;
          final List<dynamic> errors =
              customerCreate?["customerUserErrors"] as List<dynamic>? ?? [];

          if (errors.isNotEmpty) {
            _showErrorMessages(_extractMessagesFromList(errors));
            return;
          }

          final dynamic customer = customerCreate?["customer"];
          if (customer != null) {
            isSuccess = true;
            ShowMessage.inDialog("Account created successfully", false);
          } else {
            ShowMessage.inDialog("Unable to create account", true);
          }
        } catch (e) {
          ShowMessage.inDialog(e.toString(), true);
        }
      },
      onError: (errors) {
        _showErrorMessages(errors);
      },
    );

    isSigningUp = false;
    notifyListeners();
    return isSuccess;
  }

  Future<CustomerProfileModel?> getProfile() async {
    final String token = await _getCustomerAccessToken();

    if (token.isEmpty) {
      ShowMessage.inDialog("Access token not found", true);
      return null;
    }

    CustomerProfileModel? profile;
    final Map<String, dynamic> map = {
      "query": ApiQuery.getProfileQuery,
      "variables": {"customerAccessToken": token},
    };

    await AppData.apiRequests.post(
      body: jsonEncode(map),
      url: ApisUrls.getProfile,
      onSuccess: (s) {
        try {
          final Map<String, dynamic> response = s as Map<String, dynamic>;
          final List<dynamic> topLevelErrors =
              response["errors"] as List<dynamic>? ?? [];
          if (topLevelErrors.isNotEmpty) {
            _showErrorMessages(_extractMessagesFromList(topLevelErrors));
            return;
          }

          profile = CustomerProfileModel.fromJson(response);
          if (profile?.data?.customer == null) {
            ShowMessage.inDialog("Unable to fetch profile data", true);
          }
        } catch (e) {
          ShowMessage.inDialog(e.toString(), true);
        }
      },
      onError: (s) {
        ShowMessage.inDialog(s, true);
      },
    );
    return profile;
  }

  Future<bool> updatePassword({required String newPassword}) async {
    final String token = await _getCustomerAccessToken();

    if (token.isEmpty) {
      ShowMessage.inDialog("Access token not found", true);
      return false;
    }

    bool isSuccess = false;
    final Map<String, dynamic> map = {
      "query": ApiQuery.updatePasswordQuery,
      "variables": {
        "customerAccessToken": token,
        "customer": {"password": newPassword},
      },
    };

    await AppData.apiRequests.post(
      body: jsonEncode(map),
      url: ApisUrls.updatePassword,
      onSuccess: (s) {
        final Map<String, dynamic> response = s as Map<String, dynamic>;

        final List<dynamic> topLevelErrors = response["errors"] as List<dynamic>? ?? [];
        if (topLevelErrors.isNotEmpty) {
          _showErrorMessages(_extractMessagesFromList(topLevelErrors));
          return;
        }

        final Map<String, dynamic>? customerUpdate =
            response["data"]?["customerUpdate"] as Map<String, dynamic>?;

        final List<dynamic> userErrors =
            customerUpdate?["customerUserErrors"] as List<dynamic>? ?? [];
        if (userErrors.isNotEmpty) {
          _showErrorMessages(_extractMessagesFromList(userErrors));
          return;
        }

        if (customerUpdate?["customer"] != null) {
          isSuccess = true;
        } else {
          ShowMessage.inDialog("Unable to update password", true);
        }
      },
      onError: (s) {
        ShowMessage.inDialog(s, true);
      },
    );

    return isSuccess;
  }

  Future<List<Map<String, dynamic>>> getAllAddresses() async {
    final String token = await _getCustomerAccessToken();
    if (token.isEmpty) {
      ShowMessage.inDialog("Access token not found", true);
      return [];
    }

    final Map<String, dynamic> map = {
      "query": ApiQuery.getAllAddressQuery,
      "variables": {"customerAccessToken": token},
    };

    final List<Map<String, dynamic>> addresses = [];
    await AppData.apiRequests.post(
      body: jsonEncode(map),
      url: ApisUrls.getAllAddress,
      onSuccess: (s) {
        try {
          final Map<String, dynamic> response = s as Map<String, dynamic>;
          final List<dynamic> topLevelErrors =
              response["errors"] as List<dynamic>? ?? [];
          if (topLevelErrors.isNotEmpty) {
            _showErrorMessages(_extractMessagesFromList(topLevelErrors));
            return;
          }

          final Map<String, dynamic>? customer =
              response["data"]?["customer"] as Map<String, dynamic>?;
          if (customer == null) {
            ShowMessage.inDialog(
              "Unable to fetch addresses. Please login again with a valid account token.",
              true,
            );
            return;
          }

          final List<dynamic> edges =
              customer["addresses"]?["edges"] as List<dynamic>? ??
                  [];
          final String? defaultAddressId =
              customer["defaultAddress"]?["id"]?.toString();

          for (final edge in edges) {
            final node = edge["node"] as Map<String, dynamic>?;
            if (node == null) continue;
            addresses.add({
              "id": node["id"]?.toString() ?? "",
              "firstName": node["firstName"]?.toString() ?? "",
              "lastName": node["lastName"]?.toString() ?? "",
              "address1": node["address1"]?.toString() ?? "",
              "address2": node["address2"]?.toString() ?? "",
              "city": node["city"]?.toString() ?? "",
              "province": node["province"]?.toString() ?? "",
              "country": node["country"]?.toString() ?? "",
              "zip": node["zip"]?.toString() ?? "",
              "phone": node["phone"]?.toString() ?? "",
              "isDefault":
                  (defaultAddressId != null && defaultAddressId == node["id"]),
            });
          }
        } catch (e) {
          ShowMessage.inDialog(e.toString(), true);
        }
      },
      onError: (s) {
        ShowMessage.inDialog(s, true);
      },
    );
    return addresses;
  }

  Future<bool> addAddress({required Map<String, dynamic> address}) async {
    final String token = await _getCustomerAccessToken();
    if (token.isEmpty) {
      ShowMessage.inDialog("Access token not found", true);
      return false;
    }

    final Map<String, dynamic> cleanedAddress = Map<String, dynamic>.from(address);
    final String province = (cleanedAddress["province"] ?? "").toString().trim();
    if (province.isEmpty) {
      cleanedAddress.remove("province");
    }

    bool isSuccess = false;
    final Map<String, dynamic> map = {
      "query": ApiQuery.addAddressQuery,
      "variables": {"customerAccessToken": token, "address": cleanedAddress},
    };

    await AppData.apiRequests.post(
      body: jsonEncode(map),
      url: ApisUrls.newAddress,
      onSuccess: (s) {
        try {
          final Map<String, dynamic> response = s as Map<String, dynamic>;
          final List<dynamic> topLevelErrors =
              response["errors"] as List<dynamic>? ?? [];
          if (topLevelErrors.isNotEmpty) {
            _showErrorMessages(_extractMessagesFromList(topLevelErrors));
            return;
          }

          final Map<String, dynamic>? addressCreate =
              response["data"]?["customerAddressCreate"]
                  as Map<String, dynamic>?;
          final List<dynamic> userErrors =
              addressCreate?["customerUserErrors"] as List<dynamic>? ?? [];
          if (userErrors.isNotEmpty) {
            _showErrorMessages(_extractMessagesFromList(userErrors));
            return;
          }

          if (addressCreate?["customerAddress"] != null) {
            isSuccess = true;
          } else {
            ShowMessage.inDialog("Unable to add address", true);
          }
        } catch (e) {
          ShowMessage.inDialog(e.toString(), true);
        }
      },
      onError: (s) {
        ShowMessage.inDialog(s, true);
      },
    );
    return isSuccess;
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
