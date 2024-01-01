import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StartStopButton extends StatelessWidget {
  const StartStopButton({super.key, required this.isRunning, this.onPressed});
  final bool isRunning;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => ClipOval(
        child: Material(
          color:
              isRunning ? Colors.red[900] : Colors.green[900], // button color
          child: InkWell(
            onTap: onPressed,
            child: Align(
              child: Text(
                isRunning ? 'Stop' : 'Start',
              ),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<bool>('isRunning', isRunning));
  }
}
