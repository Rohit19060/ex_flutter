import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: const BottomNavBar(),
      theme: ThemeData(primaryColor: Colors.blueAccent),
    ));

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.blueAccent,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.compare_arrows, size: 30),
          Icon(Icons.call_split, size: 30),
          Icon(Icons.perm_identity, size: 30),
        ],
        buttonBackgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        onTap: (index) => setState(() => _page = index),
        letIndexChange: (index) => true,
      ),
      body: ColoredBox(
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Current Page: $_page',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
              OutlinedButton(
                child: const Text(
                  'Go To Page 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
                onPressed: () {
                  final navBarState = _bottomNavigationKey.currentState;
                  navBarState?.setPage(1);
                },
              )
            ],
          ),
        ),
      ));
}

class CurvedNavigationBar extends StatefulWidget {
  CurvedNavigationBar({
    super.key,
    required this.items,
    this.index = 0,
    this.color = Colors.white,
    this.buttonBackgroundColor,
    this.backgroundColor = Colors.blueAccent,
    this.onTap,
    bool Function(int value)? letIndexChange,
    this.animationCurve = Curves.easeOut,
    this.animationDuration = const Duration(milliseconds: 600),
    this.height = 75.0,
  })  : letIndexChange = letIndexChange ?? ((_) => true),
        assert(items.isNotEmpty, "Items Should'nt be empty"),
        assert(
            0 <= index && index < items.length, 'Length should be above index'),
        assert(0 <= height && height <= 75.0, 'Height should be above 75');
  final List<Widget> items;
  final int index;
  final Color color;
  final Color? buttonBackgroundColor;
  final Color backgroundColor;
  final ValueChanged<int>? onTap;
  final bool Function(int value) letIndexChange;
  final Curve animationCurve;
  final Duration animationDuration;
  final double height;

  @override
  CurvedNavigationBarState createState() => CurvedNavigationBarState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(
        DiagnosticsProperty<Duration>('animationDuration', animationDuration));
    properties
        .add(DiagnosticsProperty<Curve>('animationCurve', animationCurve));
    properties.add(ObjectFlagProperty<bool Function(int value)>.has(
        'letIndexChange', letIndexChange));
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has('onTap', onTap));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties
        .add(ColorProperty('buttonBackgroundColor', buttonBackgroundColor));
    properties.add(ColorProperty('color', color));
    properties.add(IntProperty('index', index));
  }
}

