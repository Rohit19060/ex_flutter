import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    super.key,
    required this.child,
    required this.value,
    this.color = Colors.black,
  });

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          )
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(StringProperty('value', value));
  }
}
