import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigationModel {
  NavigationModel({
    required this.title,
    required this.iconData,
  });
  String title;
  IconData iconData;
}

List<NavigationModel> navigationItems = [
  NavigationModel(
    title: 'Dashboard',
    iconData: Icons.insert_chart,
  ),
  NavigationModel(
    title: 'Error',
    iconData: Icons.error,
  ),
  NavigationModel(
    title: 'Search',
    iconData: Icons.search,
  ),
  NavigationModel(
    title: 'Notifications',
    iconData: Icons.notifications,
  ),
  NavigationModel(
    title: 'Settings',
    iconData: Icons.settings,
  ),
];

TextStyle listTitleDefaultTextStyle = const TextStyle(
  color: Colors.white70,
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
);
TextStyle listTitleSelectedTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
);

Color selectedColor = const Color(0xFF4AC8EA);
Color drawerBackgroundColor = const Color(0xFF272D34);

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: drawerBackgroundColor,
        ),
      );
}

class CollapsingNavigation extends StatelessWidget {
  const CollapsingNavigation({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Collapsible Navigation Drawer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Collapsing Navigation Drawer/Sidebar'),
            backgroundColor: drawerBackgroundColor,
            elevation: 0.0,
          ),
          // drawer: CollapsingNavigationDrawer(),
          body: Stack(
            children: <Widget>[
              Container(
                color: selectedColor,
              ),
              const CollapsingNavigationDrawer(),
            ],
          ),
        ),
      );
}

class CollapsingListTile extends StatefulWidget {
  const CollapsingListTile({
    required this.title,
    required this.iconData,
    required this.animationController,
    this.isSelected = false,
    this.onTap,
  });
  final String title;
  final IconData iconData;
  final AnimationController animationController;
  final bool isSelected;
  final Function()? onTap;

  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Function()?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(DiagnosticsProperty<AnimationController>(
        'animationController', animationController));
    properties.add(DiagnosticsProperty<IconData>('iconData', iconData));
    properties.add(StringProperty('title', title));
  }
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  late Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation = Tween<double>(
      begin: 220.0,
      end: 70.0,
    ).animate(widget.animationController);

    sizedBoxAnimation = Tween<double>(
      begin: 10.0,
      end: 0.0,
    ).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: widget.onTap,
        child: Container(
          width: widthAnimation.value,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: widget.isSelected
                ? Colors.transparent.withOpacity(0.3)
                : Colors.transparent,
          ),
          child: Row(
            children: <Widget>[
              Icon(
                widget.iconData,
                color: widget.isSelected ? selectedColor : Colors.white30,
                size: 38.0,
              ),
              SizedBox(
                width: sizedBoxAnimation.value,
              ),
              if (widthAnimation.value >= 220)
                Text(
                  widget.title,
                  style: widget.isSelected
                      ? listTitleSelectedTextStyle
                      : listTitleDefaultTextStyle,
                )
              else
                Container(),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Animation<double>>(
        'sizedBoxAnimation', sizedBoxAnimation));
    properties.add(DiagnosticsProperty<Animation<double>>(
        'widthAnimation', widthAnimation));
  }
}

class CollapsingNavigationDrawer extends StatefulWidget {
  const CollapsingNavigationDrawer({super.key});

  @override
  _CollapsingNavigationDrawerState createState() =>
      _CollapsingNavigationDrawerState();
}

class _CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 220.0;
  double minWidth = 70.0;
  late AnimationController _animationController;
  bool isCollapsed = false;
  late Animation<double> _widthAnimation;
  int currentSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        builder: getWidget,
      );

  Widget getWidget(context, widget) => Material(
        elevation: 8.0,
        child: Container(
          width: _widthAnimation.value,
          color: drawerBackgroundColor,
          child: Column(
            children: <Widget>[
              CollapsingListTile(
                title: 'Barry Allen',
                iconData: Icons.person,
                animationController: _animationController,
              ),
              const Divider(
                color: Colors.grey,
                height: 40.0,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 12.0,
                  ),
                  itemCount: navigationItems.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      setState(() {
                        currentSelectedIndex = index;
                        if (currentSelectedIndex == 0) {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => const Dashboard(),
                                ),
                              )
                              .then((value) => setState(() {
                                    _animationController.forward();
                                  }));
                        }
                      });
                    },
                    child: CollapsingListTile(
                      title: navigationItems[index].title,
                      iconData: navigationItems[index].iconData,
                      animationController: _animationController,
                      isSelected: currentSelectedIndex == index,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isCollapsed = !isCollapsed;
                    isCollapsed
                        ? _animationController.forward()
                        : _animationController.reverse();
                  });
                },
                child: AnimatedIcon(
                  progress: _animationController,
                  icon: AnimatedIcons.close_menu,
                  color: selectedColor,
                  size: 50.0,
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('currentSelectedIndex', currentSelectedIndex));
    properties.add(DiagnosticsProperty<bool>('isCollapsed', isCollapsed));
    properties.add(DoubleProperty('minWidth', minWidth));
    properties.add(DoubleProperty('maxWidth', maxWidth));
  }
}
