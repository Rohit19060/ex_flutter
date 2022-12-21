import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppThemeDataTween extends Tween<AppThemeData> {
  AppThemeDataTween({super.begin, super.end});

  @override
  AppThemeData lerp(double t) => AppThemeData.lerp(begin!, end!, t);
}

class AnimatedAppTheme extends ImplicitlyAnimatedWidget {
  const AnimatedAppTheme({
    super.key,
    required super.duration,
    required this.data,
    required this.child,
  });
  final AppThemeData data;
  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedAppTheme> createState() =>
      _AnimatedAppThemeState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppThemeData>('data', data));
  }
}

class _AnimatedAppThemeState extends AnimatedWidgetBaseState<AnimatedAppTheme> {
  AppThemeDataTween? _themeDataTween;

  @override
  Widget build(BuildContext context) => AppTheme(
        data: _themeDataTween!.evaluate(animation),
        child: widget.child,
      );

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _themeDataTween = visitor(
      _themeDataTween,
      widget.data,
      (value) => AppThemeDataTween(begin: value as AppThemeData),
    ) as AppThemeDataTween?;
  }
}
