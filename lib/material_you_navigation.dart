import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'color_themes.dart';

class MaterialYouNavigation extends StatefulWidget {
  const MaterialYouNavigation({super.key});

  @override
  State<MaterialYouNavigation> createState() => _MaterialYouNavigationState();
}

class _MaterialYouNavigationState extends State<MaterialYouNavigation> {
  int index = 0;

  final screens = [
    const Center(child: Text('Photos', style: TextStyle(fontSize: 66))),
    const Center(child: Text('Search', style: TextStyle(fontSize: 66))),
    const Center(child: Text('Sharing', style: TextStyle(fontSize: 55))),
    const Center(child: Text('Library', style: TextStyle(fontSize: 66))),
  ];

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Material You Navigation Bar',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: Scaffold(
          body: screens[index],
          bottomNavigationBar: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            indicatorColor: primaryColors.first,
            animationDuration: const Duration(seconds: 1),
            selectedIndex: index,
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
            destinations: const [
              NavigationDestination(
                tooltip: 'Photos',
                selectedIcon: Icon(
                  Icons.photo_size_select_actual_rounded,
                  color: Colors.white,
                ),
                icon: Icon(Icons.photo_size_select_actual_outlined),
                label: 'Photos',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.image_search_outlined,
                  color: Colors.white,
                ),
                icon: Icon(Icons.image_search_rounded),
                label: 'Search',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.people_outlined,
                  color: Colors.white,
                ),
                icon: Icon(Icons.people_outline_rounded),
                label: 'Sharing',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.collections_rounded,
                  color: Colors.white,
                ),
                icon: Icon(Icons.collections_outlined),
                label: 'Library',
              )
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
  }
}
