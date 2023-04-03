import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomBars extends StatefulWidget {
  const BottomBars({super.key});

  @override
  State<BottomBars> createState() => _BottomBarsState();
}

class _BottomBarsState extends State<BottomBars> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        appBar: AppBar(title: const Text('Bottom Bars')),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 90,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentIndex == 0)
                          const IconButton(
                            icon: Icons.home_rounded,
                            text: 'Home',
                          )
                        else
                          BottomBarItem(
                            icon: Icons.home_rounded,
                            text: 'Home',
                            onTap: () => setState(() => _currentIndex = 0),
                          ),
                        if (_currentIndex == 1)
                          const IconButton(
                            icon: Icons.star_rounded,
                            text: 'My Matches',
                          )
                        else
                          BottomBarItem(
                            icon: Icons.star_rounded,
                            onTap: () => setState(() => _currentIndex = 1),
                            text: 'My Matches',
                          ),
                        if (_currentIndex == 2)
                          const IconButton(
                            icon: Icons.military_tech_rounded,
                            text: 'Winners',
                          )
                        else
                          BottomBarItem(
                            icon: Icons.military_tech_rounded,
                            text: 'Winners',
                            onTap: () => setState(() => _currentIndex = 2),
                          ),
                        if (_currentIndex == 3)
                          const IconButton(
                            icon: Icons.message_rounded,
                            text: 'Chat',
                          )
                        else
                          BottomBarItem(
                            icon: Icons.message_rounded,
                            text: 'Chat',
                            onTap: () => setState(() => _currentIndex = 3),
                          )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
}

class IconButton extends StatelessWidget {
  const IconButton({
    super.key,
    required this.icon,
    required this.text,
  });
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size.width / 4.2,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 5),
              )
            ],
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        Text(
          text.replaceAll(' ', '\u00a0'),
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.brown),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(StringProperty('text', text));
  }
}

class BottomBarItem extends StatelessWidget {
  const BottomBarItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });
  final String text;
  final VoidCallback? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 4.2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.grey,
                size: 25,
              ),
              Text(
                text.replaceAll(' ', '\u00a0'),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(StringProperty('text', text));
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
  }
}
