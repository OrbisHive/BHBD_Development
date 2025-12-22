import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:bhbd_project/src/DashBoard/views/Home/home_view.dart';
import 'package:bhbd_project/src/DashBoard/views/Home/views/notifications.dart';
import 'package:bhbd_project/src/DashBoard/views/courses/courses_view.dart';
import 'package:bhbd_project/src/DashBoard/views/profile/views/profile_screen.dart';
import 'package:bhbd_project/src/DashBoard/views/profile/views/profile_screen_new.dart';
import 'package:bhbd_project/src/DashBoard/views/shop/shop_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Constants/enums.dart';
import '../../resources/resources.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({super.key});
  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.backGroundColor,

      // ---------------- APP BAR ----------------
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          height: 90.h,
          decoration: BoxDecoration(
            color: R.color.backGroundColor,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black26.withOpacity(.1),
            //     spreadRadius: 0.2,
            //     blurRadius: 0.5,
            //   ),
            // ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, left: 20, right: 10),
                child: Row(
                  children: [
                    Text(
                      dashboardBottomBarTitle(
                        DashboardBottomBarEnum.values[_selectedIndex],
                      ),
                      style: R.textStyles.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: _selectedIndex == 0 ? 25.sp : 17.sp,
                      ),
                    ),
                    Spacer(),
                    _selectedIndex == 1
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26.withOpacity(.1),
                                  spreadRadius: 0.2,
                                  blurRadius: 0.5,
                                ),
                              ],
                            ),
                            child: Image.asset(R.images.shop2, scale: 4),
                          )
                        : SizedBox(),
                    widthBox(8),
                    InkWell(
                      onTap: (){
                        Get.to(()=>NotificationsScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26.withOpacity(.1),
                              spreadRadius: 0.2,
                              blurRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Image.asset(R.images.notification, scale: 4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeScreen(),
          ShopScreen(),
          CoursesScreen(),
          HomeScreen(),
          ProfileScreen(), // Using new profile screen
        ],
      ),

      // ---------------- BOTTOM NAV BAR ----------------
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          padding: const EdgeInsets.all(15),
          height: Get.height * 0.122,
          width: Get.width,
          decoration: BoxDecoration(
            color: R.color.backGroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black26.withOpacity(.1),
                spreadRadius: 0.2,
                blurRadius: 0.3,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navigationItems(0),
              navigationItems(1),
              navigationItems(2),
              navigationItems(3),
              navigationItems(4),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- NAVIGATION ITEMS ----------------
  Widget navigationItems(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color:_selectedIndex==index? R.color.buttonColor2:Colors.transparent,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(8),

        child: Image.asset(
          dashboardBottomBarIcons(DashboardBottomBarEnum.values[index]),
          scale: 3.9,
          color: _selectedIndex==index?Colors.white:Colors.grey,

        ),
      ),
    );
  }
}
