import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Bubble Trouble',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink.shade100,
              child: Center(
                  child: Stack(
                children: [
                  Container(
                      child: Container(
                    color: Colors.blue,
                    height: 50,
                    width: 50,
                  ))
                ],
              )),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.arrow_back,
                    function: () {},
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    function: () {},
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    function: () {},
                  ),
                ],
              ),
            ),
          )
        ],
      );
}

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.icon, required this.function});
  final IconData icon;
  final Function() function;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.grey.shade100,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: function,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Center(child: Icon(icon)),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(ObjectFlagProperty<Function()>.has('function', function));
  }
}
