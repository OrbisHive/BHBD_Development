import 'dart:io';
import 'package:bhbd_project/Widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../../Widgets/height_width_box.dart';
import '../../../../../resources/resources.dart'; //

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(
    text: "Bill Norman",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "billnorman@email.com",
  );
  File? profileImage;
  final ImagePicker _picker = ImagePicker();
  String? selectedGender;
  bool obscurePassword = true;
  String fullNumber = "";

  /// Pick Image from Camera/Gallery
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[100], //
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Indicator
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 8, bottom: 12),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: R.color.splashBG,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Center(
                child: Text(
                  "Please  Choose  An Image",
                  style: R.textStyles.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              heightBox(15),
              // Options
              ListTile(
                leading:  Icon(Icons.photo_camera, color: R.color.buttonColor),
                title: Text(
                  "Take a Photo",
                  style: R.textStyles.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() => profileImage = File(picked.path));
                  }
                },
              ),
              ListTile(
                leading:  Icon(Icons.photo_library, color: R.color.buttonColor),
                title: Text(
                  "Choose from Gallery",
                  style: R.textStyles.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() => profileImage = File(picked.path));
                  }
                },
              ),
              if (profileImage != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    "Remove Photo",
                    style: R.textStyles.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => profileImage = null);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

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
          "Edit Profile",
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
                // Profile Photo
                Text(
                  "Profile Photo",
                  style: R.textStyles.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                heightBox(8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: R.color.fieldBorderColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: const Color(0xFFF3F3F3),
                          backgroundImage: profileImage != null
                              ? FileImage(profileImage!)
                              : null,
                          child: profileImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 34,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileImage == null
                                  ? "Upload Profile Photo"
                                  : "Change Profile Photo",
                              style: R.textStyles.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "JPEG/PNG only • Tap to upload",
                              style: R.textStyles.poppins(
                                color: R.color.lightGreyColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                heightBox(16),
                // Full Name
                Text(
                  "Full Name",
                  style: R.textStyles.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                heightBox(5),
                TextFormField(
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
                    hintText: "john",
                    hintStyle: R.textStyles.poppins(
                      color: Colors.black38,
                      fontSize: 12.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                heightBox(16),
                //Email
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
                    hintText: "john@gmail.com",
                    hintStyle: R.textStyles.poppins(
                      color: Colors.black38,
                      fontSize: 12.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                heightBox(16),
                // Phone
                Text(
                  "Phone Number",
                  style: R.textStyles.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                heightBox(5),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 26.5, 8, 5),
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: R.color.fieldBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IntlPhoneField(
                    style: R.textStyles.poppins(
                      color: Colors.black,
                      fontSize: 13.sp,
                    ),
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: "123 456 789",
                      hintStyle: R.textStyles.poppins(
                        color: R.color.lightGreyColor,
                        fontSize: 13.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    initialCountryCode: 'GB', // 🇬🇧 Default to United Kingdom (+44)
                    dropdownIcon: Icon(Icons.arrow_drop_down, size: 18),
                    onChanged: (phone) {
                      setState(() {
                        fullNumber = phone.completeNumber;
                      });
                      print("Phone: ${phone.completeNumber}");
                    },
                  ),
                ),

              heightBox(180),
                AppButton(
                  title: "Save Changes",
                  onTap: () {
                    Get.back();
                  },
                  height: 40.h,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.white,
                  backgroundColor: R.color.buttonColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
