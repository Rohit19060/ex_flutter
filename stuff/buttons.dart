import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'navigation_bar.dart';

class Button1 extends StatelessWidget {
  const Button1({
    super.key,
    required this.txt,
    required this.tap,
    required this.icon,
  });
  final String txt;
  final IconData icon;
  final GestureTapCallback tap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.blue.withOpacity(0.5),
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: tap,
            child: NeuContainer(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(txt),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<GestureTapCallback>.has('tap', tap));
    properties.add(StringProperty('txt', txt));
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
  }
}
