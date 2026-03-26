import 'dart:convert';
import 'dart:developer' as log;
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:bhbd_project/utils/zbToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';


class ProjectFunctions {
  static DateTime? currentBackPressTime;
  static var logger = Logger();

  static Future<bool> onWillPop() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 3)) {
      currentBackPressTime = now;
      ZBotToast.showToastError(
          message: "Press again to exit app", title: "App Exit");
      return Future.value(false);
    }
    return exit(0);
  }

  static mainPrint(String print) {
    log.log(print);
  }

  static loggerPrint(String print) {
    Logger().i(print);
  }

  static List<String> getError(dynamic map) {
    List<String> error = [];
    log.log("i am here");
    if (map.containsKey("errors")) {
      if (map["errors"].containsKey("email")) {
        error.add(map["errors"]["email"][0]);
      }
      if (map["errors"].containsKey("phone")) {
        error.add(map["errors"]["phone"][0]);
      }
      if (error.isEmpty) {
        error.add(map["errors"].toString());
      }
    }
    return error;
  }

}
