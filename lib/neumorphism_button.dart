import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Neumorphism Button',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isPressed = false;
  Color backgroundColor = const Color(0xFFE7ECEF);
  Offset distance = const Offset(12, 12);
  double blur = 30;
  int _tabIndex = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: GestureDetector(
            onTap: () => debugPrint('hi'),
            onTapUp: (_) => setState(() => isPressed = !isPressed),
            onTapDown: (_) => setState(() => isPressed = !isPressed),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  boxShadow: isPressed
                      ? []
                      : [
                          BoxShadow(
                            blurRadius: blur,
                            offset: -distance,
                            color: const Color.fromARGB(59, 55, 165, 255),
                          ),
                          BoxShadow(
                            blurRadius: blur,
                            offset: distance,
                            color: const Color.fromARGB(59, 55, 165, 255),
                          )
                        ]),
              child: const SizedBox(width: 200, height: 200),
            ),
          ),
        ),
        bottomNavigationBar: CircleNavBar(
          circleColor: const Color(0xffd32760),
          activeIcons: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/home.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/spoon.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/bookmark.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/user.png',
                color: Colors.white,
              ),
            ),
          ],
          inactiveIcons: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/home.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/spoon.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/bookmark.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/user.png',
                color: Colors.white,
              ),
            ),
          ],
          color: const Color(0xff11171e),
          height: 60,
          circleWidth: 50,
          activeIndex: _tabIndex,
          onTap: (index) => setState(() => _tabIndex = index),
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          shadowColor: const Color(0xff05080d),
          elevation: 10,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('blur', blur));
    properties.add(DiagnosticsProperty<Offset>('distance', distance));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<bool>('isPressed', isPressed));
  }
}

class CircleNavBar extends StatefulWidget {
  const CircleNavBar({
    super.key,
    required this.activeIndex,
    this.onTap,
    this.tabCurve = Curves.linearToEaseOut,
    this.iconCurve = Curves.bounceOut,
    this.tabDurationMillSec = 1000,
    this.iconDurationMillSec = 500,
    required this.activeIcons,
    required this.inactiveIcons,
    required this.height,
    required this.circleWidth,
    required this.color,
    this.circleColor,
    this.padding = EdgeInsets.zero,
    this.cornerRadius = BorderRadius.zero,
    this.shadowColor = Colors.white,
    this.circleShadowColor,
    this.elevation = 0,
    this.gradient,
    this.circleGradient,
  })  : assert(circleWidth <= height, 'circleWidth <= height'),
        assert(activeIcons.length == inactiveIcons.length,
            'activeIcons.length and inactiveIcons.length must be equal!'),
        assert(activeIcons.length > activeIndex,
            'activeIcons.length > activeIndex');

  final double height;
  final double circleWidth;
  final Color color;
  final Color? circleColor;
  final List<Widget> activeIcons;
  final List<Widget> inactiveIcons;
  final EdgeInsets padding;
  final BorderRadius cornerRadius;
  final Color shadowColor;
  final Color? circleShadowColor;
  final double elevation;
  final Gradient? gradient;
  final Gradient? circleGradient;
  final int activeIndex;
  final Curve tabCurve;
  final Curve iconCurve;
  final int tabDurationMillSec;
  final int iconDurationMillSec;
  final Function(int index)? onTap;

  @override
  State<StatefulWidget> createState() => _CircleNavBarState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<Function(int index)?>.has('onTap', onTap));
    properties.add(IntProperty('iconDurationMillSec', iconDurationMillSec));
    properties.add(IntProperty('tabDurationMillSec', tabDurationMillSec));
    properties.add(DiagnosticsProperty<Curve>('iconCurve', iconCurve));
    properties.add(DiagnosticsProperty<Curve>('tabCurve', tabCurve));
    properties.add(IntProperty('activeIndex', activeIndex));
    properties
        .add(DiagnosticsProperty<Gradient?>('circleGradient', circleGradient));
    properties.add(DiagnosticsProperty<Gradient?>('gradient', gradient));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('circleShadowColor', circleShadowColor));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties
        .add(DiagnosticsProperty<BorderRadius>('cornerRadius', cornerRadius));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(ColorProperty('circleColor', circleColor));
    properties.add(ColorProperty('color', color));
    properties.add(DoubleProperty('circleWidth', circleWidth));
    properties.add(DoubleProperty('height', height));
  }
}

