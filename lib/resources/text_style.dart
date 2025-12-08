import 'package:bhbd_project/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  // --- Inter Font ---
  TextStyle poppins({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextAlign? textAlign,
  }) {
    return GoogleFonts.poppins(
      height: height ?? 1,
      fontSize: fontSize ?? 11.sp,
      color: color ?? R.color.blackColor,
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: letterSpacing ?? 0,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  // --- Archivo Font ---
  TextStyle archivo({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextAlign? textAlign,
  }) {
    return GoogleFonts.archivo(
      height: height ?? 1,
      fontSize: fontSize ?? 11.sp,
      color: color ?? R.color.blackColor,
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: letterSpacing ?? 0,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }
}
