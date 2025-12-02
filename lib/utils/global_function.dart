
import 'package:bhbd_project/utils/show_messages.dart';
import 'package:flutter/services.dart';

class GlobalFunctions {
  static DateTime? currentPress;
  static void onPopInvoked() {
    DateTime now = DateTime.now();
    if (currentPress == null ||
        now.difference(currentPress!) > const Duration(seconds: 2)) {
      currentPress = now;

      ShowMessage.toast(
        "press again to exit",
      );

      return;
    } else {
      SystemNavigator.pop();
    }
  }
}
