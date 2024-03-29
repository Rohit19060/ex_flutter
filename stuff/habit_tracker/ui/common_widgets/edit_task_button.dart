import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_assets.dart';
import '../theming/app_theme.dart';

class EditTaskButton extends StatelessWidget {
  const EditTaskButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  static const scaleFactor = 0.33;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: AppTheme.of(context).accent,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1.5,
              blurRadius: 2,
            ),
          ],
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: SvgPicture.asset(
            threeDots,
            colorFilter: ColorFilter.mode(
              AppTheme.of(context).accentNegative,
              BlendMode.srcIn,
            ),
            width: 16,
            height: 16,
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
