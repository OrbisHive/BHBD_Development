import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../Widgets/app_button.dart';
import '../../../Widgets/height_width_box.dart';
import '../../../resources/resources.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.fromLTRB(18,15,0,15),
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
          "Forgot Password",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: R.colors.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              /// Title
              Text(
                "Forgot Password",
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              heightBox(5),
              Text(
                "Enter your email to receive reset instructions",
                style: R.textStyles.poppins(
                  fontSize: 13.sp,
                  color: Colors.black54,
                ),
              ),

              heightBox(30),

              /// Email Input
              Text(
                "Email Address",
                style: R.textStyles.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              heightBox(5),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "john@gmail.com",
                  hintStyle: R.textStyles.poppins(
                    color: Colors.black38,
                    fontSize: 12.sp,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: R.colors.fieldBorderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: R.colors.fieldBorderColor, width: 1),
                  ),
                ),
              ),

              heightBox(35),

              /// Reset Button
              AppButton(
                title: "Send Reset Link",
                onTap: () {
                  // TODO: Implement password reset functionality
                },
                height: 40.h,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
                backgroundColor: R.colors.buttonColor,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
