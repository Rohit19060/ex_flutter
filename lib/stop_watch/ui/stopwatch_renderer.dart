import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'clock_markers.dart';

class StopwatchRenderer extends StatelessWidget {
  const StopwatchRenderer({
    super.key,
    required this.radius,
  });
  final double radius;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          for (var i = 0; i < 60; i++)
            Positioned(
              left: radius,
              top: radius,
              child: ClockSecondsTickMarker(seconds: i, radius: radius),
            ),
          for (var i = 5; i <= 60; i += 5)
            Positioned(
              top: radius,
              left: radius,
              child: ClockTextMarker(value: i, maxValue: 60, radius: radius),
            ),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('radius', radius));
  }
}
