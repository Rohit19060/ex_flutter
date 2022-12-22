import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClockHand extends StatelessWidget {
  const ClockHand({
    super.key,
    required this.rotationZAngle,
    required this.handThickness,
    required this.handLength,
    required this.color,
  });
  final double rotationZAngle; // function of the elapsed time
  final double handThickness;
  final double handLength;
  final Color color;

  @override
  Widget build(BuildContext context) => Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()
          ..translate(-handThickness / 2)
          ..rotateZ(rotationZAngle),
        child: Container(
          height: handLength,
          width: handThickness,
          color: color,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(DoubleProperty('handLength', handLength));
    properties.add(DoubleProperty('handThickness', handThickness));
    properties.add(DoubleProperty('rotationZAngle', rotationZAngle));
  }
}
