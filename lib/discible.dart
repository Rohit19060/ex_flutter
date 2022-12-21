import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Despicable Me Characters',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          canvasColor: Colors.white,
          appBarTheme: const AppBarTheme(
            elevation: 0.0,
            color: Colors.white,
          ),
        ),
        home: const CharacterListingScreen(),
      );
}

class CharacterListingScreen extends StatefulWidget {
  const CharacterListingScreen({super.key});

  @override
  State<CharacterListingScreen> createState() => _CharacterListingScreenState();
}

class _CharacterListingScreenState extends State<CharacterListingScreen> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: currentPage,
      keepPage: false,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back_ios),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.search),
            ),
          ],
        ),
        body: SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, top: 8.0),
                    child: RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                            text: 'Despicable Me', style: AppTheme.display1),
                        TextSpan(text: '\n'),
                        TextSpan(text: 'Characters', style: AppTheme.display2),
                      ]),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      children: <Widget>[
                        for (var i = 0; i < characters.length; i++)
                          CharacterWidget(
                            character: characters[i],
                            pageController: _pageController,
                            currentPage: i,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('currentPage', currentPage));
  }
}

class CharacterDetailScreen extends StatefulWidget {
  const CharacterDetailScreen({super.key, required this.character});
  final double _expandedBottomSheetBottomPosition = 0;
  final double _collapsedBottomSheetBottomPosition = -250;
  final double _completeCollapsedBottomSheetBottomPosition = -330;
  final Character character;

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Character>('character', character));
  }
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen>
    with TickerProviderStateMixin<CharacterDetailScreen> {
  double _bottomSheetBottomPosition = -330;
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: 'background-${widget.character.name}',
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: widget.character.colors,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 40.0,
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 40.0,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  onPressed: () {
                    setState(() {
                      _bottomSheetBottomPosition =
                          widget._completeCollapsedBottomSheetBottomPosition;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Hero(
                    tag: 'image-${widget.character.name}',
                    child: Image.asset(
                      widget.character.imagePath,
                      height: screenHeight * 0.45,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 8.0,
                      ),
                      child: Hero(
                        tag: 'name-${widget.character.name}',
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            child: Text(
                              widget.character.name,
                              style: AppTheme.heading,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0.0, 8.0, 32.0),
                      child: Text(
                        widget.character.description,
                        style: AppTheme.subHeading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate,
            bottom: _bottomSheetBottomPosition,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: _onTap,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      height: 80,
                      child: Text(
                        'Clips',
                        style:
                            AppTheme.subHeading.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _clipsWidget(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onTap() {
    setState(() {
      _bottomSheetBottomPosition = isCollapsed
          ? widget._expandedBottomSheetBottomPosition
          : widget._collapsedBottomSheetBottomPosition;
      isCollapsed = !isCollapsed;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isCollapsed = true;
        _bottomSheetBottomPosition = widget._collapsedBottomSheetBottomPosition;
      });
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isCollapsed', isCollapsed));
  }
}

Widget _clipsWidget() => Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              roundedContainer(Colors.redAccent),
              const SizedBox(height: 20),
              roundedContainer(Colors.greenAccent),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            children: <Widget>[
              roundedContainer(Colors.orangeAccent),
              const SizedBox(height: 20),
              roundedContainer(Colors.purple),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            children: <Widget>[
              roundedContainer(Colors.grey),
              const SizedBox(height: 20),
              roundedContainer(Colors.blueGrey),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            children: <Widget>[
              roundedContainer(Colors.lightGreenAccent),
              const SizedBox(height: 20),
              roundedContainer(Colors.pinkAccent),
            ],
          ),
        ],
      ),
    );

Widget roundedContainer(Color color) => Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
    );

class Character {
  const Character({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.colors,
  });
  final String name;
  final String imagePath;
  final String description;
  final List<Color> colors;
}

const List<Character> characters = <Character>[
  Character(
      name: 'Kevin',
      imagePath: 'assets/images/Kevin_minions.png',
      description:
          'Sir Kevin KBE (formerly known as Kevin) is one of the Minions and the protagonist in the film Minions. Kevin is a tall, two-eyed minion with sprout cut hair and is usually seen wearing his golf apparel. Kevin loves to make fun of and tease people or Minions, shown when he made fun of Jerry and teases him for being a coward. He loves playing golf and cricket. In the film Minions he is the leader of the trio in search of a new master. He truly cares about the well-being of the Minion tribe (which is dependent on them having a proper master).',
      colors: [
        Color.fromARGB(255, 255, 204, 128),
        Color.fromARGB(255, 255, 112, 67)
      ]),
  Character(
      name: 'Agnes',
      imagePath: 'assets/images/Agnes_gru.png',
      description:
          "Agnes Gru it is one of Gru and Lucy's three adopted daughters, alongside her sisters Margo and Edith. She is the youngest child of the three sisters. She greatly adores unicorns, as shown on various occasions. Agnes is a little girl with dark brown eyes. Her long black hair is tied in an upwards ponytail with a red scrunchie. Most of the time, Agnes wears blue overalls over a yellow and brown striped t-shirt, and white sneakers with yellow socks. She also wears a white ballet outfit like Edith and Margo (at the ballet recital). For pajamas, Agnes wears a long blue nightshirt covered with teddy bears and polar bear slippers; her hair stays the same. On her birthday, Agnes is wearing a dress that resembles a princess riding a unicorn. The colors are similar to her regular outfit. She also wears a blue princess hat on her head.",
      colors: [
        Color.fromARGB(255, 244, 143, 177),
        Color.fromARGB(255, 255, 23, 68)
      ]),
];

class AppTheme {
  static const TextStyle display1 = TextStyle(
    fontFamily: 'WorkSans',
    color: Colors.black,
    fontSize: 38,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static const TextStyle display2 = TextStyle(
    fontFamily: 'WorkSans',
    color: Colors.black,
    fontSize: 32,
    fontWeight: FontWeight.normal,
    letterSpacing: 1.1,
  );

  static final TextStyle heading = TextStyle(
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w900,
    fontSize: 34,
    color: Colors.white.withOpacity(0.8),
    letterSpacing: 1.2,
  );

  static final TextStyle subHeading = TextStyle(
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: Colors.white.withOpacity(0.8),
  );
}

class CharacterWidget extends StatelessWidget {
  const CharacterWidget(
      {required this.character,
      required this.pageController,
      required this.currentPage});
  final Character character;

  final PageController pageController;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (context, _, __) => CharacterDetailScreen(
              character: character,
            ),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: pageController,
        builder: (context, child) {
          var value = 1.0;
          if (pageController.position.haveDimensions) {
            value = pageController.page! - currentPage;
            value = (1 - (value.abs() * 0.6)).clamp(0.0, 1.0);
            if (currentPage == 1) print('value $value');
          }

          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: CharacterCardBackgroundClipper(),
                  child: Hero(
                    tag: 'background-${character.name}',
                    child: Container(
                      height: screenHeight * 0.55,
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: character.colors,
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.5),
                child: Hero(
                  tag: 'image-${character.name}',
                  child: Image.asset(
                    character.imagePath,
                    height: screenHeight * 0.55 * value,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 48.0, right: 16.0, bottom: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: 'name-${character.name}',
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          child: Text(
                            character.name,
                            style: AppTheme.heading,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Tap to Read more',
                      style: AppTheme.subHeading,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('currentPage', currentPage));
    properties.add(
        DiagnosticsProperty<PageController>('pageController', pageController));
    properties.add(DiagnosticsProperty<Character>('character', character));
  }
}

class CharacterCardBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final clippedPath = Path();

    const curveDistance = 40.0;

    clippedPath.moveTo(0, size.height * 0.4);
    clippedPath.lineTo(0, size.height - curveDistance);
    clippedPath.quadraticBezierTo(
        1, size.height - 1, 0 + curveDistance, size.height);
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width + 1, size.height - 1, size.width,
        size.height - curveDistance);
    clippedPath.lineTo(size.width, 0 + curveDistance);
    clippedPath.quadraticBezierTo(size.width - 1, 0,
        size.width - curveDistance - 5, 0 + curveDistance / 3);
    clippedPath.lineTo(curveDistance, size.height * 0.29);
    clippedPath.quadraticBezierTo(
        1, (size.height * 0.30) + 10, 0, size.height * 0.4);
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
