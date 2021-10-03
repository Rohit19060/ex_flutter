import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;

  final screens = [
    const Center(
        child: Text(
      'Photos',
      style: TextStyle(fontSize: 66),
    )),
    const Center(
        child: Text(
      'Search',
      style: TextStyle(fontSize: 66),
    )),
    const Center(
        child: Text(
      'Sharing',
      style: TextStyle(fontSize: 55),
    )),
    const Center(
        child: Text(
      'Library',
      style: TextStyle(fontSize: 66),
    )),
  ];

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Material You Navigation Bar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          // Flating action Button 1
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () {},
          //   label: const Text("Floating Action Button One"),
          // Flating action Button  2
          // floatingActionButton: FloatingActionButton.large(
          //   onPressed: () {},
          //   child: const Icon(Icons.ac_unit),
          // Flating action Button  3
          // floatingActionButton: FloatingActionButton.small(
          //   onPressed: () {},
          //   child: const Icon(Icons.ac_unit),
          // ),
          // Flating action Button  4
          //   floatingActionButton: FloatingActionButton(
          // onPressed: () {},
          // child: const Icon(Icons.ac_unit),
          // Floating action button 5
          // floatingActionButton: Theme(
          //   data: Theme.of(context).copyWith(
          //       floatingActionButtonTheme: const FloatingActionButtonThemeData(
          //           extendedSizeConstraints:
          //               BoxConstraints.tightFor(height: 80, width: 240))),
          //   child: FloatingActionButton.extended(
          //     onPressed: () {},
          //     label: const Text("Compose"),
          //     icon: const Icon(Icons.ac_unit),
          //   ),
          // ),
          // Floating action button 6
          // floatingActionButton: Theme(
          //   data: Theme.of(context).copyWith(
          //     floatingActionButtonTheme: const FloatingActionButtonThemeData(
          //       largeSizeConstraints:
          //           BoxConstraints.tightFor(width: 120, height: 120),
          //     ),
          //   ),
          //   child: FloatingActionButton.large(
          //     backgroundColor: Colors.amber,
          //     foregroundColor: Colors.black,
          //     onPressed: () {},
          //     child: const Icon(Icons.ac_unit),
          //   ),
          // ),
          // Floating action button 7
          floatingActionButton: Theme(
            data: Theme.of(context).copyWith(
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                largeSizeConstraints:
                    BoxConstraints.tightFor(width: 120, height: 120),
              ),
            ),
            child: FloatingActionButton.extended(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              extendedIconLabelSpacing: 24,
              extendedPadding: const EdgeInsets.all(44),
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              onPressed: () {},
              label: const Text("Compose"),
              icon: const Icon(Icons.ac_unit),
            ),
          ),
        ),
      );
}
