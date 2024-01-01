import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const Color colorDark = Color(0xFF374352);
const Color colorLight = Color(0xFFe6eeff);

class CalculatorNeuApp extends StatefulWidget {
  const CalculatorNeuApp({super.key});

  @override
  State<CalculatorNeuApp> createState() => _CalculatorNeuAppState();
}

class _CalculatorNeuAppState extends State<CalculatorNeuApp> {
  bool darkMode = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: darkMode ? colorDark : colorLight,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () => setState(() => darkMode = !darkMode),
                        child: SwitchMode(darkMode: darkMode)),
                    const SizedBox(height: 80),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '6.010',
                        style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          color: darkMode ? Colors.white : Colors.red,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '=',
                          style: TextStyle(
                              fontSize: 35,
                              color: darkMode ? Colors.green : Colors.grey),
                        ),
                        Text(
                          '10+500*12',
                          style: TextStyle(
                              fontSize: 20,
                              color: darkMode ? Colors.green : Colors.grey),
                        )
                      ],
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
                Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      OvalButton(title: 'sin', darkMode: darkMode),
                      OvalButton(title: 'cos', darkMode: darkMode),
                      OvalButton(title: 'tan', darkMode: darkMode),
                      OvalButton(title: '%', darkMode: darkMode),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RoundedButton(
                        title: 'C',
                        darkMode: darkMode,
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                      ),
                      RoundedButton(title: '(', darkMode: darkMode),
                      RoundedButton(title: ')', darkMode: darkMode),
                      RoundedButton(
                        title: '/',
                        darkMode: darkMode,
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RoundedButton(title: '7', darkMode: darkMode),
                      RoundedButton(title: '8', darkMode: darkMode),
                      RoundedButton(title: '9', darkMode: darkMode),
                      RoundedButton(
                        title: 'x',
                        darkMode: darkMode,
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RoundedButton(title: '4', darkMode: darkMode),
                      RoundedButton(title: '5', darkMode: darkMode),
                      RoundedButton(title: '6', darkMode: darkMode),
                      RoundedButton(
                        title: '-',
                        darkMode: darkMode,
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RoundedButton(title: '1', darkMode: darkMode),
                      RoundedButton(title: '2', darkMode: darkMode),
                      RoundedButton(title: '3', darkMode: darkMode),
                      RoundedButton(
                        title: '+',
                        darkMode: darkMode,
                        textColor: darkMode ? Colors.green : Colors.redAccent,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RoundedButton(title: '0', darkMode: darkMode),
                      RoundedButton(title: ',', darkMode: darkMode),
                      RoundedButton(
                        icon: Icons.backspace_outlined,
                        darkMode: darkMode,
                        iconColor: darkMode ? Colors.green : Colors.redAccent,
                      ),
                      RoundedButton(
                        title: '=',
                        darkMode: darkMode,
                        iconColor: darkMode ? Colors.green : Colors.redAccent,
                      ),
                    ],
                  )
                ]),
              ],
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('darkMode', darkMode));
  }
}

class NeuContainer extends StatefulWidget {
  const NeuContainer({
    super.key,
    this.darkMode = false,
    required this.child,
    required this.borderRadius,
    required this.padding,
  });
  final bool darkMode;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  State<NeuContainer> createState() => _NeuContainerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties
        .add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<bool>('darkMode', darkMode));
  }
}

class _NeuContainerState extends State<NeuContainer> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = widget.darkMode;
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: darkMode ? colorDark : colorLight,
          borderRadius: widget.borderRadius,
          boxShadow: _isPressed
              ? null
              : <BoxShadow>[
                  BoxShadow(
                      color:
                          darkMode ? Colors.black54 : Colors.blueGrey.shade200,
                      offset: const Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0),
                  BoxShadow(
                    color: darkMode ? Colors.blueGrey.shade700 : Colors.white,
                    offset: const Offset(-4.0, -4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0,
                  )
                ],
        ),
        child: widget.child,
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.darkMode,
    this.title,
    this.padding = 18,
    this.icon = Icons.ac_unit,
    this.iconColor = Colors.white,
    this.textColor = Colors.black,
  });
  final String? title;
  final bool darkMode;
  final double padding;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: NeuContainer(
          darkMode: darkMode,
          borderRadius: BorderRadius.circular(40),
          padding: EdgeInsets.all(padding),
          child: SizedBox(
            width: padding * 2,
            height: padding * 2,
            child: Center(
              child: title != null
                  ? Text(
                      title ?? '',
                      style: TextStyle(color: textColor, fontSize: 30),
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                      size: 30,
                    ),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('textColor', textColor));
    properties.add(ColorProperty('iconColor', iconColor));
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(DoubleProperty('padding', padding));
    properties.add(DiagnosticsProperty<bool>('darkMode', darkMode));
    properties.add(StringProperty('title', title));
  }
}

class SwitchMode extends StatelessWidget {
  const SwitchMode({super.key, required this.darkMode});
  final bool darkMode;

  @override
  Widget build(BuildContext context) => NeuContainer(
        darkMode: darkMode,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        borderRadius: BorderRadius.circular(40),
        child: SizedBox(
          width: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.wb_sunny,
                color: darkMode ? Colors.grey : Colors.redAccent,
              ),
              Icon(
                Icons.nightlight_round,
                color: darkMode ? Colors.green : Colors.grey,
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('darkMode', darkMode));
  }
}

class OvalButton extends StatelessWidget {
  const OvalButton({
    super.key,
    required this.title,
    this.padding = 16,
    required this.darkMode,
  });
  final String title;
  final double padding;
  final bool darkMode;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: NeuContainer(
          darkMode: darkMode,
          borderRadius: BorderRadius.circular(50),
          padding:
              EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
          child: SizedBox(
            width: padding * 2,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('darkMode', darkMode));
    properties.add(DoubleProperty('padding', padding));
    properties.add(StringProperty('title', title));
  }
}
