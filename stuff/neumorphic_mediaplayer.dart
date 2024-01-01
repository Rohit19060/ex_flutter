import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const NeumorphicMediaPlayer());

// class NeumorphicMediaPlayer extends StatelessWidget {
//   const NeumorphicMediaPlayer({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.grey.shade300,
//         body: Center(
//           child: Container(
//             child: const FlutterLogo(size: 180),
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               // shape: BoxShape.circle,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade500,
//                   blurRadius: 15,
//                   spreadRadius: 1,
//                   offset: const Offset(4, 4),
//                 ),
//                 const BoxShadow(
//                   color: Colors.white,
//                   blurRadius: 15,
//                   spreadRadius: 1,
//                   offset: Offset(-4, -4),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Dart Mode

// class NeumorphicMediaPlayer extends StatelessWidget {
//   const NeumorphicMediaPlayer({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.grey.shade900,
//         body: Center(
//           child: Container(
//             child: const FlutterLogo(size: 180),
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade900,
//               // shape: BoxShape.circle,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 const BoxShadow(
//                   color: Colors.black,
//                   blurRadius: 10,
//                   spreadRadius: 1,
//                   offset: Offset(4, 4),
//                 ),
//                 BoxShadow(
//                   color: Colors.grey.shade800,
//                   blurRadius: 10,
//                   spreadRadius: 1,
//                   offset: const Offset(-4, -4),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Gradient Feel design

// class NeumorphicMediaPlayer extends StatelessWidget {
//   const NeumorphicMediaPlayer({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.blue.shade300,
//         body: Center(
//             child: Container(
//           height: 180,
//           width: 180,
//           decoration: BoxDecoration(
//             color: Colors.blue.shade300,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.blue.shade700,
//                 blurRadius: 15,
//                 spreadRadius: 1,
//                 offset: const Offset(4, 4),
//               ),
//               BoxShadow(
//                 color: Colors.blue.shade200,
//                 blurRadius: 15,
//                 spreadRadius: 1,
//                 offset: const Offset(-4, -4),
//               ),
//             ],
//             gradient: LinearGradient(
//               colors: [
//                 Colors.blue.shade200,
//                 Colors.blue.shade400,
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               stops: const [0.1, 0.9],
//             ),
//           ),
//         )),
//       ),
//     );
//   }
// }

class NeumorphicMediaPlayer extends StatefulWidget {
  const NeumorphicMediaPlayer({super.key});

  @override
  State<NeumorphicMediaPlayer> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NeumorphicMediaPlayer> {
  IconData icons1 = Icons.home;
  IconData icons2 = Icons.settings;
  IconData icons3 = Icons.favorite;
  IconData icons4 = Icons.message;

  bool buttonPressed1 = false;
  bool buttonPressed2 = false;
  bool buttonPressed3 = false;
  bool buttonPressed4 = false;

  void _letsPress1() {
    setState(() {
      buttonPressed1 = true;
      buttonPressed2 = false;
      buttonPressed3 = false;
      buttonPressed4 = false;
    });
  }

  void _letsPress2() {
    setState(() {
      buttonPressed1 = false;
      buttonPressed2 = true;
      buttonPressed3 = false;
      buttonPressed4 = false;
    });
  }

  void _letsPress3() {
    setState(() {
      buttonPressed1 = false;
      buttonPressed2 = false;
      buttonPressed3 = true;
      buttonPressed4 = false;
    });
  }

  void _letsPress4() {
    setState(() {
      buttonPressed1 = false;
      buttonPressed2 = false;
      buttonPressed3 = false;
      buttonPressed4 = true;
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.grey.shade300,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: _letsPress1,
                          child: buttonPressed1
                              ? ButtonTapped(icon: icons1)
                              : MyButton(icon: icons1),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _letsPress2,
                          child: buttonPressed2
                              ? ButtonTapped(icon: icons2)
                              : MyButton(icon: icons2),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _letsPress3,
                          child: buttonPressed3
                              ? ButtonTapped(icon: icons3)
                              : MyButton(icon: icons3),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _letsPress4,
                          child: buttonPressed4
                              ? ButtonTapped(icon: icons4)
                              : MyButton(icon: icons4),
                        ),
                      ),
                    ],
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
    properties.add(DiagnosticsProperty<bool>('buttonPressed4', buttonPressed4));
    properties.add(DiagnosticsProperty<bool>('buttonPressed3', buttonPressed3));
    properties.add(DiagnosticsProperty<bool>('buttonPressed2', buttonPressed2));
    properties.add(DiagnosticsProperty<bool>('buttonPressed1', buttonPressed1));
    properties.add(DiagnosticsProperty<IconData>('icons4', icons4));
    properties.add(DiagnosticsProperty<IconData>('icons3', icons3));
    properties.add(DiagnosticsProperty<IconData>('icons2', icons2));
    properties.add(DiagnosticsProperty<IconData>('icons1', icons1));
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade600,
                    offset: const Offset(4.0, 4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
                const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
              ],
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade200,
                    Colors.grey.shade300,
                    Colors.grey.shade400,
                    Colors.grey.shade500,
                  ],
                  stops: const [
                    0.1,
                    0.3,
                    0.8,
                    1
                  ])),
          child: Icon(
            icon,
            size: 37,
            color: Colors.grey[800],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
  }
}

class ButtonTapped extends StatelessWidget {
  const ButtonTapped({super.key, required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(4),
        child: DecoratedBox(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade600,
                    offset: const Offset(4.0, 4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
                const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
              ],
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade200,
                    Colors.grey.shade300,
                    Colors.grey.shade400,
                    Colors.grey.shade500,
                  ],
                  stops: const [
                    0.1,
                    0.3,
                    0.8,
                    1
                  ])),
          child: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
                boxShadow: [
                  const BoxShadow(
                      color: Colors.white,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0),
                  BoxShadow(
                      color: Colors.grey.shade600,
                      offset: const Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0),
                ],
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade700,
                      Colors.grey.shade600,
                      Colors.grey.shade500,
                      Colors.grey.shade200,
                    ],
                    stops: const [
                      0,
                      0.1,
                      0.3,
                      1
                    ])),
            child: Icon(
              icon,
              size: 35,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
  }
}
