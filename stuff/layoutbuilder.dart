import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int _counter = 0;
  int _selectedIndex = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 500) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('LayoutBuilder'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'You have pushed the button this many times:',
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    onPressed: () {},
                    tooltip: 'Increment',
                    child: const Icon(Icons.arrow_forward),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              drawer: const Drawer(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('First'),
                    ),
                    ListTile(
                      leading: Icon(Icons.bookmark),
                      title: Text('Second'),
                    ),
                    ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Third'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Row(
                  children: <Widget>[
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      labelType: NavigationRailLabelType.selected,
                      destinations: const <NavigationRailDestination>[
                        NavigationRailDestination(
                          icon: Icon(Icons.favorite_border),
                          selectedIcon: Icon(Icons.favorite),
                          label: Text('First'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.bookmark_border),
                          selectedIcon: Icon(Icons.book),
                          label: Text('Second'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.star_border),
                          selectedIcon: Icon(Icons.star),
                          label: Text('Third'),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    // This is the main content.
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'You have pushed the button this many times:',
                            ),
                            Text(
                              '$_counter',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(Icons.arrow_forward),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            );
          }
        },
      );
}
