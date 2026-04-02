import 'package:bhbd_project/src/auth/views/login_screen.dart';
import 'package:bhbd_project/Constants/main_vm.dart';
import 'package:bhbd_project/services/queries.dart';
import 'package:bhbd_project/Widgets/show_message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Widgets/app_button.dart';
import '../../../resources/resources.dart';
import '../../../Widgets/height_width_box.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  bool obscurePassword = true;
  bool obscureConfirm = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightBox(35),
              /// Title
              Text(
                "Create Account",
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              heightBox(5),
              Text(
                "Sign up to get started",
                style: R.textStyles.poppins(
                  fontSize: 13.sp,
                  color: Colors.black54,
                ),
              ),

              heightBox(30),

              /// Full Name
              // Text(
              //   "Full Name",
              //   style: R.textStyles.poppins(
              //     color: Colors.black,
              //     fontWeight: FontWeight.w600,
              //     fontSize: 13.sp,
              //   ),
              // ),
              // heightBox(5),
              // TextFormField(
              //   controller: _nameController,
              //   decoration: InputDecoration(
              //     filled: true,
              //     fillColor: Colors.white,
              //     hintText: "John Doe",
              //     hintStyle: R.textStyles.poppins(
              //       color: Colors.black38,
              //       fontSize: 12.sp,
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       borderSide:
              //       BorderSide(color: R.color.fieldBorderColor, width: 1),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       borderSide:
              //       BorderSide(color: R.color.fieldBorderColor, width: 1),
              //     ),
              //   ),
              // ),
              // heightBox(16),

              /// Email Address
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
                  hintText: "example@mail.com",
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
              heightBox(16),

              /// Password
              Text(
                "Password",
                style: R.textStyles.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              heightBox(5),
              TextFormField(
                controller: _passController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter password",
                  hintStyle: R.textStyles.poppins(
                    color: Colors.black38,
                    fontSize: 12.sp,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
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
              heightBox(16),

              /// Confirm Password
              Text(
                "Confirm Password",
                style: R.textStyles.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              heightBox(5),
              TextFormField(
                controller: _confirmController,
                obscureText: obscureConfirm,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Re-enter password",
                  hintStyle: R.textStyles.poppins(
                    color: Colors.black38,
                    fontSize: 12.sp,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirm = !obscureConfirm;
                      });
                    },
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
              //Sign Up Button
              AppButton(
                title: "Sign Up",
                onTap: () async {
                  final email = _emailController.text.trim();
                  final password = _passController.text.trim();
                  final confirmPassword = _confirmController.text.trim();
                  if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                    ShowMessage.inDialog("Please fill all required fields", true);
                    return;
                  }
                  if (password != confirmPassword) {
                    ShowMessage.inDialog("Password and confirm password must match", true);
                    return;
                  }

                  if (password.length < 8) {
                    ShowMessage.inDialog("Password must be at least 8 characters", true);
                    return;
                  }
                  final Map<String, dynamic> map = {
                    "query": ApiQuery.signupQuery,
                    "variables": {
                      "input": {"email": email.trim(), "password": password.trim()},
                    },
                  };

                  final bool created = await MainVM.authVM(context).signUp(map: map);
                  if (created && mounted) {
                    Get.snackbar("Account Created", "Your Account created  successfully");
                    Get.off(() => const LoginScreen());
                  }
                },
                height: 40.h,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
                backgroundColor: R.colors.buttonColor,
              ),
              heightBox(25),

              /// Already have account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: R.textStyles.poppins(
                      color: Colors.black54,
                      fontSize: 13.sp,
                    ),
                  ),
                  widthBox(5),
                  GestureDetector(
                    onTap: () {
                      Get.off(() => LoginScreen());
                    },
                    child: Text(
                      "Login",
                      style: R.textStyles.poppins(
                        color: R.colors.buttonColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),

              heightBox(20),
            ],
          ),
        ),
      ),
    );
  }
}
