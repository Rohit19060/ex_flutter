import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Color mC = Colors.grey.shade100;
Color mCL = Colors.white;
Color mCD = Colors.black.withOpacity(0.075);
Color mCC = Colors.green.withOpacity(0.65);
Color fCL = Colors.grey.shade600;

BoxDecoration nMbox =
    BoxDecoration(shape: BoxShape.circle, color: mC, boxShadow: [
  BoxShadow(
    color: mCD,
    offset: const Offset(10, 10),
    blurRadius: 10,
  ),
  BoxShadow(
    color: mCL,
    offset: const Offset(-10, -10),
    blurRadius: 10,
  ),
]);

BoxDecoration nMboxInvert = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: mCD,
    boxShadow: [
      BoxShadow(
          color: mCL,
          offset: const Offset(3, 3),
          blurRadius: 3,
          spreadRadius: -3),
    ]);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: MainCard());
}

class MainCard extends StatelessWidget {
  const MainCard({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: mC,
        body: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NMButton(icon: Icons.arrow_back),
                      NMButton(icon: Icons.menu),
                    ],
                  ),
                  AvatarImage(),
                  SizedBox(height: 15),
                  Text(
                    'Steven Dz',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Amsterdam',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Mobile App Developer and Game Designer',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NMButton(icon: FontAwesomeIcons.facebookF),
                      SizedBox(width: 25),
                      NMButton(icon: FontAwesomeIcons.twitter),
                      SizedBox(width: 25),
                      NMButton(icon: FontAwesomeIcons.instagram),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      SocialBox(
                          icon: FontAwesomeIcons.dribbble,
                          count: '35',
                          category: 'shots'),
                      SizedBox(width: 15),
                      SocialBox(
                          icon: FontAwesomeIcons.userLarge,
                          count: '1.2k',
                          category: 'followers'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SocialBox(
                          icon: FontAwesomeIcons.heart,
                          count: '5.1k',
                          category: 'likes'),
                      SizedBox(width: 15),
                      SocialBox(
                          icon: FontAwesomeIcons.user,
                          count: '485',
                          category: 'following'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SocialBox(
                          icon: FontAwesomeIcons.whiskeyGlass,
                          count: '97',
                          category: 'buckets'),
                      SizedBox(width: 15),
                      SocialBox(
                          icon: FontAwesomeIcons.folderOpen,
                          count: '7',
                          category: 'projects'),
                    ],
                  ),
                  SizedBox(height: 35),
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.07,
              minChildSize: 0.07,
              maxChildSize: 0.4,
              builder: (context, scroll) => DecoratedBox(
                decoration: nMbox,
                child: ListView(
                  controller: scroll,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Icon(Icons.share, color: fCL),
                          ),
                          const Text(
                            'Share',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            width: 225,
                            padding: const EdgeInsets.all(10),
                            decoration: nMboxInvert,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(FontAwesomeIcons.facebookF, color: fCL),
                                Icon(FontAwesomeIcons.twitter, color: fCL),
                                Icon(FontAwesomeIcons.instagram, color: fCL),
                                Icon(FontAwesomeIcons.whatsapp, color: fCL),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          FaIcon(
                            FontAwesomeIcons.copy,
                            color: Colors.pink.shade800,
                          ),
                          const Text('Copy link'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
}

class SocialBox extends StatelessWidget {
  const SocialBox(
      {super.key,
      required this.icon,
      required this.count,
      required this.category});
  final IconData icon;
  final String count;
  final String category;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: nMboxInvert,
          child: Row(
            children: [
              FaIcon(icon, color: Colors.pink.shade800, size: 20),
              const SizedBox(width: 8),
              Text(
                count,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 3),
              Text(
                category,
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('category', category));
    properties.add(StringProperty('count', count));
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
  }
}

class NMButton extends StatelessWidget {
  const NMButton({super.key, required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
        width: 55,
        height: 55,
        decoration: nMbox,
        child: Icon(icon, color: fCL),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
  }
}

class AvatarImage extends StatelessWidget {
  const AvatarImage({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(8),
        decoration: nMbox,
        child: Container(
          decoration: nMbox,
          padding: const EdgeInsets.all(3),
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/avatar.jpg'),
              ),
            ),
          ),
        ),
      );
}
