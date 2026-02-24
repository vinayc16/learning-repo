import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final double size;
  final double scale;
  final double strokeWidth;
  final Color color;

  const AppLoader({
    Key? key,
    this.size = 70,
    this.scale = 0.6,
    this.strokeWidth = 6,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: Center(
          child: Transform.scale(
            scale: scale,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: strokeWidth,
              backgroundColor: color.withOpacity(0.1),
            ),
          ),
        ),
      ),
    );
  }
}