import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelectableTile extends StatefulWidget {
  const SelectableTile({super.key, required this.builder, this.onPressed});
  final Widget Function(BuildContext, bool) builder;
  final VoidCallback? onPressed;

  @override
  State<SelectableTile> createState() => _SelectableTileState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(
        ObjectFlagProperty<Widget Function(BuildContext p1, bool p2)>.has(
            'builder', builder));
  }
}

class _SelectableTileState extends State<SelectableTile> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapDown: (_) => setState(() => _isPressed = true),
        onTap: widget.onPressed,
        child: widget.builder(context, _isPressed),
      );
}
