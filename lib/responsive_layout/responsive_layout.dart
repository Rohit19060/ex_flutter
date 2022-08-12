import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout(
      {super.key,
      required this.ipad,
      required this.iphone,
      required this.macBook});
  final Widget iphone;
  final Widget ipad;
  final Widget macBook;

  static int iphoneLimit = 600;
  static int ipadLimit = 1200;

  static bool isIphone(BuildContext context) =>
      MediaQuery.of(context).size.width < iphoneLimit;

  static bool isIpad(BuildContext context) =>
      MediaQuery.of(context).size.width < ipadLimit &&
      MediaQuery.of(context).size.width >= iphoneLimit;

  static bool isMacBook(BuildContext context) =>
      MediaQuery.of(context).size.width >= ipadLimit;

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < iphoneLimit) {
          return iphone;
        }
        if (constraints.maxWidth < ipadLimit) {
          return ipad;
        } else {
          return macBook;
        }
      });
}
