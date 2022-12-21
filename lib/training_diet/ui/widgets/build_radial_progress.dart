import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './build_radial_painter.dart';

class BuildRadialProgress extends StatelessWidget {
  const BuildRadialProgress({
    super.key,
    required this.width,
    required this.height,
    required this.progress,
  });
  final double width, height, progress;
  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: RadialPainter(progress: progress),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: '1731',
                    style: TextStyle(
                      color: Color(0xFF200087),
                      fontSize: 32.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: '\n',
                  ),
                  TextSpan(
                    text: 'kcal left',
                    style: TextStyle(
                      color: Color(0xFF200087),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('progress', progress));
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('width', width));
  }
}
