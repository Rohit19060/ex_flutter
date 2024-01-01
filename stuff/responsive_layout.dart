import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const int mobileWidth = 600, tabletWidth = 800, desktopWidth = 1000;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: const Home(),
        theme: ThemeData(primarySwatch: Colors.purple),
      );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        // backgroundColor: currentWidth < 600 ? Colors.red : Colors.blue,
        body: ResponsiveLayout(
          mobileBody: MobileLayout(),
          desktopBody: DesktopLayout(),
        ),
      );
}

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.desktopBody,
  });
  final Widget mobileBody;
  final Widget desktopBody;

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const DesktopLayout();
        } else {
          return const MobileLayout();
        }
      });
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  child: ColoredBox(color: Colors.deepPurple.shade400),
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
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.deepPurple.shade300,
                        height: 120,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.deepPurple.shade300,
                            height: 120,
                          ),
                        ),
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
