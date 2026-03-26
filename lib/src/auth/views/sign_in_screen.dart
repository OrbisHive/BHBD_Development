import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:bhbd_project/src/auth/views/signUp_screen.dart';
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
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final AuthVM _authVM = AuthVM();
  bool _showPasswordField = false;
  bool _obscurePassword = true;

  /// Continue is enabled only when both email and password have text.
  bool get _continueEnabled {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    return _showPasswordField && email.isNotEmpty && password.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    if (!_continueEnabled) return;

    final email = _emailController.text.trim();
    await _authVM.quickLogin(email);
    Get.offAll(() => const DashBoardView());
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
                constraints: BoxConstraints(maxWidth: 460.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
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
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       // Front-end only for now; backend integration will be added later.
                      //       Get.snackbar('Info', 'Sign in with shop');
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: const Color(0xFF5C3BFF),
                      //       foregroundColor: Colors.white,
                      //       padding: EdgeInsets.symmetric(vertical: 16.h),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //       elevation: 0,
                      //     ),
                      //     child: Text(
                      //       "Sign in with shop",
                      //       style: GoogleFonts.poppins(
                      //         fontSize: 16.sp,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // Divider with "or"


                      // Email input
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: _showPasswordField
                            ? TextInputAction.next
                            : TextInputAction.done,
                        onFieldSubmitted: (_) {
                          if (_emailController.text.trim().isEmpty) return;
                          if (!_showPasswordField) {
                            setState(() => _showPasswordField = true);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) _passwordFocus.requestFocus();
                            });
                            return;
                          }
                          _passwordFocus.requestFocus();
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
                            borderSide: BorderSide(
                              color: R.color.buttonColor,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                        ),
                      ),
                      if (_showPasswordField) ...[
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            if (_continueEnabled) _onContinuePressed();
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
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
                              borderSide: BorderSide(
                                color: R.color.buttonColor,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey[600],
                                size: 22.sp,
                              ),
                              onPressed: () {
                                setState(
                                  () => _obscurePassword = !_obscurePassword,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 20.h),

                      // Continue only when email and password are both non-empty.
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _continueEnabled ? _onContinuePressed : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _continueEnabled
                                ? Colors.black87
                                : const Color(0xFFF3F3F4),
                            foregroundColor: _continueEnabled
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
                      heightBox(20),
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
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Text("Don't have an Account?",style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 15.sp,
                          ),),
                          TextButton(onPressed: (){
                            Get.to(()=>SignUpScreen());
                          }, child: Text("SignUp",style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15.sp,
                          ),))
                        ],
                      )
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
