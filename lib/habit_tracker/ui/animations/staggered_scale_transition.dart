import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StaggeredScaleTransition extends StatelessWidget {
  StaggeredScaleTransition({
    super.key,
    required Animation<double> animation,
    required int index,
    required this.child,
  }) : scaleAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(
              0.1 * index,
              0.5 + 0.1 * index,
              curve: Curves.easeInOutCubic,
            ),
          ),
        );
  final Widget child;
  final Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: scaleAnimation,
        child: child,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Animation<double>>(
        'scaleAnimation', scaleAnimation));
  }
}
