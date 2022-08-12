import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() => runApp(const App());

const double _containerWidth = 450.0;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ],
        child: Consumer<ThemeProvider>(
          child: const HomePage(),
          builder: (c, themeProvider, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.selectedThemeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch:
                  getMaterialColorFromColor(themeProvider.selectedPrimaryColor),
              primaryColor: themeProvider.selectedPrimaryColor,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch:
                  getMaterialColorFromColor(themeProvider.selectedPrimaryColor),
              primaryColor: themeProvider.selectedPrimaryColor,
            ),
            home: child,
          ),
        ),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Theme & Primary Color Switcher'),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 17),
            width: _containerWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Theme'),
                ),
                ThemeSwitcher(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Primary Color'),
                ),
                PrimaryColorSwitcher(),
              ],
            ),
          ),
        ),
      );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode selectedThemeMode = appThemes[0].mode;
  Color selectedPrimaryColor = primaryColors[0];

  void setSelectedThemeMode(ThemeMode themeMode) {
    selectedThemeMode = themeMode;
    notifyListeners();
  }

  void setSelectedPrimaryColor(Color color) {
    selectedPrimaryColor = color;
    notifyListeners();
  }
}

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) => Consumer<ThemeProvider>(
        builder: (c, themeProvider, _) => SizedBox(
          height: (_containerWidth - (17 * 2) - (10 * 2)) / 3,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            crossAxisCount: appThemes.length,
            children: List<Widget>.generate(
              appThemes.length,
              (i) {
                final isSelectedTheme =
                    appThemes[i].mode == themeProvider.selectedThemeMode;
                return GestureDetector(
                  onTap: isSelectedTheme
                      ? null
                      : () =>
                          themeProvider.setSelectedThemeMode(appThemes[i].mode),
                  child: AnimatedContainer(
                    height: 100,
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelectedTheme
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2, color: Theme.of(context).primaryColor),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).cardColor.withOpacity(0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(appThemes[i].icon),
                            Text(
                              appThemes[i].title,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
}

class PrimaryColorSwitcher extends StatelessWidget {
  const PrimaryColorSwitcher({super.key});

  @override
  Widget build(BuildContext context) => Consumer<ThemeProvider>(
        builder: (c, themeProvider, _) => SizedBox(
          height: (_containerWidth - (17 * 2) - (10 * 2)) / 3,
          child: GridView.count(
            crossAxisCount: primaryColors.length,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            children: List<Widget>.generate(
              primaryColors.length,
              (i) {
                final isSelectedColor =
                    primaryColors[i] == themeProvider.selectedPrimaryColor;
                return GestureDetector(
                  onTap: isSelectedColor
                      ? null
                      : () => themeProvider
                          .setSelectedPrimaryColor(primaryColors[i]),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: primaryColors[i],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isSelectedColor ? 1 : 0,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color:
                                  Theme.of(context).cardColor.withOpacity(0.5),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
}

const List<Color> primaryColors = <Color>[
  Color(0xffd23156),
  Color(0xff16b9fd),
  Color(0xff13d0c1),
  Color(0xffe5672f),
  Color(0xffb73d99),
];

Color getShade(Color color, {bool darker = false, double value = .1}) {
  assert(value >= 0 && value <= 1, 'value must be between 0 and 1');

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness(
      (darker ? (hsl.lightness - value) : (hsl.lightness + value))
          .clamp(0.0, 1.0));

  return hslDark.toColor();
}

MaterialColor getMaterialColorFromColor(Color color) {
  final colorShades = <int, Color>{
    50: getShade(color, value: 0.5),
    100: getShade(color, value: 0.4),
    200: getShade(color, value: 0.3),
    300: getShade(color, value: 0.2),
    400: getShade(color),
    500: color,
    600: getShade(color, darker: true),
    700: getShade(color, value: 0.15, darker: true),
    800: getShade(color, value: 0.2, darker: true),
    900: getShade(color, value: 0.25, darker: true),
  };
  return MaterialColor(color.value, colorShades);
}

class AppTheme {
  AppTheme({
    required this.mode,
    required this.title,
    required this.icon,
  });
  ThemeMode mode;
  String title;
  IconData icon;
}

List<AppTheme> appThemes = <AppTheme>[
  AppTheme(
    mode: ThemeMode.light,
    title: 'Light',
    icon: Icons.brightness_5_rounded,
  ),
  AppTheme(
    mode: ThemeMode.dark,
    title: 'Dark',
    icon: Icons.brightness_2_rounded,
  ),
  AppTheme(
    mode: ThemeMode.system,
    title: 'Auto',
    icon: Icons.brightness_4_rounded,
  ),
];
