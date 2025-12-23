import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 21.0,
  TextAlign textAlign = TextAlign.center,
  Color color = Colors.black,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
  );
}

TextStyle appTextStyleHeading1({
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.w400, // Bebas Neue supports only w400
  Color color = const Color(0xff1F1F1F),
  double letterSpacing = 1.2, // Bebas looks better with spacing
}) {
  return GoogleFonts.bebasNeue(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w400,
    color: color,
    letterSpacing: letterSpacing,
  );
}

TextStyle appTextStylHeading2({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,

  Color color = const Color(0x803F3F3F),
  double letterSpacing = -0.5,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,

    color: color,
    letterSpacing: letterSpacing.sp,
  );
}
