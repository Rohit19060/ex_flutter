import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum ShimmerDirection { ltr, rtl, ttb, btt }

class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.enabled = true,
  });

  Shimmer.fromColors({
    super.key,
    required this.child,
    Color baseColor = const Color.fromARGB(255, 224, 224, 224),
    Color highlightColor = const Color.fromARGB(255, 214, 214, 214),
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.loop = 0,
    this.enabled = true,
  }) : gradient = LinearGradient(begin: Alignment.topLeft, colors: <Color>[
          baseColor,
          baseColor,
          highlightColor,
          baseColor,
          baseColor
        ], stops: const <double>[
          0.0,
          0.35,
          0.5,
          0.65,
          1.0
        ]);
  final Widget child;
  final Duration period;
  final ShimmerDirection direction;
  final Gradient gradient;
  final int loop;
  final bool enabled;

  @override
  State<Shimmer> createState() => _ShimmerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient,
        defaultValue: null));
    properties.add(EnumProperty<ShimmerDirection>('direction', direction));
    properties.add(
        DiagnosticsProperty<Duration>('period', period, defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool>('enabled', enabled, defaultValue: null));
    properties.add(DiagnosticsProperty<int>('loop', loop, defaultValue: 0));
  }
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..addStatusListener((status) {
        if (status != AnimationStatus.completed) {
          return;
        }
        _count++;
        if (widget.loop <= 0) {
          _controller.repeat();
        } else if (_count < widget.loop) {
          _controller.forward(from: 0.0);
        }
      });
    if (widget.enabled) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    if (widget.enabled) {
      _controller.forward();
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) => _Shimmer(
          direction: widget.direction,
          gradient: widget.gradient,
          percent: _controller.value,
          child: child,
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@immutable
class _Shimmer extends SingleChildRenderObjectWidget {
  const _Shimmer({
    super.child,
    required this.percent,
    required this.direction,
    required this.gradient,
  });
  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;

  @override
  _ShimmerFilter createRenderObject(BuildContext context) =>
      _ShimmerFilter(percent, direction, gradient);

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
    shimmer.gradient = gradient;
    shimmer.direction = direction;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient));
    properties.add(EnumProperty<ShimmerDirection>('direction', direction));
    properties.add(DoubleProperty('percent', percent));
  }
}

class _ShimmerFilter extends RenderProxyBox {
  _ShimmerFilter(this._percent, this._direction, this._gradient);
  ShimmerDirection _direction;
  Gradient _gradient;
  double _percent;

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue == _percent) {
      return;
    }
    _percent = newValue;
    markNeedsPaint();
  }

  double get percent => _percent;

  set gradient(Gradient newValue) {
    if (newValue == _gradient) {
      return;
    }
    _gradient = newValue;
    markNeedsPaint();
  }

  Gradient get gradient => _gradient;

  set direction(ShimmerDirection newDirection) {
    if (newDirection == _direction) {
      return;
    }
    _direction = newDirection;
    markNeedsLayout();
  }

  ShimmerDirection get direction => _direction;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing,
          'Cannot paint a _ShimmerFilter without a child and without compositing.');

      final width = child!.size.width;
      final height = child!.size.height;
      Rect rect;
      double dx, dy;
      if (_direction == ShimmerDirection.rtl) {
        dx = _offset(width, -width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      } else if (_direction == ShimmerDirection.ttb) {
        dx = 0.0;
        dy = _offset(-height, height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else if (_direction == ShimmerDirection.btt) {
        dx = 0.0;
        dy = _offset(height, -height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else {
        dx = _offset(-width, width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      }
      layer ??= ShaderMaskLayer();
      layer!
        ..shader = _gradient.createShader(rect)
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }

  double _offset(double start, double end, double percent) =>
      start + (end - start) * percent;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('percent', percent));
    properties.add(EnumProperty<ShimmerDirection>('direction', direction));
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient));
  }
}

class ShimmerHome extends StatefulWidget {
  const ShimmerHome({super.key});
  @override
  State<ShimmerHome> createState() => _ShimmerHomeState();
}

class _ShimmerHomeState extends State<ShimmerHome> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Shimmer.fromColors(
            child: Center(
              child: Container(
                height: 500,
                width: 500,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
}
