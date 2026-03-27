import 'package:bhbd_project/Constants/main_vm.dart';
import 'package:bhbd_project/services/queries.dart';
import 'package:bhbd_project/src/auth/views/signUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Widgets/app_button.dart';
import '../../../resources/resources.dart';
import '../../../Widgets/height_width_box.dart';
import 'forgot_password_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              heightBox(100),

              /// Title
              Text(
                "Welcome Back 👋",
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              heightBox(5),
              Text(
                "Login to continue",
                style: R.textStyles.poppins(
                  fontSize: 13.sp,
                  color: Colors.black54,
                ),
              ),

              heightBox(30),

              /// Email Field
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

              heightBox(16),

              /// Password Field
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
                controller: _passwordController,
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

              heightBox(12),

              /// Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: (){
                    Get.to(()=>ForgotPasswordScreen());
                  },
                  child: Text(
                    "Forgot Password?",
                    style: R.textStyles.poppins(
                      color: R.colors.buttonColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              heightBox(35),

              /// Login Button
              AppButton(
                title: "Login",
                onTap: () {

                  Map map = {
                    "query": ApiQuery.loginQuery,
                    "variables": {
                      "input": {
                        "email": _emailController.text.trim(),
                        "password": _passwordController.text.trim()
                      }
                    }
                  };

                  MainVM.authVM(context).login(map: map);

                 // Get.to(()=>DashBoardView());
                },
                height: 40.h,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
                backgroundColor: R.colors.buttonColor,
              ),

              heightBox(15),

              /// Signup Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: R.textStyles.poppins(
                      color: Colors.black54,
                      fontSize: 13.sp,
                    ),
                  ),
                  widthBox(5),
                  GestureDetector(
                    onTap: () {
                      Get.off(() => SignUpScreen());
                    },
                    child: Text(
                      "Sign Up",
                      style: R.textStyles.poppins(
                        color: R.colors.buttonColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
