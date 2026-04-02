import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bhbd_project/services/api_header.dart';
import 'package:bhbd_project/services/project_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../Widgets/show_message_screen.dart';
class ApiRequests {
  Future get({
    String? url,
    Function(dynamic)? onSuccess,
    Function(String)? onError,
  }) async
  {
    bool isConnected = await checkInternet();
    if (!isConnected) {
      return false;
    }
    try {
      ProjectFunctions.mainPrint("this is get Url: $url");
      ProjectFunctions.mainPrint(
        "this is header: ${jsonEncode(MyHeaders.header())}",
      );
      var response = await http
          .get(Uri.parse(url!), headers: MyHeaders.header())
          .timeout(
            const Duration(minutes: 3),
            onTimeout: () {
              throw Exception("Request Time Out");
            },
          );

      ProjectFunctions.mainPrint(response.body);
      ProjectFunctions.loggerPrint(response.body);
      //print(response.body);
      log(response.statusCode.toString());
      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 401) {
        onError!(jsonResponse["title"]);
      } else if (response.statusCode == 201 || response.statusCode == 200) {
        onSuccess!(jsonResponse);
      } else {
        onError!(jsonResponse["title"]);
      }
    } catch (e) {
      onError!(e.toString());
    }
  }

  Future delete({
    String? url,
    var body,
    Function(Map)? onSuccess,
    Function(String)? onError,
  }) async {
    bool isConnected = await checkInternet();
    if (!isConnected) {
      return false;
    }
    try {
      ProjectFunctions.mainPrint("this is get Url: $url");
      ProjectFunctions.mainPrint(
        "this is header: ${jsonEncode(MyHeaders.header())}",
      );
      var response = await http
          .delete(Uri.parse(url!), headers: MyHeaders.header(), body: body)
          .timeout(
            const Duration(minutes: 3),
            onTimeout: () {
              throw Exception("Request Time Out");
            },
          );
      ProjectFunctions.mainPrint(response.body);
      ProjectFunctions.mainPrint("${response.statusCode}");
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        onSuccess!(jsonResponse);
      } else {
        onError!(jsonResponse["title"]);
      }
    } catch (e) {
      onError!(e.toString());
    }
  }

  Future postSignup({
    String? url,
    dynamic body,
    Function(dynamic)? onSuccess,
    Function(List<String>)? onError,
  }) async {
    try {
      bool isConnected = await checkInternet();
      if (!isConnected) {
        ShowMessage.inDialog('No Internet Connection', true);
        return false;
      }
      log("this is url: $url");
      log("this is header: ${MyHeaders.header()}");
      log("this is body: $body");
      var response = await http
          .post(Uri.parse(url!), headers: MyHeaders.header(), body: body)
          .timeout(
            const Duration(minutes: 3),
            onTimeout: () {
              throw Exception("Request Time Out");
            },
          );
      ProjectFunctions.mainPrint(response.body);
      ProjectFunctions.mainPrint("${response.statusCode}");

      var jsonResponse = jsonDecode(response.body);
      //ProjectFunctions.mainPrint("aqib ${jsonEncode(jsonResponse["errors"])}");
      if (response.statusCode == 401) {
        onError!(ProjectFunctions.getError(jsonDecode(response.body)));
      } else if (response.statusCode == 201 || response.statusCode == 200) {
        onSuccess!(jsonDecode(response.body));
      } else {
        log("error");
        onError!(ProjectFunctions.getError(jsonDecode(response.body)));
      }
    } catch (e) {
      log("catch");
      log("$e");
      onError!(ProjectFunctions.getError(e));
    }
  }

  Future post({
    String? url,
    dynamic body,
    Function(dynamic)? onSuccess,
    Function(String)? onError,
  }) async {
    try {
      bool isConnected = await checkInternet();
      if (!isConnected) {
        ShowMessage.inDialog('No Internet Connection', true);
        return false;
      }
      debugPrint("this is url: $url");
      debugPrint("this is header: ${MyHeaders.header()}");
      debugPrint("this is body: $body");
      var response = await http
          .post(Uri.parse(url!), headers: MyHeaders.header(), body: body)
          .timeout(
            const Duration(minutes: 3),
            onTimeout: () {
              throw Exception("Request Time Out");
            },
          );
      ProjectFunctions.mainPrint(response.body);
      ProjectFunctions.mainPrint("${response.statusCode}");

      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 401) {
        // onError!(ProjectFunctions.getError(jsonDecode(response.body)));
      } else if (response.statusCode == 201 || response.statusCode == 200) {
        onSuccess!(jsonDecode(response.body));
      } else {
        onError!(jsonResponse["title"]);
      }
    } catch (e) {
      onError!(e.toString());
    }
  }

  //ll
  Future postLogin({
    String? url,
    dynamic body,
    Function(Map)? onSuccess,
    Function(String)? onError,
  }) async {
    log("this is body: $body");
    try {
      bool isConnected = await checkInternet();
      if (!isConnected) {
        ShowMessage.inDialog('No Internet Connection', true);
        return false;
      }
      ProjectFunctions.mainPrint("this is url: $url");
      var response = await http
          .post(
            Uri.parse(url!),
            headers: {'Content-type': 'application/json', 'Authorization': ""},
            body: body,
          )
          .timeout(
            const Duration(minutes: 3),
            onTimeout: () {
              throw Exception("Request Time Out");
            },
          );
      log(response.body);
      log(response.statusCode.toString());
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 401) {
      } else if (response.statusCode == 201 || response.statusCode == 200) {
        onSuccess!(jsonDecode(response.body));
      } else {
        onError!(jsonResponse["title"]);
      }
    } catch (e) {
      ShowMessage.inDialog(e.toString(), true);
      onError!(e.toString());
    }
  }

  Future put({
    String? url,
    var body,
    Function(Map)? onSuccess,
    Function(String)? onError,
  }) async {
    try {
      bool isConnected = await checkInternet();
      if (!isConnected) {
        ShowMessage.inDialog('No Internet Connection', true);
        return false;
      }
      ProjectFunctions.mainPrint("this is put url: $url");
      ProjectFunctions.mainPrint("put request body: $body");
      ProjectFunctions.mainPrint("this is header: ${MyHeaders.header()}");
      var response = await http
          .put(Uri.parse(url!), headers: MyHeaders.header(), body: body)
          .timeout(
            const Duration(minutes: 3),
            onTimeout: () {
              throw Exception("Request Time Out");
            },
          );
      ProjectFunctions.mainPrint("${response.statusCode}");
      ProjectFunctions.mainPrint(response.body);

      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 401) {
      } else if (response.statusCode == 201 || response.statusCode == 200) {
        onSuccess!(jsonResponse);
      } else {
        onError!(jsonResponse["title"]);
      }
    } catch (e) {
      onError!(e.toString());
    }
  }

  Future<bool> checkInternet() async {
    // return Future.value(true);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ProjectFunctions.mainPrint('connected');
        return true;
      }
    } on SocketException catch (_) {
      ProjectFunctions.mainPrint('not connected');
      return false;
    }
    return false;
  }
}
