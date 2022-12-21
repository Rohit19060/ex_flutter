import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<GraphData> runningDayData = [
  GraphData('12am', 100),
  GraphData('3am', 80),
  GraphData('6am', 70),
  GraphData('9am', 120),
  GraphData('12pm', 90),
  GraphData('3pm', 160),
  GraphData('6pm', 90),
  GraphData('9pm', 50),
  GraphData('12pm', 80)
];

class AnimatedBars extends StatefulWidget {
  const AnimatedBars({super.key});

  @override
  State<AnimatedBars> createState() => _AnimatedBarsState();
}

class _AnimatedBarsState extends State<AnimatedBars>
    with SingleTickerProviderStateMixin {
  late AnimationController _graphAnimationController;

  @override
  void initState() {
    super.initState();
    _graphAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _graphAnimationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _graphAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {},
          child: Graph(
            animationController: _graphAnimationController,
            values: runningDayData,
          ),
        ),
      );
}

class GraphData implements Comparable<GraphData> {
  GraphData(this.label, this.value);
  String label;
  int value;

  @override
  int compareTo(GraphData other) => value.compareTo(other.value);
}

class Graph extends StatelessWidget {
  const Graph({
    super.key,
    required this.animationController,
    this.height = 120.0,
    required this.values,
  });
  final AnimationController animationController;
  final List<GraphData> values;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildBars(values),
        ),
      );

  List<GraphBar> _buildBars(List<GraphData> values) {
    final maxGraphData = values.reduce(
        (current, next) => (next.compareTo(current) >= 1) ? next : current);
    final bars = <GraphBar>[];

    for (final graphData in values) {
      final percentage = graphData.value / maxGraphData.value;
      bars.add(GraphBar(
        height: height,
        percentage: percentage,
        graphAnimationController: animationController,
      ));
    }
    return bars;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<AnimationController>(
        'animationController', animationController));
    properties.add(IterableProperty<GraphData>('values', values));
  }
}

class GraphBar extends StatefulWidget {
  const GraphBar({
    super.key,
    required this.height,
    required this.percentage,
    required this.graphAnimationController,
  });
  final double height, percentage;
  final AnimationController graphAnimationController;
  @override
  State<GraphBar> createState() => _GraphBarState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AnimationController>(
        'graphAnimationController', graphAnimationController));
    properties.add(DoubleProperty('percentage', percentage));
    properties.add(DoubleProperty('height', height));
  }
}

class _GraphBarState extends State<GraphBar> {
  late Animation<double> _percentageAnimation;

  @override
  void initState() {
    super.initState();

    _percentageAnimation = Tween<double>(
      begin: 0.0,
      end: widget.percentage,
    ).animate(widget.graphAnimationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: BarPainter(percentage: _percentageAnimation.value),
        child: Container(),
      );
}

class BarPainter extends CustomPainter {
  const BarPainter({
    required this.percentage,
  });
  final double percentage;

  @override
  void paint(Canvas canvas, Size size) {
    final greyPaint = Paint()
      ..color = const Color.fromARGB(255, 230, 230, 230)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    const topPoint = Offset(0, 0);
    final bottomPoint = Offset(0, size.height + 20);
    final centerPoint = Offset(0, (size.height + 20) / 2);

    canvas.drawLine(topPoint, bottomPoint, greyPaint);

    final filledPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        colors: [Colors.pink.shade500, Colors.blue.shade500],
      ).createShader(Rect.fromPoints(topPoint, bottomPoint))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    final filledHeight = percentage * size.height;
    final filledHalfHeight = filledHeight / 2;

    canvas.drawLine(
        centerPoint, Offset(0, centerPoint.dy - filledHalfHeight), filledPaint);
    canvas.drawLine(
        centerPoint, Offset(0, centerPoint.dy + filledHalfHeight), filledPaint);
  }

  @override
  bool shouldRepaint(BarPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BarPainter oldDelegate) => true;
}
