import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../resources/resources.dart';
import '../../../providers/auth_vm.dart';
import '../../DashBoard/dash_board_view.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthVM _authVM = AuthVM();
  bool _isEmailNotEmpty = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 460.w,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
            child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Sign in",
                  style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                  ),
                ),
                      SizedBox(height: 6.h),
                
                // Subtitle
                Text(
                  "Sign in or create an account",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                      SizedBox(height: 28.h),

                      // Sign in with shop button (full width)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                  onPressed: () {
                            // Front-end only for now; backend integration will be added later.
                    Get.snackbar('Info', 'Sign in with shop');
                  },
                  style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C3BFF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Sign in with shop",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                    ),
                  ),
                ),
                      SizedBox(height: 28.h),

                // Divider with "or"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                    ),
                    Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        "or",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                                color: Colors.grey[500],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Email input
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            _isEmailNotEmpty = value.trim().isNotEmpty;
                          });
                        },
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[400],
                            fontSize: 15.sp,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: R.color.buttonColor, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                            vertical: 14.h,
                    ),
                  ),
                ),
                      SizedBox(height: 20.h),

                      // Continue button (disabled style when email empty, full width)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isEmailNotEmpty
                              ? () async {
                                  // Save email for token management
                                  final email = _emailController.text.trim();
                                  await _authVM.quickLogin(email);
                                  
                                  // Skip OTP verification for now - go directly to dashboard
                                  // User can set profile and fetch store data from dashboard
                                  Get.offAll(() => const DashBoardView());
                    }
                              : null,
                  style: ElevatedButton.styleFrom(
                            backgroundColor: _isEmailNotEmpty
                                ? Colors.black87
                                : const Color(0xFFF3F3F4),
                            foregroundColor: _isEmailNotEmpty
                                ? Colors.white
                                : Colors.grey[500],
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

