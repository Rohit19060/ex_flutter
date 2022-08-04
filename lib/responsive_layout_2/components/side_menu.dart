import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../constants.dart';
import '../extensions.dart';
import '../responsive.dart';
import 'side_menu_item.dart';
import 'tags.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: double.infinity,
        padding: const EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgLightColor,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/Logo Outlook.png', width: 36)
                        .addNeumorphism(
                      topShadowColor: Colors.white,
                      bottomShadowColor:
                          const Color(0xFF234395).withOpacity(0.2),
                    ),
                    const Spacer(),
                    if (!Responsive.isDesktop(context)) const CloseButton(),
                  ],
                ),
                const SizedBox(height: kDefaultPadding),
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: kDefaultPadding,
                            horizontal: kDefaultPadding)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  icon: WebsafeSvg.asset('assets/icons/Edit.svg', width: 16),
                  label: const Text(
                    'New message',
                    style: TextStyle(color: Colors.white),
                  ),
                ).addNeumorphism(
                  topShadowColor: Colors.white,
                  bottomShadowColor: const Color(0xFF234395).withOpacity(0.2),
                ),
                const SizedBox(height: kDefaultPadding),
                TextButton.icon(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: kDefaultPadding,
                            horizontal: kDefaultPadding)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(kBgDarkColor),
                  ),
                  onPressed: () {},
                  icon:
                      WebsafeSvg.asset('assets/icons/Download.svg', width: 16),
                  label: const Text(
                    'Get messages',
                    style: TextStyle(color: kTextColor),
                  ),
                ).addNeumorphism(
                  topShadowColor: Colors.white,
                  bottomShadowColor: const Color(0xFF234395).withOpacity(0.2),
                ),
                const SizedBox(height: kDefaultPadding * 2),
                SideMenuItem(
                  press: () {},
                  title: 'Inbox',
                  iconSrc: 'assets/icons/Inbox.svg',
                  isActive: true,
                  itemCount: 3,
                ),
                SideMenuItem(
                  press: () {},
                  title: 'Sent',
                  iconSrc: 'assets/icons/Send.svg',
                ),
                SideMenuItem(
                  press: () {},
                  title: 'Drafts',
                  iconSrc: 'assets/icons/File.svg',
                ),
                SideMenuItem(
                  press: () {},
                  title: 'Deleted',
                  iconSrc: 'assets/icons/Trash.svg',
                  showBorder: false,
                ),
                const SizedBox(height: kDefaultPadding * 2),
                const Tags(),
              ],
            ),
          ),
        ),
      );
}