class _CircleNavBarState extends State<CircleNavBar>
    with TickerProviderStateMixin {
  late AnimationController tabAc;
  late AnimationController activeIconAc;

  @override
  void initState() {
    super.initState();
    tabAc = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.tabDurationMillSec))
      ..addListener(() => setState(() {}))
      ..value = getPosition(widget.activeIndex);
    activeIconAc = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.iconDurationMillSec))
      ..addListener(() => setState(() {}))
      ..value = 1;
  }

  @override
  void didUpdateWidget(covariant CircleNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation();
  }

  void _animation() {
    final nextPosition = getPosition(widget.activeIndex);
    tabAc.stop();
    tabAc.animateTo(nextPosition, curve: widget.tabCurve);
    activeIconAc.reset();
    activeIconAc.animateTo(1, curve: widget.iconCurve);
  }

  double getPosition(int i) {
    final itemCnt = widget.activeIcons.length;
    return i / itemCnt + (1 / itemCnt) / 2;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: widget.padding,
      width: double.infinity,
      height: widget.height,
      child: Column(
        children: [
          CustomPaint(
            painter: _CircleBottomPainter(
              iconWidth: widget.circleWidth,
              color: widget.color,
              circleColor: widget.circleColor ?? widget.color,
              xOffsetPercent: tabAc.value,
              boxRadius: widget.cornerRadius,
              shadowColor: widget.shadowColor,
              circleShadowColor: widget.circleShadowColor ?? widget.shadowColor,
              elevation: widget.elevation,
              gradient: widget.gradient,
              circleGradient: widget.circleGradient ?? widget.gradient,
            ),
            child: SizedBox(
              height: widget.height,
              width: double.infinity,
              child: Stack(
                children: [
                  Row(
                    children: widget.inactiveIcons.map((e) {
                      final currentIndex = widget.inactiveIcons.indexOf(e);
                      return Expanded(
                          child: GestureDetector(
                        onTap: () => widget.onTap?.call(currentIndex),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: widget.activeIndex == currentIndex ? null : e,
                        ),
                      ));
                    }).toList(),
                  ),
                  Positioned(
                    left: tabAc.value * deviceWidth -
                        widget.circleWidth / 2 -
                        tabAc.value *
                            (widget.padding.left + widget.padding.right),
                    child: Transform.scale(
                      scale: activeIconAc.value,
                      child: Container(
                        width: widget.circleWidth,
                        height: widget.circleWidth,
                        transform: Matrix4.translationValues(
                            0,
                            -(widget.circleWidth * 0.5) +
                                _CircleBottomPainter.getMiniRadius(
                                    widget.circleWidth) -
                                widget.circleWidth *
                                    0.5 *
                                    (1 - activeIconAc.value),
                            0),
                        // color: Colors.amber,
                        child: widget.activeIcons[widget.activeIndex],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<AnimationController>('activeIconAc', activeIconAc));
    properties.add(DiagnosticsProperty<AnimationController>('tabAc', tabAc));
  }
}

class _CircleBottomPainter extends CustomPainter {
  _CircleBottomPainter({
    required this.iconWidth,
    required this.color,
    required this.circleColor,
    required this.xOffsetPercent,
    required this.boxRadius,
    required this.shadowColor,
    required this.circleShadowColor,
    required this.elevation,
    this.gradient,
    this.circleGradient,
  });

  final Color color;
  final Color circleColor;
  final double iconWidth;
  final double xOffsetPercent;
  final BorderRadius boxRadius;
  final Color shadowColor;
  final Color circleShadowColor;
  final double elevation;
  final Gradient? gradient;
  final Gradient? circleGradient;

  static double getR(double circleWidth) => circleWidth / 2 * 1.2;

  static double getMiniRadius(double circleWidth) => getR(circleWidth) * 0.3;

  static double convertRadiusToSigma(double radius) => radius * 0.57735 + 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    final paint = Paint();
    Paint? circlePaint;
    if (color != circleColor || circleGradient != null) {
      circlePaint = Paint();
      circlePaint.color = circleColor;
    }

    final w = size.width;
    final h = size.height;
    final r = getR(iconWidth);
    final miniRadius = getMiniRadius(iconWidth);
    final x = xOffsetPercent * w;
    final firstX = x - r;
    final secondX = x + r;

    // TopLeft Radius
    path.moveTo(0, 0 + boxRadius.topLeft.y);
    path.quadraticBezierTo(0, 0, boxRadius.topLeft.x, 0);
    path.lineTo(firstX - miniRadius, 0);
    path.quadraticBezierTo(firstX, 0, firstX, miniRadius);

    path.arcToPoint(
      Offset(secondX, miniRadius),
      radius: Radius.circular(r),
      clockwise: false,
    );

    path.quadraticBezierTo(secondX, 0, secondX + miniRadius, 0);

    // TopRight Radius
    path.lineTo(w - boxRadius.topRight.x, 0);
    path.quadraticBezierTo(w, 0, w, boxRadius.topRight.y);

    // BottomRight Radius
    path.lineTo(w, h - boxRadius.bottomRight.y);
    path.quadraticBezierTo(w, h, w - boxRadius.bottomRight.x, h);

    // BottomLeft Radius
    path.lineTo(boxRadius.bottomLeft.x, h);
    path.quadraticBezierTo(0, h, 0, h - boxRadius.bottomLeft.y);

    path.close();

    paint.color = color;

    if (gradient != null) {
      final shaderRect =
          Rect.fromCircle(center: Offset(w / 2, h / 2), radius: 180.0);
      paint.shader = gradient!.createShader(shaderRect);
    }

    if (circleGradient != null) {
      final shaderRect =
          Rect.fromCircle(center: Offset(x, miniRadius), radius: iconWidth / 2);
      circlePaint?.shader = circleGradient!.createShader(shaderRect);
    }

    canvas.drawPath(
        path,
        Paint()
          ..color = shadowColor
          ..maskFilter = MaskFilter.blur(
              BlurStyle.normal, convertRadiusToSigma(elevation)));

    canvas.drawCircle(
        Offset(x, miniRadius),
        iconWidth / 2,
        Paint()
          ..color = circleShadowColor
          ..maskFilter = MaskFilter.blur(
              BlurStyle.normal, convertRadiusToSigma(elevation)));

    canvas.drawPath(path, paint);

    canvas.drawCircle(
        Offset(x, miniRadius), iconWidth / 2, circlePaint ?? paint);
  }

  @override
  bool shouldRepaint(_CircleBottomPainter oldDelegate) => oldDelegate != this;
}
