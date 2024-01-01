import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  const Pixel({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
  }
}
