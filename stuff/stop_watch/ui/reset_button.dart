import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => ClipOval(
        child: Material(
          color: Colors.grey[900], // button color
          child: InkWell(
            onTap: onPressed,
            child: const Align(
              child: Text('Reset'),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }
}
