import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../../../../resources/resources.dart';
import 'module_video_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String videoUrl;

  const CourseDetailsScreen({super.key, required this.videoUrl});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildModules() {
    final modules = [
      {"title": "Module 1: Introduction", "time": "00:05:21"},
      {"title": "Module 2: Getting Started", "time": "00:15:45"},
      {"title": "Module 3: Advanced Techniques", "time": "00:30:10"},
      {"title": "Module 4: Expert Techniques", "time": "00:30:10"},
    ];

    return Column(
      children: modules.map((e) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e["title"]!,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  heightBox(2),
                  Row(children: [
                    Icon(
                        Icons.timer,
                        size: 20,
                        color: R.color.buttonColor
                    ),
                    const SizedBox(width: 8),
                    Text(
                      e["time"]!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],)
                ],
              ),

              Spacer(),
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: R.color.buttonColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF8E6D73)),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = "00:57:21";

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
          "Course Details",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(

              child: AspectRatio(
                aspectRatio: 12 / 9,
                child: Image.asset(
                  R.images.video,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(14),
            //   child: AspectRatio(
            //     aspectRatio: _controller.value.isInitialized
            //         ? _controller.value.aspectRatio
            //         : 16 / 9,
            //     child: Stack(
            //       alignment: Alignment.center,
            //       children: [
            //         _controller.value.isInitialized
            //             ? VideoPlayer(_controller)
            //             : Container(color: Colors.black12),
            //
            //         /// Play button overlay
            //         GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               if (_controller.value.isPlaying) {
            //                 _controller.pause();
            //               } else {
            //                 _controller.play();
            //               }
            //             });
            //           },
            //           child: Container(
            //             decoration: const BoxDecoration(
            //               shape: BoxShape.circle,
            //               color: Colors.black38,
            //             ),
            //             padding: const EdgeInsets.all(6),
            //             child: Icon(
            //               _controller.value.isPlaying
            //                   ? Icons.pause
            //                   : Icons.play_arrow,
            //               size: 38,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  const SizedBox(height: 16),

                  /// instructor + time
                  Text(
                    "Thomas Webb",
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: R.color.buttonColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Course Title Here",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.timer, size: 20, color: R.color.buttonColor),
                      const SizedBox(width: 6),
                      Text(
                        remainingTime,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce non esz vel neque suscipit tristique. Integer ullamcorper leo ut metus ultricies...",
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  heightBox(8),
                  Divider(color: Colors.grey.withOpacity(.2),),

                  const SizedBox(height: 18),

                  Text(
                    "All Modules",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// Module list
                  buildModules(),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20),
      height: 70.h,
        padding: EdgeInsets.fromLTRB(18, 10, 18, 25),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.05)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D243D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Purchase",
                  style: GoogleFonts.poppins(fontSize: 15,color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF5D243D),
                  side: const BorderSide(color: Color(0xFF5D243D)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ModuleVideoScreen(
                        imageUrl:
                        "https://images.unsplash.com/photo-1581093588401-22f63e7f7cba",
                      ),
                    ),
                  );

                },
                child: Text(
                  "Start Course",
                  style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
