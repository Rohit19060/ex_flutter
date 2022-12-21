import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class RadialProgress extends StatefulWidget {
  const RadialProgress({super.key, this.goalCompleted = 0.7});
  final double goalCompleted;

  @override
  State<RadialProgress> createState() => _RadialProgressState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('goalCompleted', goalCompleted));
  }
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _radialProgressAnimationController;
  late Animation<double> _progressAnimation;
  double progressDegrees = 0;

  final Duration fadeInDuration = const Duration(milliseconds: 500);
  final Duration fillDuration = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _radialProgressAnimationController = AnimationController(
      vsync: this,
      duration: fillDuration,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 360.0,
    ).animate(
      CurvedAnimation(
        parent: _radialProgressAnimationController,
        curve: Curves.decelerate,
      ),
    )..addListener(() => setState(() =>
        progressDegrees = widget.goalCompleted * _progressAnimation.value));

    _radialProgressAnimationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _radialProgressAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: RadialPainter(progressInDegrees: progressDegrees),
        child: Container(
          width: 210.0,
          height: 210.0,
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: AnimatedOpacity(
            opacity: progressDegrees / 360.0,
            duration: fadeInDuration,
            child: Column(
              children: <Widget>[
                const Text(
                  'RUNNING',
                  style: TextStyle(fontSize: 24.0, letterSpacing: 1.5),
                ),
                const SizedBox(height: 4.0),
                Container(
                  height: 5.0,
                  width: 80.0,
                  decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  '1.225',
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'CALORIES BURN',
                  style: TextStyle(
                      fontSize: 14.0, color: Colors.blue, letterSpacing: 1.2),
                ),
              ],
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration>('fillDuration', fillDuration));
    properties
        .add(DiagnosticsProperty<Duration>('fadeInDuration', fadeInDuration));
    properties.add(DoubleProperty('progressDegrees', progressDegrees));
  }
}

class RadialPainter extends CustomPainter {
  RadialPainter({required this.progressInDegrees});
  final double progressInDegrees;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, size.width / 2, paint);

    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.red, Colors.purple, Colors.purpleAccent],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(progressInDegrees),
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(RadialPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(RadialPainter oldDelegate) => true;
}
