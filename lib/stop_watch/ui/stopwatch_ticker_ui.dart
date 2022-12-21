import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'clock_hand.dart';
import 'elapsed_time_text.dart';

/// Widget that manages the Ticker and only rebuilds the UI that depends on it
class StopwatchTickerUI extends StatefulWidget {
  const StopwatchTickerUI({super.key, required this.radius});
  final double radius;

  @override
  StopwatchTickerUIState createState() => StopwatchTickerUIState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('radius', radius));
  }
}

class StopwatchTickerUIState extends State<StopwatchTickerUI>
    with SingleTickerProviderStateMixin {
  Duration _previouslyElapsed = Duration.zero;
  Duration _currentlyElapsed = Duration.zero;
  Duration get _elapsed => _previouslyElapsed + _currentlyElapsed;
  late final Ticker _ticker;
  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _currentlyElapsed = elapsed;
      });
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void toggleRunning(bool isRunning) {
    setState(() {
      if (isRunning) {
        _ticker.start();
      } else {
        _ticker.stop();
        _previouslyElapsed += _currentlyElapsed;
        _currentlyElapsed = Duration.zero;
      }
    });
  }

  void reset() {
    _ticker.stop();
    setState(() {
      _previouslyElapsed = Duration.zero;
      _currentlyElapsed = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned(
            left: widget.radius,
            top: widget.radius,
            child: ClockHand(
              handLength: widget.radius,
              handThickness: 2,
              rotationZAngle: pi + (2 * pi / 60000) * _elapsed.inMilliseconds,
              color: Colors.orange,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: widget.radius * 1.3,
            child: ElapsedTimeText(
              elapsed: _elapsed,
            ),
          ),
        ],
      );
}
