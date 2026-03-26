import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:bhbd_project/src/DashBoard/views/shop/views/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../resources/resources.dart';
import '../Home/views/view_all_courses.dart';
import '../profile/views/course_card.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.backGroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Search Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: R.colors.fieldBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: R.colors.fieldBorderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search here.....",
                        hintStyle: R.textStyles.poppins(
                          color: Colors.black38,
                          fontSize: 14.sp,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: R.colors.fieldBorderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Image.asset(R.images.search, scale: 4),
                      ),
                    ),
                  ),
                  widthBox(8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: R.colors.buttonColor2,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(R.images.sort, scale: 3.9),
                  ),
                ],
              ),

              heightBox(16),
              buildTitle("Continue learning"),
              heightBox(12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CourseCard(
                      videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                      teacher: "Iker Robbio",
                      title: "Course Title",
                      price: 12.75,
                      oldPrice: 15.49,
                    ),
                    CourseCard(
                      videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                      teacher: "Anna Kebrics",
                      title: "Course Title",
                      price: 12.75,
                      oldPrice: 15.49,
                    ),
                  ],
                ),
              ),
              heightBox(16),
              buildTitle("Top Courses"),
              heightBox(12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CourseCard(
                      videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                      teacher: "Iker Robbio",
                      title: "Course Title",
                      price: 12.75,
                      oldPrice: 15.49,
                    ),
                    CourseCard(
                      videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                      teacher: "Anna Kebrics",
                      title: "Course Title",
                      price: 12.75,
                      oldPrice: 15.49,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: R.textStyles.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        GestureDetector(
          onTap: (){
            Get.to(()=>ViewAllCoursesScreen());
          },
          child: Text(
            "View all",
            style: R.textStyles.poppins(
              color: R.colors.buttonColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

}
