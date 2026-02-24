import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ai_power_app/widget/custom_text.dart';
import '../utils/apploader.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color color;
  final double width;
  final double height;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.color = const Color(0xFF6200EA), // Default purple color
    this.width = 312,
    this.height = 50,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isLoading
              ? const AppLoader(
            color: Colors.white,
          )
              : CustomText(
            text: text,
            fontSize: fontSize ?? 10,
            color: Colors.white,
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icons;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool needBorder;
  final Color color;
  final Color borderColor;
  final Color iconColor;
  final double width;
  final double height;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomIconButton({
    super.key,
    required this.icons,
    required this.onTap,
    this.isLoading = false,
    this.color = const Color(0xFF6200EA), // Default purple color
    this.width = 50,
    this.height = 50,
    this.fontSize,
    this.fontWeight,
    this.needBorder = false,
    this.borderColor = Colors.grey,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: isLoading ? Colors.grey : color,
            borderRadius: BorderRadius.circular(12),
            border: needBorder ? Border.all(color: borderColor, width: 1) : null),
        child: Center(
            child: isLoading
                ? const AppLoader(
              color: Colors.white,
            )
                : Icon(
              icons,
              color: iconColor,
            )),
      ),
    );
  }
}
