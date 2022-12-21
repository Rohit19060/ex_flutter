import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BuildWorkoutImageItem extends StatelessWidget {
  const BuildWorkoutImageItem({
    required this.image,
    required this.radius,
    required this.width,
    required this.height,
    required this.padding,
  });
  final String image;
  final double radius, width, height, padding;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          color: const Color(0xFF5B4D9D),
        ),
        padding: EdgeInsets.all(padding),
        child: Image.asset(
          image,
          width: width,
          height: height,
          color: Colors.white,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('padding', padding));
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('radius', radius));
    properties.add(StringProperty('image', image));
  }
}
