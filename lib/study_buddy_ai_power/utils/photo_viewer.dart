import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class PhotoViewer extends StatelessWidget {
  final String imageUrl;
  final bool isFile;
  final double width;
  final double height;
  final BoxFit fit;

  const PhotoViewer({
    super.key,
    required this.imageUrl,
    this.isFile = false,
    this.width = 100,
    this.height = 140,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final image = isFile
        ? Image.file(File(imageUrl), fit: fit)
        : Image.network(imageUrl, fit: fit);

    return SizedBox(
      width: width,
      height: height,
      child: ClipOval(
        child: InstaImageViewer(
          child: image,
        ),
      ),
    );
  }
}
