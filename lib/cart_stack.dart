import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<String> images = [
  'assets/images/capetown.jpg',
  'assets/images/athens.jpg',
  'assets/images/lasvegas.jpg',
];

class CardStack extends StatefulWidget {
  const CardStack({super.key});

  @override
  State<CardStack> createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  double currentPage = images.length - 1.0;
  PageController controller = PageController(initialPage: images.length - 1);

  @override
  void initState() {
    super.initState();
    controller
        .addListener(() => setState(() => currentPage = controller.page ?? 0));
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 45, 52, 71),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: <Widget>[
                    CardScrollWidget(currentPage),
                    Positioned.fill(
                      child: PageView.builder(
                        itemCount: images.length,
                        controller: controller,
                        reverse: true,
                        itemBuilder: (context, index) => const SizedBox(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('currentPage', currentPage));
    properties
        .add(DiagnosticsProperty<PageController>('controller', controller));
  }
}

class CardScrollWidget extends StatelessWidget {
  const CardScrollWidget(
    this.currentPage, {
    super.key,
    this.padding = 20,
    this.verticalInset = 20,
  });

  final double currentPage;
  final double padding;
  final double verticalInset;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: (12.0 / 16.0) * 1.2,
        child: LayoutBuilder(builder: (context, contraints) {
          final width = contraints.maxWidth;
          final height = contraints.maxHeight;

          final safeWidth = width - 2 * padding;
          final safeHeight = height - 2 * padding;

          final heightOfPrimaryCard = safeHeight;
          final widthOfPrimaryCard = heightOfPrimaryCard * (12.0 / 16.0);

          final primaryCardLeft = safeWidth - widthOfPrimaryCard;
          final horizontalInset = primaryCardLeft / 2;

          final cardList = <Widget>[];

          for (var i = 0; i < images.length; i++) {
            final delta = i - currentPage;
            final isOnRight = delta > 0;

            final start = padding +
                max(
                    primaryCardLeft -
                        horizontalInset * -delta * (isOnRight ? 15 : 1),
                    0.0);

            cardList.add(
              Positioned.directional(
                top: padding + verticalInset * max(-delta, 0.0),
                bottom: padding + verticalInset * max(-delta, 0.0),
                start: start,
                textDirection: TextDirection.rtl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: DecoratedBox(
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(3.0, 6.0),
                        blurRadius: 10.0,
                      )
                    ]),
                    child: AspectRatio(
                      aspectRatio: 12.0 / 16.0,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.asset(images[i], fit: BoxFit.cover),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, bottom: 12.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: const Text('Read Later',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Stack(children: cardList);
        }),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('verticalInset', verticalInset));
    properties.add(DoubleProperty('padding', padding));
    properties.add(DiagnosticsProperty('currentPage', currentPage));
  }
}
