import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../k_padding.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({
    super.key,
    this.selected = false,
    this.number = 0,
    required this.icon,
    required this.title,
    required this.onPressed,
  });
  final bool selected;
  final int number;
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: selected
                  ? Theme.of(context).primaryColor.withOpacity(0.9)
                  : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: kPadding / 2),
              child: InkWell(
                onTap: onPressed,
                child: Row(
                  children: [
                    const SizedBox(width: kPadding / 3),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 15, right: 5),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              color: selected
                                  ? Colors.white
                                  : Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(width: kPadding * 0.75),
                            Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: selected
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.5),
                                  ),
                            ),
                            const Spacer(),
                            if (number != 0)
                              Badge(label: Text(number.toString()))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider()
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(StringProperty('title', title));
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(IntProperty('number', number));
    properties.add(DiagnosticsProperty<bool>('selected', selected));
  }
}
