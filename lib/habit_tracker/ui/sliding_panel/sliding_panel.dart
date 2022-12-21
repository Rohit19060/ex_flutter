import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theming/app_theme.dart';

enum SlideDirection {
  leftToRight,
  rightToLeft,
}

class SlidingPanel extends StatelessWidget {
  const SlidingPanel({super.key, this.child, required this.direction});
  final Widget? child;
  final SlideDirection direction;

  static const paddingWidth = 9.0;
  static const leftPanelFixedWidth = 54.0;

  EdgeInsets get padding => direction == SlideDirection.rightToLeft
      ? const EdgeInsets.only(left: 3, right: 6)
      : const EdgeInsets.only(left: 6, right: 3);

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.of(context).accent,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: child,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(EnumProperty<SlideDirection>('direction', direction));
  }
}
