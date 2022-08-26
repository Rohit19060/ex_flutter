import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color kBackgroundColor = Colors.white,
    kOnBackgroundColor = Colors.black,
    kPrimaryColor = Colors.blue;

const IconThemeData kiconTheme = IconThemeData(
  color: kBackgroundColor,
  opacity: 1,
  size: 20,
  shadows: [
    Shadow(
      blurRadius: 4,
      offset: Offset(2, 2),
      color: kBackgroundColor,
    )
  ],
);

final TextStyle kTextStyle1 = TextStyle(
  color: kOnBackgroundColor,
  fontSize: 20,
  debugLabel: 'Appbar title',
  background: Paint(),
  fontWeight: FontWeight.normal,
  letterSpacing: 1.5,
  overflow: TextOverflow.ellipsis,
  shadows: const [
    Shadow(
      blurRadius: 4,
      offset: Offset(2, 2),
      color: kBackgroundColor,
    )
  ],
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: kBackgroundColor,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    color: kBackgroundColor,
    titleTextStyle: kTextStyle1,
    elevation: 4,
    backgroundColor: kBackgroundColor,
    actionsIconTheme: kiconTheme,
    foregroundColor: kOnBackgroundColor,
    iconTheme: kiconTheme,
    scrolledUnderElevation: 10,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    titleSpacing: 1.2,
    toolbarHeight: kToolbarHeight,
    toolbarTextStyle: kTextStyle1,
    shadowColor: kBackgroundColor,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: kBackgroundColor),

    // prefixIconColor: blueColor,
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: kBackgroundColor)),
    // enabledBorder: OutlineInputBorder(
    //     borderSide: BorderSide(color: blueColor)),
  ),
  textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kBackgroundColor,
      selectionColor: kBackgroundColor,
      selectionHandleColor: kBackgroundColor),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: kBackgroundColor,
    circularTrackColor: kBackgroundColor,
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))),
    contentTextStyle: TextStyle(fontSize: 16, color: Colors.black),
  ),

  // pageTransitionsTheme: PageTransitionsTheme(builders: )
  primaryColor: kPrimaryColor,
  secondaryHeaderColor: kBackgroundColor,
  applyElevationOverlayColor: true,
  backgroundColor: kBackgroundColor,
  bannerTheme: MaterialBannerThemeData(
    elevation: 4,
    backgroundColor: kBackgroundColor,
    contentTextStyle: kTextStyle1,
    leadingPadding: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(8),
  ),
  bottomAppBarColor: kBackgroundColor,
  bottomAppBarTheme:
      const BottomAppBarTheme(color: kBackgroundColor, elevation: 4),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    showUnselectedLabels: true,
    unselectedItemColor: Colors.black,
    showSelectedLabels: true,
    unselectedIconTheme:
        const IconThemeData(color: Color.fromRGBO(108, 117, 125, 1)),
    selectedIconTheme: const IconThemeData(color: Colors.blue),
    selectedItemColor: Colors.blue,
    backgroundColor: kBackgroundColor,
    elevation: 4,
    enableFeedback: true,
    landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
    mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
  ),
  visualDensity: VisualDensity.comfortable,
  useMaterial3: true,
  unselectedWidgetColor: kBackgroundColor,
  fontFamily: 'Poppins',
  canvasColor: Colors.white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 20),
    bodyMedium: TextStyle(fontSize: 24),
    displayLarge: TextStyle(fontSize: 18),
    displayMedium: TextStyle(fontSize: 16, color: Colors.black),
    displaySmall: TextStyle(fontSize: 14),
    headlineMedium: TextStyle(fontSize: 12),
    headlineSmall: TextStyle(fontSize: 10),
    titleLarge: TextStyle(fontSize: 8),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 5,
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    overlayColor: MaterialStateProperty.all(kBackgroundColor),
  ),

  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shadowColor: kBackgroundColor,
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  canvasColor: const Color.fromRGBO(31, 31, 31, 0.6),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    showUnselectedLabels: true,
    backgroundColor: kBackgroundColor,
    unselectedItemColor: kBackgroundColor,
    showSelectedLabels: true,
    unselectedIconTheme: IconThemeData(
      color: kBackgroundColor,
    ),
    selectedIconTheme: IconThemeData(
      color: Colors.white,
    ),
    selectedItemColor: Colors.white,
  ),
  switchTheme: SwitchThemeData(
    overlayColor: MaterialStateProperty.all(Colors.white),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 20),
    bodyMedium: TextStyle(fontSize: 24),
    displayLarge: TextStyle(fontSize: 18),
    displayMedium: TextStyle(fontSize: 16, color: Colors.white),
    displaySmall: TextStyle(fontSize: 14),
    headlineMedium: TextStyle(fontSize: 12),
    headlineSmall: TextStyle(fontSize: 10),
    titleLarge: TextStyle(fontSize: 8),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: kBackgroundColor,
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white, size: 22),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 5,
    ),
  ),
  fontFamily: 'Poppins',
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: kBackgroundColor),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    overlayColor: MaterialStateProperty.all(kBackgroundColor),
  ),
  cardTheme: const CardTheme(
      color: kBackgroundColor,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)))),
  scaffoldBackgroundColor: kBackgroundColor,
);
