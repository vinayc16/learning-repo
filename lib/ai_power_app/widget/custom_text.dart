import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final String? fontFamily;
  final TextDecoration textDecoration;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.fontFamily,
    this.textDecoration = TextDecoration.none
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: fontFamily != null
          ? GoogleFonts.getFont(fontFamily!,textStyle: TextStyle(decoration: textDecoration),
          fontSize: fontSize, fontWeight: fontWeight, color: color)
          : GoogleFonts.poppins( textStyle: TextStyle(decoration: textDecoration),
          fontSize: fontSize, fontWeight: fontWeight, color: color),
    );
  }
}
