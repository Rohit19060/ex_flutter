import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ElapsedTimeText extends StatelessWidget {
  const ElapsedTimeText({super.key, required this.elapsed});
  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final hundreds = (elapsed.inMilliseconds / 10) % 100;
    final seconds = elapsed.inSeconds % 60;
    final minutes = elapsed.inMinutes % 60;
    final hundredsStr = hundreds.toStringAsFixed(0).padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    const digitWidth = 12.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimeDigit(minutesStr.substring(0, 1), width: digitWidth),
        TimeDigit(minutesStr.substring(1, 2), width: digitWidth),
        const TimeDigit(':', width: 6),
        TimeDigit(secondsStr.substring(0, 1), width: digitWidth),
        TimeDigit(secondsStr.substring(1, 2), width: digitWidth),
        const TimeDigit('.', width: 6),
        TimeDigit(hundredsStr.substring(0, 1), width: digitWidth),
        TimeDigit(hundredsStr.substring(1, 2), width: digitWidth),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration>('elapsed', elapsed));
  }
}

class TimeDigit extends StatelessWidget {
  const TimeDigit(this.text, {super.key, required this.width});
  final String text;
  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(StringProperty('text', text));
  }
}
