import 'package:flutter/material.dart';
import '../resources/resources.dart';

class AppButton extends StatelessWidget {
  final String title;
  final double? height;
  final double? width;
  final Function() onTap;
  final TextStyle? style;
  final double? borderRadius;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final FontWeight? fontWeight;
  final Color textColor;
  final double? fontSize;
  final Widget? icon;
  final Color? borderColor;
  final double? borderWidth;

  const AppButton({
    super.key,
    required this.title,
    this.height,
    this.width,
    required this.onTap,
    this.style,
    this.borderRadius,
    this.gradientColors,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor = const Color(0xFF4B39EF),
    this.textColor = const Color(0xffF89321),
    this.icon,
    this.borderColor,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height ?? 40,
        width: width,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradientColors != null
                  ? LinearGradient(
                colors: gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
              color: gradientColors == null ? backgroundColor : null,
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              border: borderColor != null
                  ? Border.all(
                color: borderColor!,
                width: borderWidth!,
              )
                  : null,
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title,
                    style: style ??
                        R.textStyles.poppins(
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          color: textColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
