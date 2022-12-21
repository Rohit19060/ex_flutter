import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theming/app_theme.dart';

class HomePageBottomOptions extends StatelessWidget {
  const HomePageBottomOptions({
    super.key,
    this.onFlip,
    this.onEnterEditMode,
  });
  final VoidCallback? onFlip;
  final VoidCallback? onEnterEditMode;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onEnterEditMode,
            icon: Icon(
              Icons.settings,
              color: AppTheme.of(context).settingsLabel,
            ),
          ),
          IconButton(
            onPressed: onFlip,
            icon: Icon(
              Icons.flip,
              color: AppTheme.of(context).settingsLabel,
            ),
          ),
          // invisible
          Opacity(
            opacity: 0.0,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has(
        'onEnterEditMode', onEnterEditMode));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onFlip', onFlip));
  }
}
