import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class ListRow extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ListRow({super.key, required this.label, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: Colors.white,

          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
                child: Text(label,
                    style: GoogleFonts.poppins(fontSize: 14.sp,fontWeight: FontWeight.w500))),
            trailing ?? const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
