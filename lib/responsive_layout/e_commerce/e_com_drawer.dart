import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../k_padding.dart';
import 'drawer/drawer_items.dart';

class ECommerceDrawer extends StatelessWidget {
  const ECommerceDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: double.infinity,
        padding: const EdgeInsets.only(top: kIsWeb ? kPadding : 1),
        color: Theme.of(context).colorScheme.secondary,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/sellar.png',
                      width: 150,
                    ),
                    const Spacer(),
                    //if (!ResponsiveLayout.isMacbook(context)) CloseButton(),
                  ],
                ),
                const SizedBox(height: kPadding),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(
                    width: 300,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(vertical: kPadding),
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                            Colors.white.withOpacity(0.8))),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: kPadding),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(
                    width: 300,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(
                            vertical: kPadding,
                          ),
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                            Colors.white.withOpacity(0.8))),
                    child: Text(
                      'Register',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: kPadding * 2),
                DrawerItems(
                  onPressed: () {},
                  title: 'Your Account',
                  icon: Icons.person_outline_outlined,
                ),
                DrawerItems(
                  onPressed: () {},
                  title: 'Your Orders',
                  icon: Icons.cloud_circle_outlined,
                ),
                DrawerItems(
                  onPressed: () {},
                  title: 'Shop',
                  icon: Icons.shopping_bag_outlined,
                  selected: true,
                ),
                DrawerItems(
                  onPressed: () {},
                  title: 'Security',
                  icon: Icons.lock_outline_rounded,
                ),
                DrawerItems(
                  onPressed: () {},
                  title: 'Your Payments',
                  icon: Icons.payment,
                ),
                DrawerItems(
                  onPressed: () {},
                  title: 'Gift Cards',
                  icon: Icons.card_giftcard,
                ),
                DrawerItems(
                  onPressed: () {},
                  title: 'Communication',
                  icon: Icons.drafts_outlined,
                ),
                DrawerItems(
                  onPressed: () {},
                  title: 'Messages',
                  icon: Icons.message_outlined,
                  number: 2,
                ),
                DrawerItems(
                  onPressed: () {},
                  title: 'Notifications',
                  icon: Icons.notifications_active_outlined,
                ),
                DrawerItems(
                  onPressed: () {},
                  title: 'Advertising',
                  icon: Icons.account_box_outlined,
                ),
                const SizedBox(height: kPadding * 2),
              ],
            ),
          ),
        ),
      );
}
