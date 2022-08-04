import 'package:flutter/material.dart';

const double buttonSize = 80;
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flow Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Flutter Experiments')),
        body: const Center(),
        floatingActionButton: const LinearFlowWidget(),
      );
}

class LinearFlowWidget extends StatefulWidget {
  const LinearFlowWidget({super.key});

  @override
  State<LinearFlowWidget> createState() => _LinearFlowWidgetState();
}

class _LinearFlowWidgetState extends State<LinearFlowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) => Flow(
        delegate: FlowMenuDelegate(animation: _controller),
        children: const [
          Icons.menu,
          Icons.phone,
          Icons.camera,
          Icons.notifications
        ].map<Widget>(buildItem).toList(),
      );

  Widget buildItem(IconData icon) => SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: FloatingActionButton(
          elevation: 0.0,
          splashColor: Colors.black,
          child: Icon(
            icon,
            color: Colors.white,
            size: 32.0,
          ),
          onPressed: () {
            if (_controller.status == AnimationStatus.completed) {
              _controller.reverse();
            } else {
              _controller.forward();
            }
          },
        ),
      );
}

class FlowMenuDelegate extends FlowDelegate {

  const FlowMenuDelegate({required this.animation}) : super(repaint: animation);
  final Animation<double> animation;

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - buttonSize;
    final yStart = size.height - buttonSize;

    for (var i = context.childCount - 1; i >= 0; i--) {
      final childSize = context.getChildSize(i)!.width;
      final dx = (childSize + 8) * i;
      final x = xStart;
      final y = yStart - dx * animation.value;
      context.paintChild(i, transform: Matrix4.translationValues(x, y, 0));
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    throw UnimplementedError();
  }
}
