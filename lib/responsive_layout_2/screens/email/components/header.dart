import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';
import '../../../responsive.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: [
          if (Responsive.isMobile(context)) const BackButton(),
          IconButton(
            icon: WebsafeSvg.asset(
              'assets/icons/Trash.svg',
              width: 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: WebsafeSvg.asset(
              'assets/icons/Reply.svg',
              width: 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: WebsafeSvg.asset(
              'assets/icons/Reply all.svg',
              width: 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: WebsafeSvg.asset(
              'assets/icons/Transfer.svg',
              width: 24,
            ),
            onPressed: () {},
          ),
          const Spacer(),
          if (Responsive.isDesktop(context))
            IconButton(
              icon: WebsafeSvg.asset(
                'assets/icons/Printer.svg',
                width: 24,
              ),
              onPressed: () {},
            ),
          IconButton(
            icon: WebsafeSvg.asset(
              'assets/icons/Markup.svg',
              width: 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: WebsafeSvg.asset(
              'assets/icons/More vertical.svg',
              width: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
