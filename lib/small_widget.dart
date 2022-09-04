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

class RoundedProgressBar extends StatelessWidget {
  const RoundedProgressBar({
    super.key,
    required this.value,
    this.color = Colors.blue,
    this.height = 6,
    this.radius = 50,
    this.padding = 2,
  });
  final double value, height, radius, padding;
  final Color color;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, boxConstraints) {
          final x = boxConstraints.maxWidth;
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: x,
                height: height + (padding * 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: (value / 100) * x,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
              ),
            ],
          );
        },
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('value', value));
    properties.add(DoubleProperty('radius', radius));
    properties.add(DoubleProperty('padding', padding));
  }
}
