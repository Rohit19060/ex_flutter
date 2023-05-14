import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Neumorphic Fitness App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
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
  Widget build(BuildContext context) =>
      Scaffold(backgroundColor: boxColor, body: const Body());
}

Color textColor = const Color(0xff3E67D6);
Color boxColor = const Color.fromARGB(255, 239, 243, 255);

final kboxShadow = [
  const BoxShadow(
      color: Colors.white, offset: Offset(-10, -10), blurRadius: 10),
  BoxShadow(
      color: Colors.black.withOpacity(.15),
      offset: const Offset(4, 4),
      blurRadius: 15)
];

final kIShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(.15),
    spreadRadius: 2,
    offset: const Offset(-1, 1),
  ),
  BoxShadow(
      color: Colors.white.withOpacity(.7),
      spreadRadius: 2,
      offset: const Offset(1, -1)),
  BoxShadow(
      color: Colors.black.withOpacity(.15),
      spreadRadius: 2,
      offset: const Offset(-1, -1)),
  BoxShadow(
      color: Colors.white.withOpacity(.7),
      spreadRadius: 2,
      offset: const Offset(1, 1)),
];

class DailyActivity {
  DailyActivity({required this.day, required this.date});
  final String day, date;
}

class Navigation {
  Navigation({required this.icon, required this.title});
  final String icon, title;
}

List<Navigation> navigation = [
  Navigation(title: 'Home', icon: 'assets/images/Group 2361.png'),
  Navigation(
      title: 'Activity', icon: 'assets/images/Icon feather-activity.png'),
  Navigation(
      title: 'Settings', icon: 'assets/images/Icon feather-settings.png'),
  Navigation(title: 'Profile', icon: 'assets/images/Icon feather-user.png'),
];

List<DailyActivity> daily = [
  DailyActivity(day: 'MON', date: '8'),
  DailyActivity(day: 'SUN', date: '7'),
  DailyActivity(day: 'SAT', date: '6'),
  DailyActivity(day: 'FRI', date: '5'),
  DailyActivity(day: 'THU', date: '4'),
  DailyActivity(day: 'WED', date: '3'),
  DailyActivity(day: 'TUE', date: '2'),
  DailyActivity(day: 'MON', date: '1'),
];

class TodayActivity {
  TodayActivity({required this.icon, required this.count, required this.title});
  final String icon, title, count;
}

List<TodayActivity> today = [
  TodayActivity(
      icon: 'assets/images/trail-running-shoe (1).png',
      title: 'Steps',
      count: '1,254'),
  TodayActivity(
      icon: 'assets/images/weight.png', title: 'Calories', count: '826'),
  TodayActivity(
      icon: 'assets/images/cardiogram (1).png', title: 'BPM', count: '88.0'),
];

class Activity {
  Activity({required this.icon, required this.title});
  final String icon, title;
}

