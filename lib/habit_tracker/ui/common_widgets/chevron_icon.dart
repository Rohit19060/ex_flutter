import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChevronIcon extends StatelessWidget {
  const ChevronIcon({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => Icon(
        Icons.chevron_right,
        color: color,
        size: 32,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
  }
}
