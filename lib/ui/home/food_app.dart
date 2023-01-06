import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xff05080d)),
        home: const BottomBars(),
      );
}

class FoodHomePage extends StatefulWidget {
  const FoodHomePage({super.key});

  @override
  State<FoodHomePage> createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShowUpAnimation(
                  delayStart: const Duration(milliseconds: 200),
                  animationDuration: const Duration(milliseconds: 200),
                  curve: Curves.bounceIn,
                  direction: Direction.horizontal,
                  offset: 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Good evening',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 22),
                      ),
                      Chip(
                        backgroundColor: Color(0xff05080d),
                        side: BorderSide(color: Color(0xff05080d), width: 0),
                        avatar: Icon(
                          Icons.location_on_rounded,
                          color: Color(0xffd32760),
                        ),
                        label: Text(
                          'California, US',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                ShowUpAnimation(
                    delayStart: const Duration(milliseconds: 400),
                    animationDuration: const Duration(milliseconds: 400),
                    curve: Curves.bounceIn,
                    direction: Direction.horizontal,
                    offset: 0.5,
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xffd32760),
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    )),
              ],
            ),
            ShowUpAnimation(
                delayStart: const Duration(milliseconds: 600),
                animationDuration: const Duration(milliseconds: 600),
                curve: Curves.bounceIn,
                direction: Direction.horizontal,
                offset: 0.5,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: Text(
                    'Best choice for dinner',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ShowUpAnimation(
                      delayStart: const Duration(milliseconds: 800),
                      curve: Curves.bounceIn,
                      direction: Direction.horizontal,
                      offset: 0.5,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Text(
                          'Breakfast',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                  ShowUpAnimation(
                      delayStart: const Duration(milliseconds: 1000),
                      animationDuration: const Duration(milliseconds: 1000),
                      curve: Curves.bounceIn,
                      direction: Direction.horizontal,
                      offset: 0.5,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Lunch',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                  ShowUpAnimation(
                      delayStart: const Duration(milliseconds: 1200),
                      animationDuration: const Duration(milliseconds: 1200),
                      curve: Curves.bounceIn,
                      direction: Direction.horizontal,
                      offset: 0.5,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Dinner',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  ShowUpAnimation(
                      delayStart: const Duration(milliseconds: 1400),
                      animationDuration: const Duration(milliseconds: 1400),
                      curve: Curves.bounceIn,
                      direction: Direction.horizontal,
                      offset: 0.5,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Snack',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                  ShowUpAnimation(
                      delayStart: const Duration(milliseconds: 1600),
                      animationDuration: const Duration(milliseconds: 1600),
                      curve: Curves.bounceIn,
                      direction: Direction.horizontal,
                      offset: 0.5,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'FastFood',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const DetailsScreen()));
                      },
                      child: ShowUpAnimation(
                          delayStart: const Duration(milliseconds: 1800),
                          animationDuration: const Duration(milliseconds: 1800),
                          curve: Curves.bounceIn,
                          direction: Direction.horizontal,
                          offset: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              height: 180,
                              width: 320,
                              child: Stack(
                                children: [
                                  Positioned(
                                      left: 10,
                                      child: Container(
                                        height: 180,
                                        width: 310,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff11171e),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      )),
                                  Positioned(
                                    bottom: 5,
                                    left: 0,
                                    child: Image.asset(
                                      'assets/images/beat.png',
                                      height: 180,
                                    ),
                                  ),
                                  Positioned(
                                      top: 20,
                                      left: 180,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Beat Leaf Bowl',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 17),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          const Text(
                                            'Per cent daily values\nare based on 2,000',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            '200g   434 col',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade300,
                                                fontSize: 17),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 50.0),
                                            child: Container(
                                              height: 30,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color(0xffd32760),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  r'$15.99',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          )),
                    ),
                    ShowUpAnimation(
                        delayStart: const Duration(milliseconds: 2000),
                        animationDuration: const Duration(milliseconds: 2000),
                        curve: Curves.bounceIn,
                        direction: Direction.horizontal,
                        offset: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SizedBox(
                            height: 180,
                            width: 320,
                            child: Stack(
                              children: [
                                Positioned(
                                    left: 10,
                                    child: Container(
                                      height: 180,
                                      width: 310,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff11171e),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    )),
                                Positioned(
                                  bottom: 5,
                                  left: 0,
                                  child: Image.asset(
                                    'assets/images/dish.png',
                                    height: 180,
                                  ),
                                ),
                                Positioned(
                                    top: 20,
                                    left: 180,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Beat Leaf Bowl',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        const Text(
                                          'Per cent daily values\nare based on 2,000',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 13),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          '200g   434 col',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade300,
                                              fontSize: 17),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 50.0),
                                          child: Container(
                                            height: 30,
                                            width: 65,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color(0xffd32760),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                r'$15.99',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ShowUpAnimation(
                      delayStart: const Duration(milliseconds: 2200),
                      animationDuration: const Duration(milliseconds: 2200),
                      curve: Curves.bounceIn,
                      offset: 0.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                          height: 230,
                          width: 165,
                          child: Stack(
                            children: [
                              Positioned(
                                  top: 20,
                                  left: 10,
                                  child: Container(
                                    height: 210,
                                    width: 155,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff11171e),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  )),
                              Positioned(
                                top: -10,
                                left: 25,
                                child: Image.asset(
                                  'assets/images/dinner.png',
                                  height: 130,
                                ),
                              ),
                              Positioned(
                                  top: 125,
                                  left: 30,
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Healthy Dinner',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 17),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        '700g   534 col',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade300,
                                            fontSize: 13),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: Container(
                                          height: 30,
                                          width: 65,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xffd32760),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              r'$15.99',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      )),
                  ShowUpAnimation(
                      delayStart: const Duration(milliseconds: 2400),
                      animationDuration: const Duration(milliseconds: 2400),
                      curve: Curves.bounceIn,
                      offset: 0.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                          height: 230,
                          width: 165,
                          child: Stack(
                            children: [
                              Positioned(
                                  top: 20,
                                  left: 10,
                                  child: Container(
                                    height: 210,
                                    width: 155,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff11171e),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  )),
                              Positioned(
                                top: -10,
                                left: 25,
                                child: Image.asset(
                                  'assets/images/dish.png',
                                  height: 130,
                                ),
                              ),
                              Positioned(
                                  top: 125,
                                  left: 30,
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Seefood Dish',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 17),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        '700g   534 col',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade300,
                                            fontSize: 13),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: Container(
                                          height: 30,
                                          width: 65,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xffd32760),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              r'$15.99',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      );
}

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShowUpAnimation(
              delayStart: const Duration(milliseconds: 200),
              animationDuration: const Duration(milliseconds: 200),
              curve: Curves.bounceIn,
              offset: 0.5,
              child: Image.asset(
                'assets/images/beat1.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowUpAnimation(
                    delayStart: const Duration(milliseconds: 400),
                    animationDuration: const Duration(milliseconds: 400),
                    curve: Curves.bounceIn,
                    offset: 0.5,
                    child: const Text(
                      'Beet Leaf Bowl',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      ShowUpAnimation(
                          delayStart: const Duration(milliseconds: 200),
                          animationDuration: const Duration(milliseconds: 200),
                          curve: Curves.bounceIn,
                          direction: Direction.horizontal,
                          offset: 0.5,
                          child: Chip(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            side: BorderSide(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 0),
                            avatar: const CircleAvatar(
                              radius: 3,
                              backgroundColor: Color(0xffd32760),
                            ),
                            label: const Text(
                              '200g',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )),
                      ShowUpAnimation(
                          delayStart: const Duration(milliseconds: 200),
                          curve: Curves.bounceIn,
                          direction: Direction.horizontal,
                          offset: 0.5,
                          child: Chip(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            side: BorderSide(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 0),
                            avatar: const CircleAvatar(
                              radius: 3,
                              backgroundColor: Color(0xffd32760),
                            ),
                            label: const Text(
                              '434 col',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ShowUpAnimation(
                    delayStart: const Duration(milliseconds: 1000),
                    animationDuration: const Duration(milliseconds: 1000),
                    curve: Curves.bounceIn,
                    direction: Direction.horizontal,
                    offset: 0.5,
                    child: const Text(
                      'Per cent daily values are based on a 2,000 calories diet. Your daily values may be higher or lower depending on your calories needs.',
                      style: TextStyle(
                          color: Colors.grey, fontSize: 16, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShowUpAnimation(
                        delayStart: const Duration(milliseconds: 1200),
                        animationDuration: const Duration(milliseconds: 1200),
                        curve: Curves.bounceIn,
                        direction: Direction.horizontal,
                        offset: 0.5,
                        child: const Text(
                          r'$15.99',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      ShowUpAnimation(
                          delayStart: const Duration(milliseconds: 1400),
                          animationDuration: const Duration(milliseconds: 1400),
                          curve: Curves.bounceIn,
                          direction: Direction.horizontal,
                          offset: 0.5,
                          child: Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xffd32760),
                            ),
                            child: const Center(
                              child: Text(
                                'Add to cart',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
}

class BottomBars extends StatefulWidget {
  const BottomBars({super.key});

  @override
  State<BottomBars> createState() => _BottomBarsState();
}

class _BottomBarsState extends State<BottomBars> {
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        bottomNavigationBar: CircleNavBar(
          circleColor: const Color(0xffd32760),
          activeIcons: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/home.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/spoon.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/bookmark.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/user.png',
                color: Colors.white,
              ),
            ),
          ],
          inactiveIcons: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/home.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/spoon.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/bookmark.png',
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/user.png',
                color: Colors.white,
              ),
            ),
          ],
          color: const Color(0xff11171e),
          height: 60,
          circleWidth: 50,
          activeIndex: tabIndex,
          onTap: (index) {
            tabIndex = index;
            pageController.jumpToPage(tabIndex);
          },
          padding: const EdgeInsets.only(left: 8, right: 8),
          cornerRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          ),
          shadowColor: const Color(0xff05080d),
          elevation: 10,
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (v) {
            tabIndex = v;
          },
          children: const [
            FoodHomePage(),
            FoodHomePage(),
            FoodHomePage(),
            FoodHomePage(),
          ],
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<PageController>('pageController', pageController));
    properties.add(IntProperty('tabIndex', tabIndex));
  }
}
