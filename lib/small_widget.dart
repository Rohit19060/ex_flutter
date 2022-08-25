import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SliderDots extends StatelessWidget {
  const SliderDots({super.key, required this.length, required this.selected});
  final int length;
  final bool selected;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            length,
            (index) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.white : Colors.white.withOpacity(0.2),
              ),
              margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              width: 7,
              height: 7,
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(IntProperty('length', length));
  }
}
