import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class DynamicIsland extends StatefulWidget {
  const DynamicIsland({super.key});

  @override
  State<DynamicIsland> createState() => _DynamicIslandState();
}

class _DynamicIslandState extends State<DynamicIsland> {
  int activePageIndex = 0;
  bool collapsed = true;
  bool showViews = true;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  void setActivePageIndex(int i) => setState(() => activePageIndex = i);

  void toggleViews() {
    showViews = false;
    collapsed = !collapsed;
    setState(() {});
  }

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    final activeViews = views[activePageIndex];
    final viewsToShow =
        collapsed ? activeViews.collapsedViews : activeViews.expandedViews;
    return Scaffold(
      body: AnnotatedRegion(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => setState(() {
                if (!collapsed) {
                  toggleViews();
                }
              }),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFF512F),
                        Color(0xFFDD2476),
                      ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: PageView(
                    controller: controller,
                    onPageChanged: setActivePageIndex,
                    children: <Widget>[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Music',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            SizedBox(
                              height: 150,
                              width: 100,
                              child: Lottie.network(
                                  'https://assets1.lottiefiles.com/packages/lf20_6K4Hjs.json'),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Calls',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            SizedBox(
                              height: 150,
                              width: 100,
                              child: Lottie.network(
                                  'https://assets9.lottiefiles.com/datafiles/q7kPYy3BPNV4s7r/data.json'),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Location',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            SizedBox(
                              height: 150,
                              width: 100,
                              child: Lottie.network(
                                  'https://assets2.lottiefiles.com/packages/lf20_UgZWvP.json'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: toggleViews,
                child: AnimatedContainer(
                  onEnd: () => setState(() => showViews = true),
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(
                        collapsed ? 20.0 : activeViews.expandedBorderRadius),
                  ),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  height: collapsed ? 40 : activeViews.expandedHeight,
                  width: MediaQuery.of(context).size.width *
                      (collapsed ? 0.5 : 0.95),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: collapsed ? 10.0 : 15.0, vertical: 5),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: showViews ? viewsToShow : const SizedBox(),
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<PageController>('controller', controller));
    properties.add(DiagnosticsProperty<bool>('showViews', showViews));
    properties.add(DiagnosticsProperty<bool>('collapsed', collapsed));
    properties.add(IntProperty('activePageIndex', activePageIndex));
  }
}

class CallCollapsed extends StatelessWidget {
  const CallCollapsed({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Row(
            children: const [
              Icon(
                CupertinoIcons.phone_fill,
                color: Colors.greenAccent,
                size: 16,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '23:14',
                style: TextStyle(color: Colors.greenAccent),
              )
            ],
          ),
          const Spacer(),
          Image.asset(
            'assets/images/waves.png',
            fit: BoxFit.contain,
            width: 70,
          )
        ],
      );
}

class CallExpanded extends StatelessWidget {
  const CallExpanded({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          FittedBox(
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  radius: 24,
                ),
                const SizedBox(width: 10.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'iPhone',
                      style: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
                    const Text('King',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                )
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 22,
                child: Icon(
                  CupertinoIcons.phone_down_fill,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 22,
                child: Icon(
                  CupertinoIcons.phone_fill,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      );
}

class LocationCollapsed extends StatelessWidget {
  const LocationCollapsed({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(
            CupertinoIcons.arrow_turn_up_right,
            size: 20,
            color: Color(0xFF83CBFB),
          ),
          const Spacer(),
          Row(
            children: [
              const Text('0.9', style: TextStyle(color: Color(0xFF83CBFB))),
              Transform.translate(
                  offset: const Offset(0, -1),
                  child: const Text('M',
                      style: TextStyle(color: Color(0xFF83CBFB), fontSize: 8))),
            ],
          )
        ],
      );
}

class LocationExpanded extends StatelessWidget {
  const LocationExpanded({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                child: Icon(
                  CupertinoIcons.arrow_turn_up_left,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
              Expanded(
                child: Icon(
                  CupertinoIcons.arrow_up,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
              Expanded(
                child: Icon(
                  CupertinoIcons.arrow_up,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
              Expanded(
                child: Icon(
                  CupertinoIcons.arrow_turn_up_right,
                  color: Colors.white,
                  size: 30,
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '120 m',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'East',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Bangalore',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          )
        ],
      );
}

class MusicCollapsed extends StatelessWidget {
  const MusicCollapsed({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              'assets/images/thunder.png',
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/waves.png',
            fit: BoxFit.contain,
            width: 70,
          )
        ],
      );
}

class MusicExpanded extends StatelessWidget {
  const MusicExpanded({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/thunder.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('THUNDER', style: TextStyle(color: Colors.white)),
                  Text(
                    'Imagine Dragon',
                    style: TextStyle(
                        color: Colors.grey.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/waves.png',
                    fit: BoxFit.contain,
                    width: 70,
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                '1:40',
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: 10),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.25,
                    backgroundColor: Colors.grey,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                '-2:35',
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: 10),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      CupertinoIcons.backward_end_alt_fill,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      CupertinoIcons.forward_end_alt_fill,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(
                      CupertinoIcons.antenna_radiowaves_left_right,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      );
}

class Views {
  Views({
    required this.collapsedViews,
    required this.expandedViews,
    this.expandedHeight = 200,
    this.expandedBorderRadius = 20.0,
  });
  final Widget collapsedViews;
  final Widget expandedViews;
  double expandedHeight;
  double expandedBorderRadius;
}

final List<Views> views = [
  Views(
    collapsedViews: const MusicCollapsed(),
    expandedViews: const MusicExpanded(),
    expandedHeight: 180,
    expandedBorderRadius: 40,
  ),
  Views(
    collapsedViews: const CallCollapsed(),
    expandedViews: const CallExpanded(),
    expandedHeight: 80,
    expandedBorderRadius: 40,
  ),
  Views(
    collapsedViews: const LocationCollapsed(),
    expandedViews: const LocationExpanded(),
    expandedHeight: 180,
    expandedBorderRadius: 40,
  )
];
