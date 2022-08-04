import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../components/side_menu.dart';
import '../../../constants.dart';
import '../../../models/email.dart';
import '../../../responsive.dart';
import '../../email/email_screen.dart';
import 'email_card.dart';

class ListOfEmails extends StatefulWidget {
  const ListOfEmails({
    super.key,
    required this.onMenuTap,
    required this.mailIndex,
  });
  final Function(int) onMenuTap;
  final int mailIndex;

  @override
  State<ListOfEmails> createState() => _ListOfEmailsState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('mailIndex', mailIndex));
    properties
        .add(ObjectFlagProperty<Function(int p1)>.has('onMenuTap', onMenuTap));
  }
}

class _ListOfEmailsState extends State<ListOfEmails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: const SideMenu(),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
          color: kBgDarkColor,
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Row(
                    children: [
                      if (!Responsive.isDesktop(context))
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState!.openDrawer();
                          },
                        ),
                      if (!Responsive.isDesktop(context))
                        const SizedBox(width: 5),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextField(
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'Search',
                              fillColor: kBgLightColor,
                              filled: true,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(
                                    kDefaultPadding * 0.75), //15
                                child: WebsafeSvg.asset(
                                  'assets/icons/Search.svg',
                                  width: 24,
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Row(
                    children: [
                      WebsafeSvg.asset(
                        'assets/icons/Angle down.svg',
                        width: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Sort by date',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      MaterialButton(
                        minWidth: 20,
                        onPressed: () {},
                        child: WebsafeSvg.asset(
                          'assets/icons/Sort.svg',
                          width: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                Expanded(
                  child: ListView.builder(
                    itemCount: emails.length,
                    itemBuilder: (context, index) => EmailCard(
                      isActive: index == widget.mailIndex,
                      email: emails[index],
                      press: Responsive.isMobile(context)
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EmailScreen(email: emails[index]),
                                ),
                              );
                            }
                          : () {
                              widget.onMenuTap(index);
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
