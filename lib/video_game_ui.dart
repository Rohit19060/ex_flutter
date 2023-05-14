import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VideoGameUI extends StatefulWidget {
  const VideoGameUI({super.key});

  @override
  State<VideoGameUI> createState() => _VideoGameUIState();
}

class _VideoGameUIState extends State<VideoGameUI> {
  ScrollController _scrollController = ScrollController();
  double toolbarOpacity = 1.0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset <= 80) {
        toolbarOpacity = (80 - _scrollController.offset) / 80;
      } else {
        toolbarOpacity = 0;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFb06ab3),
                Color(0xFF4568dc),
              ],
              begin: Alignment(0.3, -1),
              end: Alignment(-0.8, 1),
            ),
          ),
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 80, bottom: 40),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GameWidget(hero: heroes[index]),
                ),
                itemCount: heroes.length,
              ),
              Opacity(
                opacity: toolbarOpacity,
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 18,
                        ),
                        Text(
                          'Games List',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('toolbarOpacity', toolbarOpacity));
  }
}

class DetailsScreen extends StatefulWidget {
  const DetailsScreen(this.hero, {super.key});
  final GameModel hero;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GameModel>('hero', hero));
  }
}

class _DetailsScreenState extends State<DetailsScreen> {
  final appBarHeight = 80.0;

  ScrollController _scrollController = ScrollController();

  double toolbarOpacity = 1.0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset <= appBarHeight) {
          toolbarOpacity =
              (appBarHeight - _scrollController.offset) / appBarHeight;
        } else {
          toolbarOpacity = 0;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFff512f),
                Color(0xFFdd2476),
              ],
              begin: Alignment(0.3, -1),
              end: Alignment(-0.8, 1),
            ),
          ),
          child: Stack(
            children: [
              ListView(
                controller: _scrollController,
                padding: EdgeInsets.only(top: appBarHeight),
                children: [
                  _HeroDetailInfo(widget.hero),
                  _HeroDetailsName(widget.hero.name),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
                    child: Text(
                      'Super smash bros ultimate villagers from the animal crossing series. This troops fight most effectively in large group',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 28,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: TextButton(
                            child: const Text(
                              'Add Favourite',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {},
                            child: Ink(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFF29758),
                                      Color(0xFFEF5D67),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 88.0, minHeight: 36.0),
                                // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 28),
                    ],
                  ),
                  const SizedBox(height: 28),
                ],
              ),
              SafeArea(
                child: Opacity(
                  opacity: toolbarOpacity,
                  child: Row(
                    children: [
                      const SizedBox(width: 18),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Text(
                        'Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Container(height: appBarHeight),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('toolbarOpacity', toolbarOpacity));
    properties.add(DoubleProperty('appBarHeight', appBarHeight));
  }
}

class _HeroDetailInfo extends StatelessWidget {
  const _HeroDetailInfo(this.hero);
  final GameModel hero;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 28.0, left: 28.0, right: 28.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(28)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(28)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(28)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Hero(
                        tag: hero.name,
                        child: Image.asset(
                          hero.image,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GameModel>('hero', hero));
  }
}

class _HeroDetailsName extends StatelessWidget {
  const _HeroDetailsName(this.heroName);
  final String heroName;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        height: 86,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                heroName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 42,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Text(
                  heroName,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.1),
                    fontWeight: FontWeight.bold,
                    fontSize: 56,
                  ),
                ),
              ),
            )
          ],
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('heroName', heroName));
  }
}

class GameModel {
  GameModel({
    required this.name,
    required this.image,
    required this.speed,
    required this.health,
    required this.attack,
  });
  final String name;
  final String image;
  final double speed, health, attack;
}

final List<GameModel> heroes = [
  GameModel(
    name: 'Bombardier',
    image: 'assets/images/player1.png',
    speed: 18.0,
    health: 60.0,
    attack: 80.0,
  ),
  GameModel(
    name: 'Cow Master',
    image: 'assets/images/player2.png',
    speed: 28.0,
    health: 55.0,
    attack: 70.0,
  ),
  GameModel(
    name: 'Bar Bar Green',
    image: 'assets/images/player3.png',
    speed: 30.0,
    health: 90.0,
    attack: 88.0,
  ),
];

// Degree / Radians converter
const double degrees2Radians = math.pi / 180.0;
const double radians2Degrees = 180.0 / math.pi;

double degrees(double radians) => radians * radians2Degrees;
double radians(double degrees) => degrees * degrees2Radians;

class GameWidget extends StatelessWidget {
  const GameWidget({
    super.key,
    required this.hero,
    this.rowHeight = 282,
  });
  final GameModel hero;
  final double rowHeight;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 18),
        child: SizedBox(
          height: rowHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: const Offset(-10, 0),
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.01)
                    ..rotateY(radians(1.5)),
                  child: Container(
                    height: 216,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(-44, 0),
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.01)
                    ..rotateY(radians(8)),
                  child: Container(
                    height: 188,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Transform.translate(
                    offset: const Offset(-30, 0),
                    child: Hero(
                      tag: hero.name,
                      child: Image.asset(
                        hero.image,
                        width: rowHeight,
                        height: rowHeight,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 58),
                  padding: const EdgeInsets.symmetric(vertical: 34),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SkillsWidget(
                        progress: hero.speed,
                        child: Image.asset(
                          speed,
                        ),
                      ),
                      SkillsWidget(
                        progress: hero.health,
                        child: Image.asset(
                          heart,
                        ),
                      ),
                      SkillsWidget(
                        progress: hero.attack,
                        child: Image.asset(
                          knife,
                        ),
                      ),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(hero),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                          ),
                          child: const Text(
                            'See Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('rowHeight', rowHeight));
    properties.add(DiagnosticsProperty<GameModel>('hero', hero));
  }
}

const String heart = 'assets/images/heart.png';
const String knife = 'assets/images/knife.png';
const String speed = 'assets/images/speed.png';

class SkillsWidget extends StatelessWidget {
  const SkillsWidget({
    super.key,
    required this.progress,
    this.size = 42,
    required this.child,
  });
  final double size;
  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: AttributePainter(
          progressPercent: progress,
        ),
        size: Size(size, size),
        child: Container(
          padding: EdgeInsets.all(size / 3.8),
          width: size,
          height: size,
          child: child,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('progress', progress));
    properties.add(DoubleProperty('size', size));
  }
}

class AttributePainter extends CustomPainter {
  AttributePainter({
    this.progressPercent = 4.0,
    this.strokeWidth = 2.0,
    this.filledStrokeWidth = 4.0,
  })  : bgPaint = Paint()..color = Colors.white.withOpacity(0.25),
        strokeBgPaint = Paint()..color = const Color(0xffD264C9),
        strokeFilledPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = filledStrokeWidth
          ..strokeCap = StrokeCap.round;
  final double progressPercent;
  final double strokeWidth, filledStrokeWidth;
  final Paint bgPaint, strokeBgPaint, strokeFilledPaint;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawCircle(center, radius - strokeWidth, strokeBgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
      -math.pi / 2, // - 45 degrees to start from top
      (progressPercent / 100) * math.pi * 2,
      false,
      strokeFilledPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
