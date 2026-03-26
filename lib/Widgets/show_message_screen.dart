
import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:bhbd_project/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';



class ShowMessage {
  static errorSnackBar(String message) {
    return Get.snackbar("Error", message,
        colorText: R.colors.whiteColor, backgroundColor: R.colors.red);
  }

  static successSnackBar(String message) {
    return Get.snackbar("Success!", message,
        colorText: R.colors.whiteColor, backgroundColor: R.colors.primaryColor);
  }

  // static Widget noInternetWidget({double scale = 2}) {
  //   return Center(
  //       child: Image.asset(
  //     R.images.noInternetGif,
  //     scale: scale,
  //   ));
  // }

  static void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 11.sp,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  static void inDialog(String message, bool isError) {
    Get.dialog(
      Center(
        child: Container(
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.03,
          ),
          child: Material(
            color: const Color(0xffe1e0e0).withOpacity(.95),
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Get.height * 0.016,
                ),
                Text("Unable To Retrieve Data",
                    textAlign: TextAlign.center,
                    style: R.textStyles.poppins().copyWith(
                        color: R.colors.blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * 0.045)),
                SizedBox(
                  height: Get.height * 0.016,
                ),
                SizedBox(
                  width: Get.width * 0.7,
                  child: Text(
                      message.contains("<!DOCTYPE html")
                          ? "Server Error"
                          : message.contains(
                                  "SocketException: Connection reset by peer")
                              ? "Slow Internet Connection"
                              : message,
                      textAlign: TextAlign.center,
                      style: R.textStyles.poppins()),
                ),
                SizedBox(height: Get.height * 0.02),
                const Divider(
                  thickness: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    color: R.colors.transparent,
                    height: Get.height * 0.05,
                    width: Get.width,
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        'OK',
                        style:
                            R.textStyles.poppins(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.transparent,
    );
  }

  static void inDialogList(List<String> message, bool isError) {
    Get.dialog(
      Center(
        child: Container(
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.03,
          ),
          child: Material(
            color: const Color(0xffe1e0e0).withOpacity(.95),
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Get.height * 0.016,
                ),
                Text("Unable To Retrieve Data",
                    textAlign: TextAlign.center,
                    style: R.textStyles.poppins().copyWith(
                        color: R.colors.blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * 0.045)),
                SizedBox(
                  height: Get.height * 0.016,
                ),
                message.contains("<!DOCTYPE html")
                    ? SizedBox(
                        width: Get.width * 0.7,
                        child: Text("Server Error",
                            textAlign: TextAlign.center,
                            style: R.textStyles.poppins()))
                    : message.contains(
                            "SocketException: Connection reset by peer")
                        ? SizedBox(
                            width: Get.width * 0.7,
                            child: Text("Slow Internet Connection",
                                textAlign: TextAlign.center,
                                style: R.textStyles.poppins()))
                        : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(message.length, (index)
                          {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                   const Icon(Icons.error,color: Colors.red,),
                                  widthBox(3),
                                  SizedBox(
                                    width: Get.width * 0.7,
                                    child: Text(
                                        message[index],
                                        textAlign: TextAlign.start,
                                        style: R.textStyles.poppins()),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                SizedBox(height: Get.height * 0.02),
                const Divider(
                  thickness: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    color: R.colors.transparent,
                    height: Get.height * 0.05,
                    width: Get.width,
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        'OK',
                        style:
                            R.textStyles.poppins(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.transparent,
    );
  }
}