List<Activity> item = [
  Activity(icon: 'assets/images/trail-running-shoe (1).png', title: 'Walking'),
  Activity(icon: 'assets/images/treadmill (1).png', title: 'Tradmill'),
  Activity(icon: 'assets/images/running (2).png', title: 'Running'),
  Activity(icon: 'assets/images/bike (2).png', title: 'Cycling'),
  Activity(icon: 'assets/images/gym.png', title: 'Gym'),
  Activity(icon: 'assets/images/Path 1711.png', title: 'Yoge'),
];

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello Almamun',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff869CEE)),
                      ),
                      Row(
                        children: [
                          Text(
                            'Find A ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Workout',
                            style: TextStyle(
                              color: Color(0xff4F59DC),
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Icon(Icons.search)
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 190,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(130),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/Group 1.png',
                    height: 220,
                  ),
                  Positioned(
                    top: 30,
                    right: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'Legs ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'and ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            const Row(
                              children: [
                                Text(
                                  'Glutes ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'workout ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/Group 2359.png',
                                    height: 10,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Advanced',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/stopwatch.png',
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    '45 min',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: InkWell(
                                onTap: () => Navigator.push<Page>(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Page())),
                                child: Container(
                                  height: 35,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.15),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Center(
                                    child: Text(
                                      'Start Workout',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Container(
                height: 128.4,
                color: boxColor,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's Activity",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              'Details',
                              style: TextStyle(color: textColor),
                            ),
                            const Icon(Icons.arrow_forward)
                          ],
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            today.length, (index) => TodayAC(index: index)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                height: 135,
                color: boxColor,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Activity',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Details',
                              style: TextStyle(color: textColor),
                            ),
                            const Icon(Icons.arrow_forward)
                          ],
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          daily.length,
                          (index) => DailyAC(index: index),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 84,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(navigation.length, nav),
              ),
            )
          ],
        ),
      );

  Widget nav(int index) => InkWell(
        onTap: () => setState(() => selectedIndex = index),
        child: Container(
          height: 66,
          width: 66,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: kboxShadow,
          ),
          child: selectedIndex == index
              ? Container(
                  height: 59,
                  width: 59,
                  decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: kIShadow),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        navigation[index].icon,
                        height: 22,
                        color: textColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        navigation[index].title,
                        style: TextStyle(color: textColor),
                      )
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      navigation[index].icon,
                      height: 22,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      navigation[index].title,
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('selectedIndex', selectedIndex));
  }
}

class TodayAC extends StatelessWidget {
  const TodayAC({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.2),
        child: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Container(
            height: 80,
            width: 140,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: boxColor,
                boxShadow: kboxShadow),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      today[index].icon,
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      today[index].title,
                      style: const TextStyle(letterSpacing: 2),
                    )
                  ],
                ),
                Text(
                  today[index].count,
                  style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                )
              ],
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
  }
}

class DailyAC extends StatelessWidget {
  const DailyAC({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.2),
        child: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Container(
            height: 80,
            width: 66,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: boxColor,
                boxShadow: kboxShadow),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  daily[index].day,
                  style: const TextStyle(
                      letterSpacing: 0, fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 5),
                Text(
                  daily[index].date,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                )
              ],
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: boxColor,
        appBar: AppBar(
          backgroundColor: boxColor,
          elevation: 0,
          title: const Row(
            children: [
              Text(
                'Start ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Activity',
                style: TextStyle(
                    color: Color(0xff5868E0),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          titleSpacing: 85,
          leading: InkWell(
            onTap: () => Navigator.pop(context,
                MaterialPageRoute<Page>(builder: (context) => const Page())),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Image.asset(
                'assets/images/Group 2359 - Copy.png',
                width: 40,
              ),
            ),
          ),
        ),
        body: const PageBody(),
      );
}

class PageBody extends StatefulWidget {
  const PageBody({super.key});

  @override
  State<PageBody> createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            ColoredBox(
              color: boxColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 6.8,
                      children: List.generate(
                          item.length, (index) => ItemList(index: index)),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                height: 84,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(navigation.length, nav),
                ),
              ),
            )
          ],
        ),
      );

  Widget nav(int index) => InkWell(
        onTap: () => setState(() => selectedIndex = index),
        child: Container(
          height: 66,
          width: 66,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: kboxShadow,
          ),
          child: selectedIndex == index
              ? Container(
                  height: 59,
                  width: 59,
                  decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: kIShadow),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        navigation[index].icon,
                        height: 22,
                        color: textColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        navigation[index].title,
                        style: TextStyle(color: textColor),
                      )
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      navigation[index].icon,
                      height: 22,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      navigation[index].title,
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('selectedIndex', selectedIndex));
  }
}

class ItemList extends StatelessWidget {
  const ItemList({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: boxColor,
            boxShadow: kboxShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(item[index].icon, height: 30),
              const SizedBox(height: 20),
              Text(item[index].title, style: TextStyle(color: textColor))
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
  }
}
