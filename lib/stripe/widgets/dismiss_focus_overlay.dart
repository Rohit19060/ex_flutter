import 'package:flutter/widgets.dart';

class DismissFocusOverlay extends StatelessWidget {
  const DismissFocusOverlay({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: child,
      );
}
