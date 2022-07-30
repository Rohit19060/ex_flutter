import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Material You Floating Action Button',
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                FloatingActionButton.extended(
                  onPressed: () {},
                  label: const Text('Floating Action Button One'),
                ),
                FloatingActionButton.large(
                  onPressed: () {},
                  child: const Icon(Icons.ac_unit),
                ),
                FloatingActionButton.small(
                  onPressed: () {},
                  child: const Icon(Icons.ac_unit),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.ac_unit),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                      floatingActionButtonTheme:
                          const FloatingActionButtonThemeData(
                              extendedSizeConstraints: BoxConstraints.tightFor(
                                  height: 80, width: 240))),
                  child: FloatingActionButton.extended(
                    onPressed: () {},
                    label: const Text('Compose'),
                    icon: const Icon(Icons.ac_unit),
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                      largeSizeConstraints:
                          BoxConstraints.tightFor(width: 120, height: 120),
                    ),
                  ),
                  child: FloatingActionButton.large(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    onPressed: () {},
                    child: const Icon(Icons.ac_unit),
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
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
                    label: const Text('Compose'),
                    icon: const Icon(Icons.ac_unit),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
