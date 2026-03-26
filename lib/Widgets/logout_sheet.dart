import 'package:bhbd_project/Widgets/app_button.dart';
import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:bhbd_project/Widgets/pprimary_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/resources.dart';

class LogoutSheet extends StatelessWidget {
  const LogoutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: const BoxDecoration(
              color: Color(0xFFF8EDED),
              shape: BoxShape.circle,
            ),
            child: Image.asset(R.images.logOut),
          ),
          SizedBox(height: 12.h),
          Text(
            'Logout',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          AppButton(
            title: "Yes, log me out",
            onTap: () {
             // ShowMessage.toast("You Have LoggedOut Successfully");
              Get.back();
            },
            height: 40.h,
            textColor: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
            backgroundColor: R.colors.buttonColor,
          ),
          heightBox(15),
          GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Text(
              "Not Now",
              style: R.textStyles.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ),

          SizedBox(height: 35.h),
        ],
      ),
    );
  }
}
