import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../resources/resources.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
          "Terms and Conditions",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Cursus Sem"),
              _sectionText(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce non est vel neque suscipit tristique. Integer ullamcorper leo ut metus ultricies, eu suscipit tellus tempor.",
              ),
              SizedBox(height: 18.h),

              _sectionTitle("Tincidunt purus"),
              _bulletList([
                "Lorem ipsum dolor sit amet, consec adipiscing elit, sed do eiusmod tempor incididunt.",
                "Phasellus eleifend feugiat felis, ut feugiat odio fringilla adipiscing elit, sed do eiusmod vel.",
                "Tortor sapien mattis nulla in cursus sem turpis.",
              ]),
              SizedBox(height: 18.h),

              _sectionTitle("Phasellus eleifend"),
              _sectionText(
                "Vestibulum tincidunt purus in ultrices ultricies. Aliquam eu arcu id ligula interdum facilisis. Suspen de potenti. Morbi ullamcorper, velit sit amet viverra malesuada, tortor sapien mattis nulla, in cursus sem turpis in dolor.",
              ),
              SizedBox(height: 18.h),

              _sectionTitle("Phasellus eleifend"),
              _sectionText(
                "Suspen de potenti ullamcorper, velit sit amet vamales uada, tortor sapien mattis nulla, in cursus sem turpis in dolor adipiscing elit, sed do eiusmod vel.",
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 15.sp,
        color: Colors.black,
      ),
    );
  }

  Widget _sectionText(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 13.5.sp,
          color: Colors.grey.shade800,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _bulletList(List<String> items) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6.h),
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.5.sp,
                      color: Colors.grey.shade800,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
