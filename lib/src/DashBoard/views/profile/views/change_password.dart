import 'package:bhbd_project/Widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../Widgets/height_width_box.dart';
import '../../../../../resources/resources.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

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
          "Change Password",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Old Password",
                  style: R.textStyles.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                heightBox(5),
                _buildPasswordField(
                  label: "Old Password",
                  controller: _oldPasswordController,
                  obscure: _obscureOld,
                  toggle: () => setState(() => _obscureOld = !_obscureOld),
                ),
                SizedBox(height: 16.h),
                Text(
                  "New Password",
                  style: R.textStyles.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                heightBox(5),
                _buildPasswordField(
                  label: "New Password",
                  controller: _newPasswordController,
                  obscure: _obscureNew,
                  toggle: () => setState(() => _obscureNew = !_obscureNew),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Confirm Password",
                  style: R.textStyles.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                heightBox(5),
                _buildPasswordField(
                  label: "Confirm New Password",
                  controller: _confirmPasswordController,
                  obscure: _obscureConfirm,
                  toggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                SizedBox(height: 30.h),

                AppButton(
                  height: 40.h,
                  backgroundColor: R.color.buttonColor,
                  textColor: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                  title: "Save Changes",
                  onTap: _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) =>
      value == null || value.isEmpty ? "Enter $label" : null,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: R.color.fieldBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: R.color.fieldBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: "Must have at least 6 characters",
        hintStyle: R.textStyles.poppins(
          color: Colors.black38,
          fontSize: 12.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: R.color.buttonColor
          ),
          onPressed: toggle,
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New passwords do not match")),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully!")),
      );
      Navigator.pop(context);
    }
  }
}