class CurvedNavigationBarState extends State<CurvedNavigationBar>
    with SingleTickerProviderStateMixin {
  int _endingIndex = 0;
  double _buttonHide = 0;
  late double _startingPos;
  late double _pos;
  late Widget _icon;
  late AnimationController _animationController;
  late int _length;

  @override
  void initState() {
    super.initState();
    _icon = widget.items[widget.index];
    _length = widget.items.length;
    _pos = widget.index / _length;
    _startingPos = widget.index / _length;
    _animationController = AnimationController(vsync: this, value: _pos);
    _animationController.addListener(() {
      setState(() {
        _pos = _animationController.value;
        final endingPos = _endingIndex / widget.items.length;
        final middle = (endingPos + _startingPos) / 2;
        if ((endingPos - _pos).abs() < (_startingPos - _pos).abs()) {
          _icon = widget.items[_endingIndex];
        }
        _buttonHide =
            (1 - ((middle - _pos) / (_startingPos - middle)).abs()).abs();
      });
    });
  }

  @override
  void didUpdateWidget(CurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final newPosition = widget.index / _length;
      _startingPos = _pos;
      _endingIndex = widget.index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: widget.backgroundColor,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            bottom: -40 - (75.0 - widget.height),
            left: Directionality.of(context) == TextDirection.rtl
                ? null
                : _pos * size.width,
            right: Directionality.of(context) == TextDirection.rtl
                ? _pos * size.width
                : null,
            width: size.width / _length,
            child: Center(
              child: Transform.translate(
                offset: Offset(
                  0,
                  -(1 - _buttonHide) * 80,
                ),
                child: Material(
                  color: widget.buttonBackgroundColor ?? widget.color,
                  type: MaterialType.circle,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _icon,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0 - (75.0 - widget.height),
            child: CustomPaint(
              painter: NavCustomPainter(
                  _pos, _length, widget.color, Directionality.of(context)),
              child: Container(height: 75.0),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0 - (75.0 - widget.height),
            child: SizedBox(
              height: 100.0,
              child: Row(
                children: widget.items
                    .map((item) => NavButton(
                          onTap: _buttonTap,
                          position: _pos,
                          length: _length,
                          index: widget.items.indexOf(item),
                          child: Center(child: item),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setPage(int index) => _buttonTap(index);

  void _buttonTap(int index) {
    if (!widget.letIndexChange(index)) {
      return;
    }
    if (widget.onTap != null) {
      widget.onTap!(index);
    }
    final newPosition = index / _length;
    setState(() {
      _startingPos = _pos;
      _endingIndex = index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    });
  }
}

class NavCustomPainter extends CustomPainter {
  NavCustomPainter(
      double startingLoc, int itemsLength, this.color, this.textDirection) {
    final span = 1.0 / itemsLength;
    s = 0.2;
    final l = startingLoc + (span - s) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
  }
  late double loc;
  late double s;
  Color color;
  TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo((loc - 0.1) * size.width, 0)
      ..cubicTo(
        (loc + s * 0.20) * size.width,
        size.height * 0.05,
        loc * size.width,
        size.height * 0.60,
        (loc + s * 0.50) * size.width,
        size.height * 0.60,
      )
      ..cubicTo(
        (loc + s) * size.width,
        size.height * 0.60,
        (loc + s - s * 0.20) * size.width,
        size.height * 0.05,
        (loc + s + 0.1) * size.width,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}

class NavButton extends StatelessWidget {
  const NavButton({
    super.key,
    required this.onTap,
    required this.position,
    required this.length,
    required this.index,
    required this.child,
  });
  final double position;
  final int length;
  final int index;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final desiredPosition = 1.0 / length * index;
    final difference = (position - desiredPosition).abs();
    final verticalAlignment = 1 - length * difference;
    final opacity = length * difference;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap(index),
        child: SizedBox(
          height: 75.0,
          child: Transform.translate(
            offset: Offset(
                0, difference < 1.0 / length ? verticalAlignment * 40 : 0),
            child: Opacity(
              opacity: difference < 1.0 / length * 0.99 ? opacity : 1.0,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<int>>.has('onTap', onTap));
    properties.add(IntProperty('index', index));
    properties.add(IntProperty('length', length));
    properties.add(DoubleProperty('position', position));
  }
}

class NeoMorphicNavBar extends StatelessWidget {
  const NeoMorphicNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: const Center(
        child: Text(
          'NeoMorphicNavBar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedNeoButton(
                label: 'Home',
                width: size.width * 0.17,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                isPressed: true,
              ),
              RoundedNeoButton(
                label: 'Bookings',
                width: size.width * 0.17,
                selectedIcon: Icons.book_rounded,
                icon: Icons.book_outlined,
              ),
              RoundedNeoButton(
                label: 'Chats',
                width: size.width * 0.17,
                selectedIcon: Icons.message_rounded,
                icon: Icons.message_outlined,
              ),
              RoundedNeoButton(
                label: 'Profile',
                width: size.width * 0.17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedNeoButton extends StatelessWidget {
  const RoundedNeoButton({
    super.key,
    this.label = '',
    this.width = 70,
    this.selectedIcon = Icons.person_rounded,
    this.icon = Icons.person_outlined,
    this.onTap,
    this.isPressed = false,
  });

  final String label;
  final double width;
  final bool isPressed;
  final IconData selectedIcon;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: isPressed ? null : onTap,
        child: NeuContainer(
          isPressed: isPressed,
          borderRadius: BorderRadius.circular(40),
          child: SizedBox(
            width: width,
            height: width - 35,
            child: Center(
              child: FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isPressed ? selectedIcon : icon),
                    Text(label),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(DiagnosticsProperty<IconData>('selectedIcon', selectedIcon));
    properties.add(DoubleProperty('width', width));
    properties.add(StringProperty('label', label));
    properties.add(DiagnosticsProperty<bool>('isPressed', isPressed));
  }
}

class NeuContainer extends StatefulWidget {
  const NeuContainer({
    super.key,
    this.color = Colors.white,
    required this.child,
    this.borderRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(40),
      bottomRight: Radius.circular(40),
      topLeft: Radius.circular(40),
      topRight: Radius.circular(40),
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.isPressed = false,
    this.disabled = false,
  });
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final Color color;
  final bool isPressed, disabled;

  @override
  State<NeuContainer> createState() => _NeuContainerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties
        .add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<bool>('isPressed', isPressed));
    properties.add(DiagnosticsProperty<bool>('disabled', disabled));
  }
}

class _NeuContainerState extends State<NeuContainer> {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _isPressed = widget.isPressed;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: (event) {
          if (!widget.disabled) {
            setState(() => _isPressed = true);
          }
        },
        onPointerUp: (event) {
          if (!widget.disabled) {
            setState(() => _isPressed = false);
          }
        },
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 250, 250, 250),
            borderRadius: widget.borderRadius,
            boxShadow: _isPressed || widget.isPressed
                ? null
                : [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      offset: const Offset(-2, -2),
                      blurRadius: 15,
                      spreadRadius: 1,
                    )
                  ],
          ),
          child: widget.child,
        ),
      );
}
