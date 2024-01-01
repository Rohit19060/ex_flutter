import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedBottomBar extends StatefulWidget {
  const AnimatedBottomBar({
    super.key,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.onBarTap,
  });
  final Duration animationDuration;
  final Function(int) onBarTap;

  @override
  State<AnimatedBottomBar> createState() => _AnimatedBottomBarState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Function>('onBarTap', onBarTap));
    properties.add(
        DiagnosticsProperty<Duration>('animationDuration', animationDuration));
    properties.add(IterableProperty<BarItem>('barItems', barItems));
  }
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex = 0;

  @override
  Widget build(BuildContext context) => Material(
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildBarItems(),
          ),
        ),
      );

  List<Widget> _buildBarItems() {
    final barItemsWidgets = <Widget>[];
    for (var i = 0; i < barItems.length; i++) {
      final item = barItems[i];
      final isSelected = selectedBarIndex == i;
      barItemsWidgets.add(
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              selectedBarIndex = i;
              widget.onBarTap(selectedBarIndex);
            });
          },
          child: AnimatedContainer(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            duration: widget.animationDuration,
            decoration: BoxDecoration(
              color: isSelected
                  ? item.color.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  item.iconData,
                  color: isSelected ? item.color : Colors.black,
                  size: 32.0,
                ),
                const SizedBox(width: 10.0),
                AnimatedSize(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  child: Text(
                    isSelected ? item.text : '',
                    style: TextStyle(
                      color: item.color,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return barItemsWidgets;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('selectedBarIndex', selectedBarIndex));
  }
}

class BarItem {
  const BarItem({
    required this.text,
    required this.color,
    required this.iconData,
  });
  final String text;
  final Color color;
  final IconData iconData;
}

class BottomBarNavigationPatternExample extends StatefulWidget {
  const BottomBarNavigationPatternExample({super.key});
  @override
  State<BottomBarNavigationPatternExample> createState() =>
      _BottomBarNavigationPatternExampleState();
}

class _BottomBarNavigationPatternExampleState
    extends State<BottomBarNavigationPatternExample> {
  int selectedBarIndex = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: AnimatedBottomBar(
          animationDuration: const Duration(milliseconds: 150),
          onBarTap: (index) => setState(() => selectedBarIndex = index),
        ),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: barItems[selectedBarIndex].color,
          child: Center(
            child: Text(
              barItems[selectedBarIndex].text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('selectedBarIndex', selectedBarIndex));
    properties.add(IterableProperty<BarItem>('barItems', barItems));
  }
}

const List<BarItem> barItems = [
  BarItem(
    text: 'Home',
    iconData: Icons.home,
    color: Colors.indigo,
  ),
  BarItem(
    text: 'Likes',
    iconData: Icons.favorite_border,
    color: Colors.pinkAccent,
  ),
  BarItem(
    text: 'Search',
    iconData: Icons.search,
    color: Colors.yellow,
  ),
  BarItem(
    text: 'Profile',
    iconData: Icons.person_outline,
    color: Colors.teal,
  ),
];
