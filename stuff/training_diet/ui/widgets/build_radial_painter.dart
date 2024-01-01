import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class RadialPainter extends CustomPainter {
  RadialPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF200087)
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    final relativeProgress = 360 * progress;

    // canvas.drawCircle(center, size.width / 2, paint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
