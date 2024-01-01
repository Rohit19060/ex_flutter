import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InputModeButton extends StatelessWidget {
  const InputModeButton({
    required this.animationDuration,
    required this.simpleInputMode,
    required this.onModeChanged,
    super.key,
  });

  final Duration animationDuration;
  final bool simpleInputMode;
  final VoidCallback onModeChanged;

  @override
  Widget build(BuildContext context) => AnimatedCrossFade(
        alignment: Alignment.centerLeft,
        firstCurve: Curves.easeInOutCubic,
        secondCurve: Curves.easeInOutCubic,
        firstChild: Button(label: 'Rotational', onTap: onModeChanged),
        secondChild: Button(label: 'Simple', onTap: onModeChanged),
        crossFadeState: simpleInputMode
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: animationDuration,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ObjectFlagProperty<VoidCallback>.has('onModeChanged', onModeChanged));
    properties
        .add(DiagnosticsProperty<bool>('simpleInputMode', simpleInputMode));
    properties.add(
        DiagnosticsProperty<Duration>('animationDuration', animationDuration));
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Text(
          label.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties.add(StringProperty('label', label));
  }
}
