import 'package:flutter/material.dart';

class YummyAvatar extends StatelessWidget {
  final ImageProvider imageProvider;
  final double? radius;

  const YummyAvatar({Key? key, required this.imageProvider, this.radius = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      foregroundImage: imageProvider,
    );
  }
}
