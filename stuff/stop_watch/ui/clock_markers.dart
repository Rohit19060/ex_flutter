import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClockSecondsTickMarker extends StatelessWidget {
  const ClockSecondsTickMarker({
    super.key,
    required this.seconds,
    required this.radius,
  });
  final int seconds;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final color = seconds % 5 == 0 ? Colors.white : Colors.grey[700];
    const width = 2.0;
    const height = 12.0;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(-width / 2, -height / 2) // center to origin
        ..rotateZ(2 * pi * (seconds / 60.0))
        ..translate(0.0, radius - height / 2),
      child: Container(width: width, height: height, color: color),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('radius', radius));
    properties.add(IntProperty('seconds', seconds));
  }
}

class ClockTextMarker extends StatelessWidget {
  const ClockTextMarker({
    super.key,
    required this.value,
    required this.maxValue,
    required this.radius,
  });
  final int value;
  final int maxValue;
  final double radius;

  @override
  Widget build(BuildContext context) {
    const width = 40.0;
    const height = 30.0;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(-width / 2, -height / 2)
        ..rotateZ(pi + 2 * pi * (value / maxValue))
        ..translate(0.0, radius - 35)
        ..rotateZ(pi - 2 * pi * (value / maxValue)),
      child: SizedBox(
        width: width,
        height: height,
        child: Text(
          value.toString(),
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('radius', radius));
    properties.add(IntProperty('maxValue', maxValue));
    properties.add(IntProperty('value', value));
  }
}
