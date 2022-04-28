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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              height: 70,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              backgroundColor: Colors.white,
              indicatorColor: Color.fromARGB(255, 0, 140, 255),
              labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              )),
          child: NavigationBar(
            animationDuration: const Duration(seconds: 1),
            selectedIndex: index,
            onDestinationSelected: (int index) =>
                setState(() => this.index = index),
            destinations: const [
              NavigationDestination(
                  tooltip: "Photos",
                  selectedIcon: Icon(
                    Icons.photo_size_select_actual_rounded,
                    color: Colors.white,
                  ),
                  icon: Icon(Icons.photo_size_select_actual_outlined),
                  label: "Photos"),
              NavigationDestination(
                  selectedIcon: Icon(
                    Icons.image_search_outlined,
                    color: Colors.white,
                  ),
                  icon: Icon(Icons.image_search_rounded),
                  label: "Search"),
              NavigationDestination(
                  selectedIcon: Icon(
                    Icons.people_outlined,
                    color: Colors.white,
                  ),
                  icon: Icon(Icons.people_outline_rounded),
                  label: "Sharing"),
              NavigationDestination(
                  selectedIcon: Icon(
                    Icons.collections_rounded,
                    color: Colors.white,
                  ),
                  icon: Icon(Icons.collections_outlined),
                  label: "Library")
            ],
          ),
        ),
      ));
}
