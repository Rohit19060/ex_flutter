import 'package:flutter/material.dart';

import '../../components/side_menu.dart';
import '../../models/email.dart';
import '../../responsive.dart';
import '../email/email_screen.dart';
import 'components/list_of_emails.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: const ListOfEmails(),
        tablet: Row(
          children: [
            const Expanded(
              flex: 6,
              child: ListOfEmails(),
            ),
            Expanded(
              flex: 9,
              child: EmailScreen(email: emails[1]),
            ),
          ],
        ),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: size.width > 1340 ? 2 : 4,
              child: const SideMenu(),
            ),
            Expanded(
              flex: size.width > 1340 ? 3 : 5,
              child: const ListOfEmails(),
            ),
            Expanded(
              flex: size.width > 1340 ? 8 : 10,
              child: EmailScreen(email: emails[1]),
            ),
          ],
        ),
      ),
    );
  }
}
