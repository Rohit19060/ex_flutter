import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theming/app_theme.dart';

class ThemeSelectionClose extends StatelessWidget {
  const ThemeSelectionClose({super.key, this.onClose});
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onClose,
        icon: Icon(
          Icons.close,
          color: AppTheme.of(context).accentNegative,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onClose', onClose));
  }
}
