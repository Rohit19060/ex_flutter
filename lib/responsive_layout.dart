import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const int mobileWidth = 600, tabletWidth = 800, desktopWidth = 1000;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      theme: ThemeData(primarySwatch: Colors.purple),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final currentWidth = MediaQuery.of(context).size.width;
    return const Scaffold(
      // backgroundColor: currentWidth < 600 ? Colors.red : Colors.blue,
      body: ResponsiveLayout(
        mobileBody: MobileLayout(),
        desktopBody: DesktopLayout(),
      ),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;
  const ResponsiveLayout({
    Key? key,
    required this.mobileBody,
    required this.desktopBody,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return const DesktopLayout();
      } else {
        return const MobileLayout();
      }
    });
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: const Text('M O B I L E'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.deepPurple.shade400,
                ),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                  },
                ),
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.deepPurple.shade300,
                        height: 120,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Desktop'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      height: 250,
                      color: Colors.deepPurple.shade400,
                    ),
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.touch,
                      },
                    ),
                    child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.deepPurple.shade300,
                            height: 120,
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(color: Colors.deepPurple.shade200, width: 10),
        ],
      ),
    );
  }
}
