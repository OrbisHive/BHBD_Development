import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:bhbd_project/src/DashBoard/views/profile/views/addresses_screen.dart';
import 'package:bhbd_project/src/DashBoard/views/profile/views/change_password.dart';
import 'package:bhbd_project/src/DashBoard/views/profile/views/language_screen.dart';
import 'package:bhbd_project/src/DashBoard/views/profile/views/privacy_policy.dart';
import 'package:bhbd_project/src/DashBoard/views/profile/views/profile_screen_new.dart';
import 'package:bhbd_project/src/DashBoard/views/profile/views/terms_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../Widgets/list_row_widget.dart';
import '../../../../../Widgets/logout_sheet.dart';
import '../../../../../resources/resources.dart';
import 'edit_profile_screen.dart';
import 'my_course_screen.dart';
import 'order_history_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  bool isNotificationOn = true; // initial value
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.backGroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // // ---- User Info ----
              // Container(
              //   padding: EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: Colors.grey[200]!),
              //   ),
              //   child: Row(
              //     children: [
              //       ClipRRect(child: Image.asset(R.images.shop3, scale: 11)),
              //       // CircleAvatar(
              //       //   radius: 36.r,
              //       //   backgroundImage: const AssetImage('assets/avatar_placeholder.png'),
              //       // ),
              //       SizedBox(width: 12.w),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               'Bill Norman',
              //               style: GoogleFonts.poppins(
              //                 fontSize: 15.sp,
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ),
              //
              //             Text(
              //               'billnorman@email.com',
              //               style: GoogleFonts.poppins(
              //                 fontSize: 13.sp,
              //                 color: Colors.grey[600],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // ---- Menu List ----
              Card(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    ListRow(
                      label: 'Edit Profile',
                      onTap:(){
                        Get.to(()=>EditProfileScreen());
                      }
                    ),

                    ListRow(
                      label: 'Change Password',
                        onTap:(){
                          Get.to(()=>ChangePasswordScreen());
                        }
                    ),

                    ListRow(
                      label: 'My Courses',
                        onTap:(){
                          Get.to(()=>MyCoursesScreen());
                        }
                    ),

                    ListRow(
                      label: 'Order History',
                        onTap:(){
                          Get.to(()=>OrderHistoryScreen());
                        }
                    ),
                    ListRow(
                      label: 'Notifications',
                      trailing: Switch(
                        activeThumbColor: R.colors.buttonColor,
                        value: isNotificationOn,
                        onChanged: (value) {
                          setState(() {
                            isNotificationOn = value;
                          });
                        },
                      ),
                    ),

                    ListRow(
                      label: 'Language',
                        onTap:(){
                          Get.to(()=>Languages());
                        }
                    ),
                    ListRow(
                      label: 'Addresses',
                        onTap:(){
                          Get.to(()=>AddressesScreen());
                        }
                    ),

                    ListRow(
                      label: 'Terms and Conditions',
                        onTap:(){
                          Get.to(()=>TermsAndConditionsScreen());
                        }
                    ),

                    ListRow(
                      label: 'Privacy Policy',
                        onTap:(){
                          Get.to(()=>PrivacyPolicyScreen());
                        }
                    ),

                    // ---- Logout ----
                    heightBox(4),
                    InkWell(
                      onTap: () => _showLogoutSheet(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              'Logout',
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.chevron_right,color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              heightBox(15)
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => const LogoutSheet(),
    );
  }
}
