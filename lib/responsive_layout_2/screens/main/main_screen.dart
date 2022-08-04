import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/side_menu.dart';
import '../../models/email.dart';
import '../../responsive.dart';
import '../email/email_screen.dart';
import 'components/list_of_emails.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int mailIndex = 0;

  void updateMailIndex(int index) => setState(() => mailIndex = index);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ListOfEmails(
          onMenuTap: updateMailIndex,
          mailIndex: mailIndex,
        ),
        tablet: Row(
          children: [
            Expanded(
              flex: 6,
              child: ListOfEmails(
                onMenuTap: updateMailIndex,
                mailIndex: mailIndex,
              ),
            ),
            Expanded(
              flex: 9,
              child: EmailScreen(email: emails[mailIndex]),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: size.width > 1340 ? 2 : 4,
              child: const SideMenu(),
            ),
            Expanded(
              flex: size.width > 1340 ? 3 : 5,
              child: ListOfEmails(
                onMenuTap: updateMailIndex,
                mailIndex: mailIndex,
              ),
            ),
            Expanded(
              flex: size.width > 1340 ? 8 : 10,
              child: EmailScreen(email: emails[mailIndex]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('mailIndex', mailIndex));
  }
}
