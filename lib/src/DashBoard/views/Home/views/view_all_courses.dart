import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bhbd_project/resources/resources.dart';
import '../../profile/views/course_card.dart';


class ViewAllCoursesScreen extends StatelessWidget {

  const ViewAllCoursesScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.backGroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
     "All Continue Learning",
          style: R.textStyles.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8,8,0,8.0),
                child: CourseCard(
                  videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                  teacher: "John Doe",
                  title: "Course Title ${index + 1}",
                  price: 12.75,
                  oldPrice: 15.49,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
