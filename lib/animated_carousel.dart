import 'package:flutter/material.dart';

class DetailModel {
  DetailModel({required this.title, required this.description});
  String title;
  String description;
}

final detailModelsList = [
  DetailModel(
      title: 'New York City',
      description:
          'From a central park, to a broadway theatre and the iconic Times square'),
  DetailModel(
      title: 'Cape Town',
      description:
          'At the tip of Africa, you will find a city that has it all to offer. Explore Table Mountain and Robben Island'),
  DetailModel(
      title: 'Switzerland',
      description:
          'Breathtaking lakes, villages and the high peaks of the Alps for amazing Ski resorts'),
];

final imageList = [
  'assets/images/newyork.jpg',
  'assets/images/capetown.jpg',
  'assets/images/switzerland.jpg',
];

final colorsList = [
  Colors.redAccent.shade100,
  Colors.blueAccent.shade100,
  Colors.amber.shade50,
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.8,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              color: colorsList[_currentPage],
            ),
            Column(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 500.0,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    physics: const ClampingScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) => itemBuilder(index),
                  ),
                ),
                _detailsBuilder(_currentPage),
              ],
            ),
          ],
        ),
      );

  Widget _detailsBuilder(int index) => AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          var value = 1.0;
          if (_pageController.position.haveDimensions) {
            value = _pageController.page! - index;
            value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
          }
          return Expanded(
            child: Transform.translate(
              offset: Offset(
                0,
                100 + (-value * 100),
              ),
              child: Opacity(
                opacity: value,
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          detailModelsList[index].title,
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          detailModelsList[index].description,
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: 80.0,
                          height: 5.0,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          'Read More',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

  Widget itemBuilder(int index) => AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          var value = 1.0;
          if (_pageController.position.haveDimensions) {
            value = _pageController.page! - index;
            value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Curves.easeIn.transform(value) * 500,
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0),
                child: child,
              ),
            );
          } else {
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                height:
                    Curves.easeIn.transform(index == 0 ? value : value * 0.5) *
                        500,
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0),
                child: child,
              ),
            );
          }
        },
        child: Material(
          elevation: 4.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15.0),
              ),
              child: Image.asset(
                imageList[index],
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      );

  _onPageChanged(int index) {
    setState(() {
      print(index);
      _currentPage = index;
    });
  }
}
