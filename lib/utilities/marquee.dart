// ignore_for_file: library_private_types_in_public_api
import 'dart:async';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IntegralCurve extends Curve {
  factory IntegralCurve(Curve original) {
    var integral = 0.0;
    final values = <double, double>{};
    for (var t = 0.0; t <= 1.0; t += delta) {
      integral += original.transform(t) * delta;
      values[t] = integral;
    }
    values[1.0] = integral;
    for (final t in values.keys) {
      values[t] = values[t]! / integral;
    }
    return IntegralCurve._(original, integral, values);
  }
  const IntegralCurve._(this.original, this.integral, this._values);
  static double delta = 0.01;
  final Curve original;
  final double integral;
  final Map<double, double> _values;
  @override
  double transform(double t) {
    if (t < 0) {
      return 0.0;
    }
    for (final key in _values.keys) {
      if (key > t) {
        return _values[key]!;
      }
    }
    return 1.0;
  }
}

class Marquee extends StatefulWidget {
  Marquee({
    super.key,
    required this.text,
    this.style,
    this.textScaleFactor,
    this.textDirection = TextDirection.ltr,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.blankSpace = 0.0,
    this.velocity = 50.0,
    this.startAfter = Duration.zero,
    this.pauseAfterRound = Duration.zero,
    this.showFadingOnlyWhenScrolling = true,
    this.fadingEdgeStartFraction = 0.0,
    this.fadingEdgeEndFraction = 0.0,
    this.numberOfRounds,
    this.startPadding = 0.0,
    this.accelerationDuration = Duration.zero,
    Curve accelerationCurve = Curves.decelerate,
    this.decelerationDuration = Duration.zero,
    Curve decelerationCurve = Curves.decelerate,
    this.onDone,
  })  : assert(!blankSpace.isNaN, 'BlankSpace'),
        assert(blankSpace >= 0, 'The blankSpace needs to be positive or zero.'),
        assert(blankSpace.isFinite, 'Blank Space need to be finite'),
        assert(!velocity.isNaN, 'Velocity is not a number'),
        assert(velocity != 0.0, 'The velocity cannot be zero.'),
        assert(velocity.isFinite, 'Velocity needs to be finite'),
        assert(
          pauseAfterRound >= Duration.zero,
          "The pauseAfterRound cannot be negative as time travel isn't "
          'invented yet.',
        ),
        assert(
          fadingEdgeStartFraction >= 0 && fadingEdgeStartFraction <= 1,
          'The fadingEdgeGradientFractionOnStart value should be between 0 and '
          '1, inclusive',
        ),
        assert(
          fadingEdgeEndFraction >= 0 && fadingEdgeEndFraction <= 1,
          'The fadingEdgeGradientFractionOnEnd value should be between 0 and '
          '1, inclusive',
        ),
        assert(numberOfRounds == null || numberOfRounds > 0,
            'Number of Rounds should be above 0'),
        assert(
          accelerationDuration >= Duration.zero,
          "The accelerationDuration cannot be negative as time travel isn't "
          'invented yet.',
        ),
        assert(
          decelerationDuration >= Duration.zero,
          'The decelerationDuration must be positive or zero as time travel '
          "isn't invented yet.",
        ),
        accelerationCurve = IntegralCurve(accelerationCurve),
        decelerationCurve = IntegralCurve(decelerationCurve);
  final String text;
  final TextStyle? style;
  final double? textScaleFactor;
  final TextDirection textDirection;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double blankSpace;
  final double velocity;
  final Duration startAfter;
  final Duration pauseAfterRound;
  final int? numberOfRounds;
  final bool showFadingOnlyWhenScrolling;
  final double fadingEdgeStartFraction;
  final double fadingEdgeEndFraction;
  final double startPadding;
  final Duration accelerationDuration;
  final IntegralCurve accelerationCurve;
  final Duration decelerationDuration;
  final IntegralCurve decelerationCurve;
  final VoidCallback? onDone;
  @override
  State<StatefulWidget> createState() => _MarqueeState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onDone', onDone));
    properties.add(DiagnosticsProperty<IntegralCurve>(
        'decelerationCurve', decelerationCurve));
    properties.add(DiagnosticsProperty<Duration>(
        'decelerationDuration', decelerationDuration));
    properties.add(DiagnosticsProperty<IntegralCurve>(
        'accelerationCurve', accelerationCurve));
    properties.add(DiagnosticsProperty<Duration>(
        'accelerationDuration', accelerationDuration));
    properties.add(DoubleProperty('startPadding', startPadding));
    properties
        .add(DoubleProperty('fadingEdgeEndFraction', fadingEdgeEndFraction));
    properties.add(
        DoubleProperty('fadingEdgeStartFraction', fadingEdgeStartFraction));
    properties.add(DiagnosticsProperty<bool>(
        'showFadingOnlyWhenScrolling', showFadingOnlyWhenScrolling));
    properties.add(IntProperty('numberOfRounds', numberOfRounds));
    properties
        .add(DiagnosticsProperty<Duration>('pauseAfterRound', pauseAfterRound));
    properties.add(DiagnosticsProperty<Duration>('startAfter', startAfter));
    properties.add(DoubleProperty('velocity', velocity));
    properties.add(DoubleProperty('blankSpace', blankSpace));
    properties.add(EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty<Axis>('scrollAxis', scrollAxis));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
    properties.add(DoubleProperty('textScaleFactor', textScaleFactor));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(StringProperty('text', text));
  }
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  late double _startPosition;
  late double _accelerationTarget;
  late double _linearTarget;
  late double _decelerationTarget;
  late Duration _totalDuration;
  Duration get _accelerationDuration => widget.accelerationDuration;
  Duration? _linearDuration;
  Duration get _decelerationDuration => widget.decelerationDuration;
  bool _running = false;
  bool _isOnPause = false;
  int _roundCounter = 0;
  bool get isDone => widget.numberOfRounds == _roundCounter;
  bool get showFading {
    if (!widget.showFadingOnlyWhenScrolling) {
      return true;
    } else {
      return !_isOnPause;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_running) {
        _running = true;
        if (_controller.hasClients) {
          _controller.jumpTo(_startPosition);
          await Future<void>.delayed(widget.startAfter);
          await Future.doWhile(_scroll);
        }
      }
    });
  }

  Future<bool> _scroll() async {
    await _makeRoundTrip();
    if (isDone && widget.onDone != null) {
      widget.onDone!();
    }
    return _running && !isDone && _controller.hasClients;
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget as Marquee);
  }

  @override
  void dispose() {
    _running = false;
    super.dispose();
  }

  void _initialize(BuildContext context) {
    final totalLength = _getTextWidth(context) + widget.blankSpace;
    final accelerationLength = widget.accelerationCurve.integral *
        widget.velocity *
        _accelerationDuration.inMilliseconds /
        1000.0;
    final decelerationLength = widget.decelerationCurve.integral *
        widget.velocity *
        _decelerationDuration.inMilliseconds /
        1000.0;
    final linearLength =
        (totalLength - accelerationLength.abs() - decelerationLength.abs()) *
            (widget.velocity > 0 ? 1 : -1);
// Calculate scroll positions at various scrolling phases.
    _startPosition = 2 * totalLength - widget.startPadding;
    _accelerationTarget = _startPosition + accelerationLength;
    _linearTarget = _accelerationTarget + linearLength;
    _decelerationTarget = _linearTarget + decelerationLength;
// Calculate durations for the phases.
    _totalDuration = _accelerationDuration +
        _decelerationDuration +
        Duration(milliseconds: (linearLength / widget.velocity * 1000).toInt());
    _linearDuration =
        _totalDuration - _accelerationDuration - _decelerationDuration;
    assert(
      _totalDuration > Duration.zero,
      'With the given values, the total duration for one round would be '
      "negative. As time travel isn't invented yet, this shouldn't happen.",
    );
    assert(
      _linearDuration! >= Duration.zero,
      'Acceleration and deceleration phase overlap. To fix this, try a '
      'combination of these approaches:\n'
      "* Make the text longer, so there's more room to animate within.\n"
      '* Shorten the accelerationDuration or decelerationDuration.\n'
      '* Decrease the velocity, so the duration to animate within is longer.\n',
    );
  }

  Future<void> _makeRoundTrip() async {
// Reset the controller, then accelerate, move linearly and decelerate.
    if (!_controller.hasClients) {
      return;
    }
    _controller.jumpTo(_startPosition);
    if (!_running) {
      return;
    }
    await _accelerate();
    if (!_running) {
      return;
    }
    await _moveLinearly();
    if (!_running) {
      return;
    }
    await _decelerate();
    _roundCounter++;
    if (!_running || !mounted) {
      return;
    }
    if (widget.pauseAfterRound > Duration.zero) {
      setState(() => _isOnPause = true);
      await Future.delayed(widget.pauseAfterRound);
      if (!mounted || isDone) {
        return;
      }
      setState(() => _isOnPause = false);
    }
  }

  Future<void> _accelerate() async {
    await _animateTo(
      _accelerationTarget,
      _accelerationDuration,
      widget.accelerationCurve,
    );
  }

  Future<void> _moveLinearly() async {
    await _animateTo(_linearTarget, _linearDuration, Curves.linear);
  }

  Future<void> _decelerate() async {
    await _animateTo(
      _decelerationTarget,
      _decelerationDuration,
      widget.decelerationCurve.flipped,
    );
  }

  Future<void> _animateTo(
    double? target,
    Duration? duration,
    Curve curve,
  ) async {
    if (!_controller.hasClients) {
      return;
    }
    if (duration! > Duration.zero) {
      await _controller.animateTo(target!, duration: duration, curve: curve);
    } else {
      _controller.jumpTo(target!);
    }
  }

  double _getTextWidth(BuildContext context) {
    final span = TextSpan(text: widget.text, style: widget.style);
    const constraints = BoxConstraints();
    final richTextWidget = Text.rich(span).build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);
    final boxes = renderObject.getBoxesForSelection(
      TextSelection(
        baseOffset: 0,
        extentOffset: TextSpan(text: widget.text).toPlainText().length,
      ),
    );
    return boxes.last.right;
  }

  @override
  Widget build(BuildContext context) {
    _initialize(context);
    final isHorizontal = widget.scrollAxis == Axis.horizontal;
    Alignment? alignment;
    switch (widget.crossAxisAlignment) {
      case CrossAxisAlignment.start:
        alignment = isHorizontal ? Alignment.topCenter : Alignment.centerLeft;
        break;
      case CrossAxisAlignment.end:
        alignment =
            isHorizontal ? Alignment.bottomCenter : Alignment.centerRight;
        break;
      case CrossAxisAlignment.center:
        alignment = Alignment.center;
        break;
      case CrossAxisAlignment.stretch:
      case CrossAxisAlignment.baseline:
        alignment = null;
        break;
    }
    final Widget marquee = ListView.builder(
      controller: _controller,
      scrollDirection: widget.scrollAxis,
      reverse: widget.textDirection == TextDirection.rtl,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) {
        final text = i.isEven
            ? Text(widget.text,
                style: widget.style, textScaleFactor: widget.textScaleFactor)
            : _buildBlankSpace();
        return alignment == null
            ? text
            : Align(alignment: alignment, child: text);
      },
    );
    return kIsWeb ? marquee : _wrapWithFadingEdgeScrollView(marquee);
  }

  Widget _buildBlankSpace() => SizedBox(
        width: widget.scrollAxis == Axis.horizontal ? widget.blankSpace : null,
        height: widget.scrollAxis == Axis.vertical ? widget.blankSpace : null,
      );

  Widget _wrapWithFadingEdgeScrollView(Widget child) =>
      FadingEdgeScrollView.fromScrollView(
        gradientFractionOnStart:
            !showFading ? 0.0 : widget.fadingEdgeStartFraction,
        gradientFractionOnEnd: !showFading ? 0.0 : widget.fadingEdgeEndFraction,
        child: child as ScrollView,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('showFading', showFading));
    properties.add(DiagnosticsProperty<bool>('isDone', isDone));
  }
}
