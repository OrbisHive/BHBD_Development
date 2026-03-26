import 'package:bhbd_project/Widgets/height_width_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../resources/resources.dart';

class ModuleVideoScreen extends StatelessWidget {
  final String imageUrl;

  const ModuleVideoScreen({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.backGroundColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: R.colors.backGroundColor,
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
          "Module Video",
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

            /// ✅ Static Image
            ClipRRect(

              child: AspectRatio(
                aspectRatio: 12 / 9,
                child: Image.asset(
                  R.images.video,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ✅ Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce non esz vel neque suscipit tristique. Integer ullamcorper leo ut metus ultricies, euusc ipit tellus tempor. Sed sed vescibulum felis. Phasellus eleifend feugiat felis, ut feugiat.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 220),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D243D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Mark as complete",
                    style: GoogleFonts.poppins(fontSize: 13.sp,fontWeight: FontWeight.w500,color: Colors.white),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),


    );
  }
}
