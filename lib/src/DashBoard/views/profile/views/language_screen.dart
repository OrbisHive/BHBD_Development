
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../Widgets/height_width_box.dart';
import '../../../../../resources/resources.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  bool isChecked = true; // Default English selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.backGroundColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: R.color.backGroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.fromLTRB(18, 15, 0, 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(.1),
                  blurRadius: 0.5,
                  spreadRadius: 0.2,
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          ),
        ),
        title: Text(
          "Language",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isChecked = !isChecked; // toggle check/uncheck
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: R.color.buttonColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isChecked
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isChecked ? R.color.buttonColor : Colors.grey,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "English",
                      style: R.textStyles.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: R.color.buttonColor,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isChecked
                          ? "English selected"
                          : "No language selected"),
                    ),
                  );
                },
                child: Text(
                  "Save changes",
                  style: R.textStyles.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            heightBox(30),
          ],
        ),
      ),
    );
  }
}
