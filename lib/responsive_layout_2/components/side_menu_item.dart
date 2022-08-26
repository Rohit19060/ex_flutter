import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../constants.dart';
import 'counter_badge.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({
    super.key,
    this.isActive = false,
    this.isHover = false,
    this.itemCount = 0,
    this.showBorder = true,
    required this.iconSrc,
    required this.title,
    required this.press,
  });

  final bool isActive, isHover, showBorder;
  final int itemCount;
  final String iconSrc, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: kDefaultPadding),
        child: InkWell(
          onTap: press,
          child: Row(
            children: [
              if (isActive || isHover)
                WebsafeSvg.asset(
                  'assets/icons/Angle right.svg',
                  width: 15,
                )
              else
                const SizedBox(width: 15),
              const SizedBox(width: kDefaultPadding / 4),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 15, right: 5),
                  decoration: showBorder
                      ? const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFDFE2EF)),
                          ),
                        )
                      : null,
                  child: Row(
                    children: [
                      WebsafeSvg.asset(
                        iconSrc,
                        height: 20,
                        color:
                            (isActive || isHover) ? kPrimaryColor : kGrayColor,
                      ),
                      const SizedBox(width: kDefaultPadding * 0.75),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: (isActive || isHover)
                                  ? kTextColor
                                  : kGrayColor,
                            ),
                      ),
                      const Spacer(),
                      if (itemCount != 0) CounterBadge(count: itemCount)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('press', press));
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('iconSrc', iconSrc));
    properties.add(IntProperty('itemCount', itemCount));
    properties.add(DiagnosticsProperty<bool>('showBorder', showBorder));
    properties.add(DiagnosticsProperty<bool>('isHover', isHover));
    properties.add(DiagnosticsProperty<bool>('isActive', isActive));
  }
}
